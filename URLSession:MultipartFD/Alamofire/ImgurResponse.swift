//
//  ImgurResponse.swift
//  URLSession:MultipartFD
//
//  Created by David on 21/05/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
struct ImgurResponse {
    let link: String
    let id: String
    let type: String
    let dateAndTime: Int
    
    enum RootKeys: String, CodingKey {
        case data
    }
    
    private enum DataResponseKeys: String, CodingKey {
        case link
        case id
        case type
        case dateAndTime = "datetime"
    }
    
}

extension ImgurResponse: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        let dataResponseContainer = try container.nestedContainer(keyedBy: DataResponseKeys.self, forKey: .data)
        
        link = try dataResponseContainer.decode(String.self, forKey: .link)
        id = try dataResponseContainer.decode(String.self, forKey: .id)
        type = try dataResponseContainer.decode(String.self, forKey: .type)
        dateAndTime = try dataResponseContainer.decode(Int.self, forKey: .dateAndTime)
    }
}
