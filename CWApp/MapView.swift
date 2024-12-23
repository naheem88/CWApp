//
//  MapView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var selectedCity: City?

    var body: some View {
        Map(selection: $selectedCity) {
            ForEach(Array(viewModel.selectedCities)) { city in
                Marker(city.name, coordinate: city.coordinate)
            }
        }
    }
}
