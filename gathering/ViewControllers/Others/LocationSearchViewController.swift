//
//  LocationSearchViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-31.
//

import UIKit
import MapKit
import CoreLocation

protocol LocationSerchViewControllerDelegate:AnyObject {
    func didChooseLocation(_ VC:LocationSearchViewController, location:Location)
}

class LocationSearchViewController: UIViewController {
    
    private let searchController:UISearchController = {
        let view = UISearchController(searchResultsController: LocationSearchResultTableVC())
        view.searchBar.placeholder = "Search location/area/district/country..."
        view.obscuresBackgroundDuringPresentation = true
        return view
    }()
    
    private let mapView:MKMapView = {
        let view = MKMapView()
        let region = MKCoordinateRegion(center: Location.torontoCoordinate, span: Location.span)
        view.setRegion(region, animated: true)
        return view
    }()
    
    weak var delegate:LocationSerchViewControllerDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBar()
    }
    
    private func configureNavBar() {
        navigationItem.title = "Search location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = searchController.searchResultsController as? LocationSearchResultTableVC
        let resultVC = searchController.searchResultsController as! LocationSearchResultTableVC
        resultVC.delegate = self
        resultVC.mapView = mapView
        
    }
    
    @objc private func didTapClose(){
            self.dismiss(animated: true)
    }
    
}


extension LocationSearchViewController:LocationSearchResultTableVCDelegate {
    func LocationSearchResultDidChooseResult(_ VC: LocationSearchResultTableVC, location: Location) {
        dismiss(animated: false)
        dismiss(animated: true)
        print(location)
        delegate?.didChooseLocation(self, location: location)
    }
}
