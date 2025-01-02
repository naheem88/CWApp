//
//  ViewModel.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-23.
//

import Foundation
import CoreLocation


class ViewModel: ObservableObject {
    @Published var selectedCities: Set<City> = []
    @Published var allCities: Set<City> = City.defaultCities
    @Published var coordinate: CLLocationCoordinate2D? = nil
    @Published var geocodingError: Error? = nil
    
    private let geocoder = CLGeocoder()
    
    func getCoordinateFrom(address: String) {
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.geocodingError = error
                    self?.coordinate = nil
                } else if let coordinate = placemarks?.first?.location?.coordinate {
                    self?.coordinate = coordinate
                    self?.geocodingError = nil
                    
                    let city = City(name: address, coordinate: coordinate)
                    
                    if !(self?.allCities.contains(city) ?? false) {
                        self?.allCities.insert(city)
                    }
                }
            }
        }
    }
}
