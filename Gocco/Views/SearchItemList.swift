//
//  SearchItemList.swift
//  Gocco
//
//  Created by Carlos Santana on 16/06/2019.
//  Copyright © 2019 Carlos Santana. All rights reserved.
//

import SwiftUI

struct SearchItemList : View {
    
    @EnvironmentObject var viewModel: SearchItemViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                SearchItemBar(query: viewModel[\.query]) {
                    self.viewModel.search()
                }
            }
            .navigationBarTitle(Text(viewModel.category?.name ?? "Products".localized))
        }
        .onAppear() { self.viewModel.search() }
    }
}

struct SearchItemBar : View {
    
    @Binding var query: String
    @State var action: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                TextField($query,
                          placeholder: Text("Search products".localized)
                                            .color(Color.gray),
                          onEditingChanged: { _ in self.action() },
                          onCommit: { self.action() })
                    .padding([.leading, .trailing], 8)
                    .frame(height: 32)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Button(action: action,
                       label: { Text("Search".localized) })
                    .foregroundColor(Color.blue)
            }
            .padding([.leading, .trailing], 16)
            
            Image("search")
                .resizable()
                .relativeWidth(0.3)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.gray)
        }
        .frame(height: 64)
    }
}

