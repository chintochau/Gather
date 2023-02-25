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
    
    static let toBeConfirmed = Location(name: "待定", address: nil, latitude: nil, longitude: nil)
    static let toronto = Location(name: "Toronto", address: "ON, Canada", latitude: 43.780918, longitude: -79.421371)
    static let markham = Location(name: "Markham", address: "ON, Canada", latitude: 43.8561, longitude: -79.3370)
    static let northYork = Location(name: "North York", address: "ON, Canada", latitude: 43.7694, longitude: -79.4139)
    static let scarborough = Location(name: "Scarborough", address: "ON, Canada", latitude: 43.7764, longitude: -79.2318)
    static let downtownToronto = Location(name: "Downtown Toronto", address: "ON, Canada", latitude: 43.6532, longitude: -79.3832)
    static let mississauga = Location(name: "Mississauga", address: "ON, Canada", latitude: 43.5890, longitude: -79.6441)
    static let brampton = Location(name: "Brampton", address: "ON, Canada", latitude: 43.7315, longitude: -79.7624)
    static let vaughan = Location(name: "Vaughan", address: "ON, Canada", latitude: 43.8369, longitude: -79.4982)
    static let richmondHill = Location(name: "Richmond Hill", address: "ON, Canada", latitude: 43.8828, longitude: -79.4403)
    
    static let filterArray:[Location] = [
        .toBeConfirmed,
        .northYork,
        .downtownToronto,
        .scarborough,
        .markham,
        .richmondHill
    ]
    
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
