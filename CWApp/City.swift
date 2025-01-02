//
//  City.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-23.
//

import Foundation
import MapKit

struct City: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(coordinate.latitude)
            hasher.combine(coordinate.longitude)
        }
        
        static func == (lhs: City, rhs: City) -> Bool {
            return lhs.name == rhs.name &&
                   lhs.coordinate.latitude == rhs.coordinate.latitude &&
                   lhs.coordinate.longitude == rhs.coordinate.longitude
        }
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
            self.name = name
            self.coordinate = coordinate
        }
    
    static var defaultCities: Set<City> {
            return Set([
                City(name: "New York", coordinate: CLLocationCoordinate2D(latitude: 40.7127, longitude: -74.0059)),
                City(name: "London", coordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1277)),
                City(name: "Bristol", coordinate: CLLocationCoordinate2D(latitude: 51.4573, longitude: -2.5972)),
                City(name: "Manchester", coordinate: CLLocationCoordinate2D(latitude: 53.4778, longitude: -2.2476)),
                City(name: "Amsterdam", coordinate: CLLocationCoordinate2D(latitude: 52.3702, longitude: 4.8952)),
                City(name: "Perth", coordinate: CLLocationCoordinate2D(latitude: -31.9501, longitude: 115.8601)),
                City(name: "Colombo", coordinate: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8616)),
                City(name: "Dubai", coordinate: CLLocationCoordinate2D(latitude: 25.2041, longitude: 55.2778))
            ])
        }
}
