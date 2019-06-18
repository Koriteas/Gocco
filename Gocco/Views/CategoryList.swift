//
//  CategoryView.swift
//  Gocco
//
//  Created by Carlos Santana on 13/06/2019.
//  Copyright © 2019 Carlos Santana. All rights reserved.
//

import SwiftUI

struct CategoryList : View {
    
    @EnvironmentObject var viewModel: CategoryViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: EmptyView(),
                        footer: EmptyView()) {
                    ForEach(viewModel.categories) { category in
                        if !(category.subCategories?.isEmpty ?? true) {
                            NavigationButton(destination: CategoryList().environmentObject(CategoryViewModel(parentCategory: category, categories: category.subCategories!))) {
                                CategoryRow(category: category).onAppear {
                                    category.loadImage()
                                }
                            }
                        } else {
                            NavigationButton(destination: SearchItemList().environmentObject(SearchItemViewModel(showSearchBar: false, category: category))) {
                                CategoryRow(category: category)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text(viewModel.parentCategory?.name ?? NSLocalizedString("GOCCO", comment: "")), displayMode: .large)
        }
    }
}

struct CategoryRow : View {
    @State var category: Category
    
    var body: some View {
        HStack {
            if (category.image != nil) {
                category
                    .image!
                    .resizable()
                    .frame(height: 300)
                    .clipped()
                    .cornerRadius(5)
                    .overlay(Text(category.name)
                        .color(.white)
                        .bold()
                        .offset(y: -15)
                        .font(.largeTitle)
                        .shadow(radius: 5),
                             alignment: .bottom)
            } else {
                Text(category.name)
                    .color(.primary)
                    .font(.headline)
            }
        }
    }
}

struct EmptyView : View {
    var body: some View {
        Rectangle()
            .foregroundColor(.white)
            .listRowInsets(EdgeInsets())
    }
}

#if DEBUG
//struct CategoryView_Previews : PreviewProvider {
//    static var previews: some View {
//        CategoryList()
//    }
//}
#endif
