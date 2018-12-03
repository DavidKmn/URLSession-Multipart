//
//  ViewController.swift
//  URLSession:MultipartFD
//
//  Created by David on 18/05/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

typealias Parameters = [String: String]

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postRequest()
    }

    private func getRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        var request = URLRequest(url: url)
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let dataBody = dataUploadBody(withParameters: nil, media: nil, boundary: boundary)
        request.httpBody = dataBody
 
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            print("HTTP status code: ", response.statusCode)
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let users = try decoder.decode([User].self, from: data)
                    let usernames = users.compactMap { $0.username }
                    usernames.forEach { print($0); print("\n") }
                } catch let decodingError {
                    print(decodingError.localizedDescription)
                }
            }
            
        }
        
        task.resume()
    }
    
    private func postRequest() {
        let parameters = ["name": "TestFile1241243124", "description" : "My test for multi-part data uploading"]
        
        guard let mediaImage = Media(withPhoto: #imageLiteral(resourceName: "gal-gadot"), forKey: "image") else { return }
        
        guard let url = URL(string: "https://api.imgur.com/3/image") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Client-ID 08f204ff17c7b3d", forHTTPHeaderField: "Authorization")
        
        let dataBody = dataUploadBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<299)~=response.statusCode else {
                return
            }
            
            print("HTTP status code: ", response.statusCode)
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch let decodingError {
                    print(decodingError.localizedDescription)
                }
            }
            
        }
        
        task.resume()
    }
  
    func dataUploadBody(withParameters parameters: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        var body = Data()
        let lineBreak = "\r\n"
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for mediaItem in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(mediaItem.key)\"; filename =\"\(mediaItem.filename)\"\(lineBreak)")
                body.append("Content-Type: \(mediaItem.mimeType + lineBreak + lineBreak)")
                body.append(mediaItem.data)
                body.append(lineBreak)
            }
        }

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

}







