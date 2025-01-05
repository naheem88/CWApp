//
//  AttractionsView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-26.
//

import MapKit
import SwiftUI

struct AttractionsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var searchedCity: City
    @State var touristLocations: [MKMapItem] = []

    func fetchNearbyAttractions() {
        let city = searchedCity
        let request = MKLocalSearch.Request()

        request.naturalLanguageQuery = "tourist attractions"
        request.region = MKCoordinateRegion(
            center: city.coordinate,
            latitudinalMeters: 4000,
            longitudinalMeters: 4000
        )

        let search = MKLocalSearch(request: request)

        search.start { response, error in
            guard let response = response, error == nil else {
                print(
                    "Error searching for locations: \(error?.localizedDescription ?? "")"
                )
                return
            }

            touristLocations = Array(response.mapItems.prefix(5))
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.50, green: 0.55, blue: 0.75),
                    Color(red: 0.40, green: 0.45, blue: 0.65),
                    Color(red: 0.30, green: 0.35, blue: 0.55),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                SearchView(searchedCity: $searchedCity)
                    .padding(.vertical)
                Map {
                    ForEach(touristLocations, id: \.self) { location in
                        if let name = location.name {
                            Marker(
                                name, coordinate: location.placemark.coordinate
                            )
                            .tint(.red)
                        }
                    }
                }
                .ignoresSafeArea()
                .onChange(of: searchedCity) { _, newValue in
                    fetchNearbyAttractions()
                }

                VStack {
                    Text("Top 5 Tourist Attractions in \(searchedCity.name)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top)

                    List(touristLocations, id: \.self) { location in
                        if let name = location.name {
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.white, .red)
                                    .font(.largeTitle)
                                Text(name)
                                    .font(.headline)
                            }
                            .padding(8)
                            .listRowBackground(
                                Color(red: 0.18, green: 0.22, blue: 0.48)
                                    .opacity(0.2)
                            )
                            .listRowSeparator(.hidden)
                        }
                    }
                    .scrollContentBackground(.hidden)

                }
                .foregroundStyle(.white)
            }
        }
        .onAppear {
            fetchNearbyAttractions()
        }
    }
}
