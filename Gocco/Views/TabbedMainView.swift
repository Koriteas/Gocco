//
//  ContentView.swift
//  Gocco
//
//  Created by Carlos Santana on 11/06/2019.
//  Copyright © 2019 Carlos Santana. All rights reserved.
//

import SwiftUI

struct TabbedMainView : View {
    @State private var selection = 0

    var body: some View {
        TabbedView(selection: $selection) {
            CategoryList()
                .environmentObject(CategoryViewModel())
                .tabItemLabel(Image("home"))
                .tag(0)
            Text("Second View")
                .font(.title)
                .tabItemLabel(Image("second"))
                .tag(1)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        TabbedMainView()
    }
}
#endif
