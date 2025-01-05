//
//  ViewModel.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-23.
//

import CoreLocation
import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @AppStorage("savedCities") private var savedCitiesData: Data = Data()
    @Published var allCities: Set<City> = []
    @Published var coordinate: CLLocationCoordinate2D? = nil
    @Published var geocodingError: Error? = nil
    @Published var showAlert: Bool = false
    @Published var alertMsg = ""

    init() {
        loadCities()
    }

    func loadCities() {
        do {
            allCities = try JSONDecoder().decode(
                Set<City>.self, from: savedCitiesData)
        } catch {
            print("Error loading cities: \(error)")
            allCities = []
        }
    }

    func saveCities() {
        do {
            savedCitiesData = try JSONEncoder().encode(allCities)
        } catch {
            print("Error saving cities: \(error)")
        }
    }

    private let geocoder = CLGeocoder()

    func getCoordinateFrom(address: String) {
        coordinate = nil
        geocodingError = nil

        geocoder.geocodeAddressString(address) {
            [weak self] placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.geocodingError = error
                    self?.coordinate = nil
                } else if let placemark = placemarks?.first,
                    let coordinate = placemark.location?.coordinate
                {
                    self?.coordinate = coordinate
                    self?.geocodingError = nil

                    let properCityName = placemark.locality ?? address

                    let city = City(
                        name: properCityName, coordinate: coordinate)

                    if !(self?.allCities.contains(city) ?? false) {
                        self?.allCities.insert(city)
                        self?.saveCities()

                        self?.alertMsg = "\(properCityName) added to favorites."
                        self?.showAlert = true
                    } else {
                        self?.alertMsg = "Already added to favorites."
                        self?.showAlert = true
                    }
                }
            }
        }
    }
}
