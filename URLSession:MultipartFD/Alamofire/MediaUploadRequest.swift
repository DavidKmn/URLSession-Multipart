//
//  MediaUploadRequest.swift
//  URLSession:MultipartFD
//
//  Created by David on 21/05/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
import Alamofire


struct APIStrings {
    static let baseUrl = "http://ec2-18-188-218-144.us-east-2.compute.amazonaws.com:3000/image_entities?image_owner_id=d7e28850-0fa8-42f0-8087-69ec08684bbe&image_owner_type=Business"
}

protocol UploadableFile {
    var key: String { get }
    var fileName: String { get }
    var mimeType: String { get }
    var data: Data { get }
}

struct MediaUploadRequest: HTTPRequestRepresentable {
    
    var parameters: JSON?
    private(set) var httpMethod: HTTPMethod = .post
    private(set) var path: String = ""
    private(set) var body: Data? = nil
    private(set) var encoding: ParameterEncoding = JSONEncoding.default
    var headerFields: [String: String]? = nil
    
    var media: [UploadableFile]
    
    init(path: String, media: [UploadableFile]) {
        self.path = APIStrings.baseUrl + path
        self.media = media
        
        let boundary = generateBoundaryString()
        setHeaderValue("multipart/form-data; boundary=\(boundary)", forKey: "Content-Type")
        setHeaderValue("Bearer 99QvJFXMhsT37rAg5Rcg5Mk6Fu39apdtLqCYeZ1w5gZRJQE4x6wybCDzq9RP3mHsfr3DSdETzq4zxWqjtHYgk9vJYjCELBnoN3CAgdLLTgeynnL4zBEcEkrRJGU2cDHT", forKey: "Authorization")
        self.body = self.createDataUploadBody(withParameters: parameters, media: media, boundary: boundary)
    }
    
    
    private func createDataUploadBody(withParameters parameters: JSON?, media: [UploadableFile], boundary: String) -> Data {
        
        var body = Data()
        let lineBreak = "\r\n"
        
        if let parameters = parameters as? [String: String] {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\((value) + lineBreak)")
            }
        }
        
        for mediaItem in media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(mediaItem.key)\"; filename =\"\(mediaItem.fileName)\"\(lineBreak)")
            body.append("Content-Type: \(mediaItem.mimeType + lineBreak + lineBreak)")
            body.append(mediaItem.data)
            body.append(lineBreak)
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let dataFromString = string.data(using: .utf8, allowLossyConversion: false) {
            self.append(dataFromString)
        }
    }
}
