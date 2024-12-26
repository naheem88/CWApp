//
//  WeatherView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-04.
//

import MapKit
import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var selectedCity: City?
    @State var cityName: String = ""

    var body: some View {
            NavigationStack {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.05, green: 0.08, blue: 0.20),
                            Color(red: 0.08, green: 0.12, blue: 0.28),
                            Color(red: 0.12, green: 0.16, blue: 0.32),
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search for City", text: $cityName)
                                .onSubmit {
                                    viewModel.getCoordinateFrom(
                                        address: cityName)
                                    if let coordinate = viewModel.coordinate {
                                        print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
                                        
                                    } else if let error = viewModel.geocodingError {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                }
                        }
                        .padding(9)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)

                    NavigationLink(
                        destination: MapView(selectedCity: $selectedCity)
                    ) {
                        Label(
                            "Favourite Cities Map View",
                            systemImage: "location.circle")
                    }
                    .padding(2)

                    SelectedCountryView(
                        selectedCity: Binding.constant(
                            selectedCity ?? City.bristol))

                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: FavCountrySelectView()) {
                            Image(systemName: "heart")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WeatherView()
        .environmentObject(ViewModel())
}

