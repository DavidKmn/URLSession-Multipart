//
//  User.swift
//  URLSession:MultipartFD
//
//  Created by David on 22/05/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
struct User: Codable {
    let id: Int
    let name: String
    let username: String?
    let email: String?
    let address: Address?
    let phone: String?
    let website: String?
    let company: Company?
}

