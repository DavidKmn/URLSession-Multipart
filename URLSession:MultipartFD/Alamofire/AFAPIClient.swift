//
//  APIClient.swift
//  URLSession:MultipartFD
//
//  Created by David on 21/05/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class CustomServerTrustPolicyManager: ServerTrustPolicyManager {
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        // Check if we have a policy already defined, otherwise just kill the connection
        if let policy = super.serverTrustPolicy(forHost: host) {
            print(policy)
            return policy
        } else {
            return .customEvaluation({ (_, _) -> Bool in
                return false
            })
        }
    }
}

class AFAPIClient {
    
    var serverTrustPolicy: ServerTrustPolicy!
    var serverTrustPolicies: [String: ServerTrustPolicy]!
    
    var isSimulatingCertificateCorruption = false
    let nameOfCertificateFile = "name-of-certificate-file"

    var afManager: SessionManager!

    func configureAlamofireSSLPinning() {
        let pathToCert = Bundle.main.path(forResource: nameOfCertificateFile, ofType: "cer")
        let localCerificateData: NSData = NSData(contentsOfFile: pathToCert!)!

        self.serverTrustPolicy = ServerTrustPolicy.pinCertificates(
            // Getting the certificate from the certificate data
            certificates: [SecCertificateCreateWithData(nil, localCerificateData)!],
            // Choose to validate the complete certificate chain, not only the certificate itself
            validateCertificateChain: true,
            // Check that the certificate matches the host who provided it
            validateHost: true)
        
        serverTrustPolicies = [
            "my-server.com" : serverTrustPolicy
        ]
        
        self.afManager = SessionManager(configuration: URLSessionConfiguration.default, serverTrustPolicyManager: ServerTrustPolicyManager(policies: self.serverTrustPolicies))
        

    }
    
    func sendRequest<T: Decodable>(_ request: HTTPRequestRepresentable) -> Observable<T> {

        return Observable<T>.create { observer in
            
            let dataRequest = Alamofire.request(request)
                .downloadProgress { progress in
                    print("Fraction of Task Completed: ", progress.fractionCompleted)
                }
                .response { dataResponse in
                    if let error = dataResponse.error {
                        print(error)
                    }
                    
                    if let response = dataResponse.response, response.statusCode != 200 {
                        print(response.statusCode)
                        return
                    }
                    print("Status Code: \(dataResponse.response!.statusCode)")
                    guard let data = dataResponse.data else { return }
                    let decoder = JSONDecoder()
                    do {
                        let model =  try decoder.decode(T.self, from: data)
                        observer.onNext(model)
                    } catch {
                        print(error.localizedDescription)
                    }
            }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
}
