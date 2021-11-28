//
//  Petition.swift
//  100 Days of Swift Project 7
//
//  Created by Seb Vidal on 26/11/2021.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
