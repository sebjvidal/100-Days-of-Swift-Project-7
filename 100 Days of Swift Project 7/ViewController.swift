//
//  ViewController.swift
//  100 Days of Swift Project 7
//
//  Created by Seb Vidal on 26/11/2021.
//

import UIKit

class ViewController: UITableViewController {

    var petitions: [Petition] = []
    var filteredPetitions: [Petition] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        fetchData()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Whitehouse Petitions"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(sortButtonTapped))
    }
    
    @objc func showCredits() {
        let title = "Credits"
        let message = "These petitions are courtesy of the Whitehouse's We The People API."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default))
        
        present(alertController, animated: true)
    }
    
    @objc func sortButtonTapped() {
        if filteredPetitions.isEmpty {
            sortPetitions()
        } else {
            filteredPetitions.removeAll()
            tableView.reloadData()
            navigationItem.leftBarButtonItem?.title = "Filter"
        }
    }
    
    func sortPetitions() {
        let title = "Filter"
        let message = "Filter petitions matching:"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Filter", style: .default, handler: { alert in
            if let filter = alertController.textFields?[0].text?.lowercased() {
                self.filteredPetitions = self.petitions.filter({ petition in
                    return petition.title.lowercased().contains(filter) || petition.body.lowercased().contains(filter)
                })
                
                if self.filteredPetitions.isEmpty {
                    self.showNoResults(for: filter)
                } else {
                    self.navigationItem.leftBarButtonItem?.title = "Clear"
                }
            }
            
            self.tableView.reloadData()
        }))
        
        present(alertController, animated: true)
    }
    
    func showNoResults(for keywords: String) {
        let title = "No Results Found"
        let message = "There were no petitions found matching keywords \(keywords)."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
    
    func fetchData() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    func showError() {
        let alertController = UIAlertController(title: "Error", message: "There was a problem encoutered while loading the feed.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredPetitions.isEmpty {
            return petitions.count
        } else {
            return filteredPetitions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petition: Petition
        
        if filteredPetitions.isEmpty {
            petition = petitions[indexPath.row]
        } else {
            petition = filteredPetitions[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.detailItem = petitions[indexPath.row]
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

