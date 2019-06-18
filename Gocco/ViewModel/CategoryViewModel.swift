//
//  CategoryViewModel.swift
//  Gocco
//
//  Created by Carlos Santana on 13/06/2019.
//  Copyright © 2019 Carlos Santana. All rights reserved.
//

import SwiftUI
import Combine

final class CategoryViewModel: BindableObject {

    var didChange = PassthroughSubject<CategoryViewModel, Never>()
    
    private(set) var parentCategory: Category?
    
    private(set) var categories: [Category] = [] {
        didSet { didChange.send(self) }
    }
    
    private var cancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }
    
    init(parentCategory: Category? = nil, categories: [Category]? = nil) {
        self.parentCategory = parentCategory
        
        guard let categories = categories else {
            cancellable = GoccoAPI.shared.getHomeCategories()
                            .eraseToAnyPublisher()
                            .replaceError(with: [])
                            .assign(to: \.categories, on: self)
            return
        }
        self.categories = categories
    }
}
