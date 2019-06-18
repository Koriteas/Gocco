//
//  SearchItemViewModel.swift
//  Gocco
//
//  Created by Carlos Santana on 16/06/2019.
//  Copyright © 2019 Carlos Santana. All rights reserved.
//

import SwiftUI
import Combine

enum SearchPage {
    case nextPage(Int)
    case limit
}

final class SearchItemViewModel: BindableObject {
    
    var didChange = PassthroughSubject<SearchItemViewModel, Never>()
    
    var showSearchBar = true
    
    var query: String = "" {
        didSet {
            resetSearch()
            didChange.send(self)
        }
    }
    
    var category: Category? {
        didSet { didChange.send(self) }
    }
    
    private(set) var items = [Item]() {
        didSet { didChange.send(self) }
    }
    
    private(set) var filters = [FilterGeneric]() {
        didSet { didChange.send(self) }
    }
    
    private var nextPage: SearchPage = .nextPage(1)
    
    private var cancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }
    
    init(showSearchBar: Bool = true, category: Category? = nil ) {
        self.showSearchBar = showSearchBar
        self.category = category
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func search() {
        guard case .nextPage(let page) = nextPage, query.isNotBlank || category != nil else { return }
        
        cancellable = GoccoAPI.shared.searchItems(by: query, categoryID: category?.id, page: page)
                        .eraseToAnyPublisher()
                        .sink(receiveValue: { [weak self] result in
                            guard let self = self else { return }
                            
                            self.items.append(contentsOf: result.items)
                            self.filters = result.filters
                            self.nextPage = result.count < 10 ? .limit : .nextPage(page + 1)
                        })
    }
    
    func resetSearch() {
        items = []
        filters = []
        nextPage = .nextPage(1)
    }
}
