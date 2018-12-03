//
//  HTTPRequestRepresentable.swift
//  URLSession:MultipartFD
//
//  Created by David on 21/05/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = [String: Any]

protocol HTTPRequestRepresentable: URLRequestConvertible {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var parameters: JSON? { get set }
    var headerFields: [String: String]? { get set }
    var body: Data? { get }
    var encoding: ParameterEncoding { get }
}

extension HTTPRequestRepresentable {
    
    mutating func setHeaderValue(_ value: String, forKey key: String) {
        if headerFields == nil {
            headerFields = [:]
        }
        headerFields![key] = value
    }
    
    var url: URL? {
        guard var urlComponents = URLComponents(string: self.path) else {
            return nil
        }
        
        if let parametersJSON = self.parameters {
            var queryItems = [URLQueryItem]()
            for (key, value) in parametersJSON {
                queryItems.append(URLQueryItem(name: key, value: value as? String))
            }
            urlComponents.queryItems = queryItems
        }
        return urlComponents.url
    }
    
    func asURLRequest() throws -> URLRequest {
        
        guard let url = self.url else {
            throw NetworkError.wrongUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headerFields
        if let body = body {
            urlRequest.httpBody = body
        }
        
        return urlRequest
    }
}
