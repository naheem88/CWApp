//
//  SearchView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-30.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var searchedCity: City
    @State private var cityName: String = ""

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for City", text: $cityName)
                    .onSubmit {
                        searchCity()
                    }
            }
            .padding(9)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Alert"),
                message: Text(viewModel.alertMsg),
                dismissButton: .default(Text("Done")) {
                    viewModel.showAlert = false
                }
            )
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }

    private func searchCity() {
        viewModel.getCoordinateFrom(address: cityName)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let coordinate = viewModel.coordinate {
                if let city = viewModel.allCities.first(where: {
                    $0.coordinate.latitude == coordinate.latitude
                        && $0.coordinate.longitude == coordinate.longitude
                }) {
                    searchedCity = city
                }
            } else if viewModel.geocodingError != nil {
                viewModel.alertMsg =
                    "Could not find \(cityName). Please try again or search for another city."
                viewModel.showAlert = true
            }
            cityName = ""
        }
    }
}
