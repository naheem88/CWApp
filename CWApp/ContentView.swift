//
//  CountryListView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-04.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var selectedCity: City?
    @State var cityName: String = ""
    @AppStorage("isDark") var isLightMode: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search for City", text: $cityName)
                            .onSubmit {
                                viewModel.getCoordinateFrom(address: cityName)
                            }
                    }
                    .padding(9)
                }
                .background(
                    Color(uiColor: isLightMode ? .systemGray6 : .systemGray4)
                )
                .cornerRadius(10)
                    
                NavigationLink(destination: MapView(selectedCity: $selectedCity)) {
                    Label("Pick from favourites", systemImage: "location.circle")
                }
                .padding()
            }
            .padding()
            .navigationTitle("Country List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: FavCountrySelectView()) {
                        Image(systemName: "heart")
                    }
                }
            }
            .onAppear {
                if selectedCity != nil {
                    
                }
            }
        }
        .environment(\.colorScheme, isLightMode ? .light : .dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
