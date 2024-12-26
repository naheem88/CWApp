//
//  NavTabView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WeatherView()
                .tabItem {
                    Label("Weather", systemImage: "cloud")
                }
            AttractionsView()
                .tabItem {
                    Label("Attractions", systemImage: "map")
                }
        }
    }
}

#Preview {
    ContentView()
}
