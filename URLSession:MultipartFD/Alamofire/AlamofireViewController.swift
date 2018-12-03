//
//  AlamofireViewController.swift
//  URLSession:MultipartFD
//
//  Created by David on 20/05/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AlamofireViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let apiClient = AFAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
       
        setupMedia { (media) in
            self.upload(media: media)
        }
    }

    private func setupMedia(onCompletion: @escaping (UploadableFile) -> Void) {
        guard let data = UIImageJPEGRepresentation(#imageLiteral(resourceName: "gal-gadot"), 0.7) else { return }
        let photo = Photo(key: "image", fileName: "photo\(arc4random()).jpeg", mimeType: "image/jpeg", data: data)
        onCompletion(photo)
    }
    
    private func upload(media: UploadableFile) {
        let request = MediaUploadRequest(path: "", media: [media])
        let responseObervable: Observable<ImgurResponse> = apiClient.sendRequest(request)
        responseObervable.subscribe(onNext: { response in
            print(response)
        }).disposed(by: disposeBag)
    }
}

