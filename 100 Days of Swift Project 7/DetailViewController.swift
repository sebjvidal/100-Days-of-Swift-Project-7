//
//  DetailViewController.swift
//  100 Days of Swift Project 7
//
//  Created by Seb Vidal on 27/11/2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?

    override func loadView() {
        setupWebView()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHTML()
    }
    
    func setupWebView() {
        webView = WKWebView()
        view = webView
    }
    
    func loadHTML() {
        guard let detailItem = detailItem else {
            return
        }
        
        let html = """
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style> body { font-family: '-apple-system','HelveticaNeue'; font-size: 100% } </style>
</head>
<body>
<h2>\(detailItem.title)</h2>
\(detailItem.body)
<p>
\(detailItem.signatureCount) signatures.
</p>
</body>
</html>
"""
        
        webView.loadHTMLString(html, baseURL: nil)
    }

}
