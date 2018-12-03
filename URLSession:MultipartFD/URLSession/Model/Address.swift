//
//  Address.swift
//  URLSession:MultipartFD
//
//  Created by David on 22/05/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
struct Address: Codable {
    let street: String?
    let suite: String?
    let city: String?
    let zipCode: String?
    
    private enum CodingKeys: String, CodingKey {
        case street
        case suite
        case city
        case zipCode = "zipcode"
    }
}

