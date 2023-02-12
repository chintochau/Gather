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
        let view = UISearchController(searchResultsController: GeneralSearchResultViewController())
        view.searchBar.searchTextField.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.8)
        view.searchBar.placeholder = "Search user/ events/ location..."
        return view
    }()
    
    private let mapView:MKMapView = {
        let view = MKMapView()
        let region = MKCoordinateRegion(center: Location.torontoCoordinate, span: Location.span)
        view.setRegion(region, animated: true)
        return view
    }()
    
    private let filterBarCollectionView:UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 0)
        layout.estimatedItemSize = CGSize(width: 50, height: 30)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let filterArray = ["User","Event"]
    
    private var selectedIndex:IndexPath = .init(row: 0, section: 0)
    
    private let locationManager = CLLocationManager()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
//        configureMap()
//        requestLocationAuth()
        configureSearchBar()
        configureFilterCollectionView()
//        definesPresentationContext = true
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centreOnUserLoction()
    }
    
    
    
    private func configureFilterCollectionView(){
        view.addSubview(filterBarCollectionView)
        filterBarCollectionView.delegate = self
        filterBarCollectionView.dataSource = self
        filterBarCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,size: CGSize(width: view.width, height: 44))
        filterBarCollectionView.register(FilterButtonCollectionViewCell.self
                                      , forCellWithReuseIdentifier: FilterButtonCollectionViewCell.identifier)

    }
    
}

extension ExploreViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    // MARK: - Filter Tab
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterText = filterArray[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterButtonCollectionViewCell.identifier, for: indexPath) as! FilterButtonCollectionViewCell
        cell.configure(with: filterText)
        collectionView.selectItem(at: selectedIndex, animated: false, scrollPosition: [])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = true
        selectedIndex = indexPath
    }
    
}

extension ExploreViewController : GeneralSearchResultViewControllerDelegate{
    
    func GeneralSearchResultViewControllerDelegateDidChooseResult(_ view: GeneralSearchResultViewController, result: User) {
        let vc = UserProfileViewController(user: result)
        vc.title = "Profile"
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
        
    }
    
    // MARK: - Search Bar
    
    private func configureSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
        searchController.searchResultsUpdater = searchController.searchResultsController as? GeneralSearchResultViewController
        let resultVC = searchController.searchResultsController as! GeneralSearchResultViewController
        resultVC.delegate = self
        
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

