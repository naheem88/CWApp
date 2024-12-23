//
//  City.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-23.
//

import Foundation
import MapKit

enum City: Identifiable, CaseIterable {
    case newYork
    case london
    case bristol
    case manchester
    case amsterdam
    case perth
    case colombo
    case dubai
    
    var id: Self {
        self
    }
    
    var name: String {
        switch self {
        case .newYork:
            return "New York"
        case .london:
            return "London"
        case .bristol:
            return "Bristol"
        case .manchester:
            return "Manchester"
        case .amsterdam:
            return "Amsterdam"
        case .perth:
            return "Perth"
        case .colombo:
            return "Colombo"
        case .dubai:
            return "Dubai"
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        switch self {
            case .newYork:
            return CLLocationCoordinate2D(latitude: 40.7127, longitude: -74.0059)
        case .london:
            return CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1277)
        case .bristol:
            return CLLocationCoordinate2D(latitude: 51.4573, longitude: -2.5972)
        case .manchester:
            return CLLocationCoordinate2D(latitude: 53.4778, longitude: -2.2476)
        case .amsterdam:
            return CLLocationCoordinate2D(latitude: 52.3702, longitude: 4.8952)
        case .perth:
            return CLLocationCoordinate2D(latitude: -31.9501, longitude: 115.8601)
        case .colombo:
            return CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8616)
        case .dubai:
            return CLLocationCoordinate2D(latitude: 25.2041, longitude: 55.2778)
        }
    }
}
