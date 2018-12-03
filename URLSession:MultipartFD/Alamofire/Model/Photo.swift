//
//  Photo.swift
//  URLSession:MultipartFD
//
//  Created by David on 21/05/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class Photo: UploadableFile {
    var key: String
    var fileName: String
    var mimeType: String
    var data: Data
    
    init(key: String, fileName: String, mimeType: String, data: Data) {
        self.key = key
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
    
}
