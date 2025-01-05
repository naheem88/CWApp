//
//  City.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-23.
//

import Foundation
import MapKit

struct City: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D

    enum CodingKeys: String, CodingKey {
        case id, name, latitude, longitude
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(
            latitude: latitude, longitude: longitude)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name.lowercased())
    }

    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.name.lowercased() == rhs.name.lowercased()
    }

    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }

}
