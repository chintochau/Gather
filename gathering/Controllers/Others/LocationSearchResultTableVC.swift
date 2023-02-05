//
//  SearchResultViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-31.
//

import UIKit
import MapKit

protocol LocationSearchResultTableVCDelegate:AnyObject {
    func LocationSearchResultDidChooseResult(_ VC:LocationSearchResultTableVC,location:Location)
}

class LocationSearchResultTableVC: UIViewController {
    
    weak var  delegate:LocationSearchResultTableVCDelegate?
    
    let tableView:UITableView = {
        let view = UITableView()
        return view
    }()
    
    private var task = DispatchWorkItem{}
    var mapView: MKMapView? = nil
    
    var customLocation:String = ""
    var matchingItems:[MKMapItem] = []
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension LocationSearchResultTableVC:UITableViewDelegate,UITableViewDataSource {
    // MARK: - Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : matchingItems.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var location:Location!
        if indexPath.section == 0 {
            location = .init(
                name: customLocation,
                address: nil,
                latitude: nil,
                longitude: nil)
        }else {
            location = Location(with: matchingItems[indexPath.row])
        }
        delegate?.LocationSearchResultDidChooseResult(self,location:location)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "detailCell")
        
        if cell == nil {cell = UITableViewCell(style: .subtitle, reuseIdentifier: "detailCell")}
        
        guard let cell = cell else {fatalError("Failed to create cell")}
        
        cell.detailTextLabel?.textColor = .secondaryLabel
        
        if indexPath.section == 0 {
            cell.textLabel?.text = customLocation
            cell.detailTextLabel?.text = "Custom Location"
            return cell
        }
        
        let vm = matchingItems[indexPath.row]
        let selectedItem = vm.placemark
        cell.textLabel?.text = selectedItem.name
        let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
        cell.detailTextLabel?.text = address
        return cell
    }
    
}

extension LocationSearchResultTableVC:UISearchResultsUpdating {
    
    // MARK: - Update Search result
    
    func updateSearchResults(for searchController: UISearchController) {
        task.cancel()
        guard let searchBarText = searchController.searchBar.text
        else { return }
        
        if searchBarText.isEmpty {
            matchingItems = []
            tableView.reloadData()
        }
        customLocation = searchBarText
        tableView.reloadData()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = .init(center: Location.torontoCoordinate, span: Location.span)
        let search = MKLocalSearch(request: request)
        
        task = .init(block: { [weak self] in
            self?.startSearch(search)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: task)
    }
    
    fileprivate func startSearch(_ search: MKLocalSearch) {
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

