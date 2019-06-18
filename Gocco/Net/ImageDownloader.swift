//
//  ImageDownloader.swift
//  Gocco
//
//  Created by Carlos Santana on 13/06/2019.
//  Copyright © 2019 Carlos Santana. All rights reserved.
//

import UIKit
import Combine
import Alamofire
import AlamofireImage

class ImageConnector {

    static let shared = ImageConnector()

    private let cacheImage = ImageDownloader()
    
    func getImage(by url: String, filter: ImageFilter? = nil) -> Publishers.Future<UIImage, RequestError> {
        guard let url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let completeURL = try? url.asURL() else {
                return Publishers.Future<UIImage, RequestError> { promise in promise(.failure(.unknown)) }
        }

        return getImage(by: completeURL, filter: filter)
    }
    
    func getImage(by url: URL, filter: ImageFilter? = nil) -> Publishers.Future<UIImage, RequestError> {
        return Publishers.Future<UIImage, RequestError> { [weak self] promise in
            guard let self = self else { return }
            
            // HACK: Generate random image
            let hackURL = URL(string: "https://picsum.photos/1000?\(UUID().description)")!
            
            self.cacheImage.download(URLRequest(url: hackURL), filter: filter) { response in
                switch response.result {
                case .success(let image):
                    promise(.success(image))
                    
                case .failure(let error):
                    promise(.failure(.request(code: response.response?.statusCode ?? 400 , error: error)))
                    
                }
            }
        }
    }
}
