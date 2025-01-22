//
//  SavedCitiesView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-23.
//

import MapKit
import SwiftUI

struct SavedCitiesView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var searchedCity: City

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
                    .foregroundStyle(.black)
                Text("Saved Cities")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Current city: \(searchedCity.name)")

                List {
                    ForEach(Array(viewModel.allCities), id: \.self) { city in
                        Text(city.name)
                            .listRowBackground(
                                Color(red: 0.18, green: 0.22, blue: 0.48)
                                    .opacity(0.5)
                            )
                            .font(.title3)
                            .padding(7)
                            .swipeActions {
                                Button {
                                    viewModel.allCities.remove(city)
                                    viewModel.saveCities()
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                            .onTapGesture {
                                searchedCity = city
                            }
                    }
                    .listRowSeparatorTint(Color.white.opacity(0.8))
                }
                .scrollContentBackground(.hidden)
            }
            .foregroundStyle(.white)
        }
        .onAppear {
            Task {
                viewModel.loadCities()
            }
        }
    }
}
