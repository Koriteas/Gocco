//
//  GoccoAPI.swift
//  Gocco
//
//  Created by Carlos Santana on 11/06/2019.
//  Copyright © 2019 Carlos Santana. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire

enum RequestError: Error {
    case request(code: Int, error: Error?)
    case unknown
}

class GoccoAPI {
    
    // HACK
    let storeID = 12
    
    static let shared = GoccoAPI()
    
    private let session: Session = {
        return Alamofire.Session()
    }()
    
    func getHomeCategories() -> Publishers.Future<[Category], RequestError> {
        Publishers.Future { [weak self] promise in
            guard let self = self else { promise(.failure(.unknown)); return }
            
            self.session
                .request(Router.home(storeID: self.storeID))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        guard let json = json as? [String: Any],
                            let categoriesJSON = json["categories"] else { promise(.failure(.unknown)); return }

                        do {
                            let decoder = JSONDecoder()
                            let data = try JSONSerialization.data(withJSONObject: categoriesJSON, options: JSONSerialization.WritingOptions.prettyPrinted)
                            let categories = try decoder.decode([Category].self, from: data)
                            promise(.success(categories))
                        } catch {
                            promise(.failure(.unknown))
                        }
                       
                    case .failure(let error):
                        promise(.failure(.request(code: response.response?.statusCode ?? 400, error: error)))
                        
                    }
                }
        }
    }
    
    func searchItems(by query: String? = nil, categoryID: Int? = nil, sort: String = "name", page: Int = 1) -> Publishers.Future<SearchResult, RequestError> {
        Publishers.Future {  [weak self] promise in
            guard let self = self else { promise(.failure(.unknown)); return }
            
            var parameters: Parameters = [
                "order": sort,
                "page": page
            ]
            
            if let query = query {
                parameters["with_text"] = query
            }
            
            if let categoryID = categoryID {
                parameters["category_id"] = String(categoryID)
            }
            
            self.session
                .request(Router.searchItems(storeID: self.storeID, parameters: parameters))
                .validate()
//                .responseJSON { response in
//                    print(response.result)
//                    print("HERE")
//                }
                
                .responseDecodable { (response: DataResponse<SearchResult>) in
                    switch response.result {
                    case .success(let search):
                        promise(.success(search))

                    case .failure(let error):
                        promise(.failure(.request(code: response.response?.statusCode ?? 400, error: error)))

                    }
                }
        }
    }
}
