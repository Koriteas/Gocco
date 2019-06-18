//
//  Category.swift
//  Gocco
//
//  Created by Carlos Santana on 11/06/2019.
//  Copyright © 2019 Carlos Santana. All rights reserved.
//

import SwiftUI

class Category: Identifiable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "categoryId"
        case name = "label"
        case imageURL = "imageUrl"
        case subCategories = "children"
    }
    
    let id: Int
    let name: String
    let imageURL: URL?
    let subCategories: [Category]?
    var image: Image?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = Int(try container.decode(String.self, forKey: .id)) ?? 0
        name = try container.decode(String.self, forKey: .name)
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
        subCategories = try container.decodeIfPresent([Category].self, forKey: .subCategories)
    }
    
    func loadImage() {
        guard let url = imageURL, image == nil else { return }
        
        _ = ImageConnector.shared.getImage(by: url)
                        .eraseToAnyPublisher()
                        .replaceError(with: UIImage())
                        .sink(receiveValue: { [weak self] uiImage in
                            self?.image = Image(uiImage: uiImage)
                        })
    }
}
