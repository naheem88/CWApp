//
//  NavBarView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-04.
//

import SwiftUI

struct NavBarView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("", systemImage: "location.fill")
                        .imageScale(.large)
                        .foregroundStyle(.white)
                }
            HomeView()
                .tabItem {
                    Label("", systemImage: "list.bullet")
                        .imageScale(.large)
                        .foregroundStyle(.white)
                }
        }
        .accentColor(.white)
    }
}

#Preview {
    NavBarView()
}
