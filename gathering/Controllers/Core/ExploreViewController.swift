//
//  ExploreViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit
import MapKit
import CoreLocation


class ExploreViewController: UIViewController {
    
    private let searchController:UISearchController = {
        let view = UISearchController(searchResultsController: LocationSearchResultTableVC())
        view.searchBar.searchTextField.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.8)
        return view
    }()
    
    private let mapView:MKMapView = {
        let view = MKMapView()
        let region = MKCoordinateRegion(center: Location.torontoCoordinate, span: Location.span)
        view.setRegion(region, animated: true)
        return view
    }()
    
    private let locationManager = CLLocationManager()
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureMap()
        requestLocationAuth()
        configureSearchBar()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centreOnUserLoction()
    }
    
    
}

extension ExploreViewController {
    // MARK: - Search Bar
    
    private func configureSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.title = "Search location"
    }
    
    
}

extension ExploreViewController:CLLocationManagerDelegate {
    // MARK: - Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
        let centre = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion.init(center: centre, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func centreOnUserLoction() {
      if let location = locationManager.location?.coordinate {
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion.init(center: location, span: span)
        mapView.setRegion(region, animated: true)
     }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    }
    
}

extension ExploreViewController:MKMapViewDelegate {
    // MARK: - Map
    
    fileprivate func requestLocationAuth() {
        DispatchQueue.global().async{
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.delegate = self
            }
        }
    }
    
    
    fileprivate func configureMap() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct PreviewExplore: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        ExploreViewController().toPreview()
    }
}
#endif

