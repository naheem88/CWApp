//
//  FavCountrySelectView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-23.
//

import SwiftUI

struct FavCountrySelectView : View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(City.allCases) { city in
                    HStack{
                        Text(city.name)
                        
                        Spacer()
                        
                        if viewModel.selectedCities.contains(city) {
                            Button {
                                viewModel.selectedCities.remove(city)
                            } label: {
                                Image(systemName: "xmark.circle.fill") }
                        } else {
                            Button {
                                viewModel.selectedCities.insert(city)
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favourite Cities")
        }
    }
}
