//
//  ContentView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-26.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var searchedCity: City = City(
        name: "London",
        coordinate: CLLocationCoordinate2D(
            latitude: 51.5074, longitude: -0.1277))

    var body: some View {
        TabView {
            CurrentWeatherView(searchedCity: $searchedCity)
                .tabItem {
                    Label("Current", systemImage: "cloud")
                }
            DailyWeatherView(searchedCity: $searchedCity)
                .tabItem {
                    Label("5-Day", systemImage: "calendar")
                }
            AttractionsView(searchedCity: $searchedCity)
                .tabItem {
                    Label("Attractions", systemImage: "map")
                }
            SavedCitiesView(searchedCity: $searchedCity)
                .tabItem {
                    Label("Saved Cities", systemImage: "globe")
                }
        }
        .tint(.cyan.opacity(0.9))
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
