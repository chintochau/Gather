//
//  Location.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-31.
//

import Foundation
import CoreLocation
import MapKit

struct Location:Codable {
    let name:String
    let address:String?
    let latitude:Double?
    let longitude:Double?
    
    var location:CLLocationCoordinate2D? {
        guard let latitude = latitude, let longitude = longitude else {return nil}
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Location {
    
    static let toronto = Location(name: "Toronto", address: "ON,Canada", latitude: 43.780918, longitude: -79.421371)
    
    static let torontoCoordinate = CLLocationCoordinate2D(
        latitude: 43.780918,
        longitude: -79.421371)
    static let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    
    init(with mapItem:MKMapItem){
        let item = mapItem.placemark
        self.name = item.name ?? "Unknown Place"
        
        let address = "\(item.thoroughfare ?? ""), \(item.locality ?? ""), \(item.subLocality ?? ""), \(item.administrativeArea ?? ""), \(item.postalCode ?? ""), \(item.country ?? "")"
        self.address = address
        
        self.latitude = item.coordinate.latitude
        self.longitude = item.coordinate.longitude
        
    }
    
}
