//
//  Media.swift
//  URLSession:MultipartFD
//
//  Created by David on 22/05/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withPhoto photo: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "photo\(arc4random()).jpeg"
        
        guard let data = UIImageJPEGRepresentation(photo, 0.7) else { return nil }
        self.data = data
    }
}
