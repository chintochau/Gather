//
//  ResultTableCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-10.
//

import UIKit
import RealmSwift

protocol FavouritedTableCollectionViewCellDelegate:AnyObject {
    func FavouritedTableCollectionViewCellDelegateDidTapResult(_ cell:FavouritedTableCollectionViewCell, result:Any)
}

class FavouritedTableCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ResultTableCollectionViewCell"
    
    weak var delegate:FavouritedTableCollectionViewCellDelegate?
    
    // MARK: - Components
    
    let refreshControl = UIRefreshControl()
    
    let tableView:UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    private let searchBar:UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Search"
        return view
    }()
    
    
    // MARK: - Properties
    private var viewModels:[SearchResult] = []
    
    private var relationships:Results<RelationshipObject>
    
    var favType:String?{
        didSet{
            viewModels = []
            switch favType {
            case favouriteType.events.rawValue:
                if let events = UserDefaults.standard.array(forKey: UserDefaultsType.favEvent.rawValue) as? [String] {
                    events.forEach({
                        viewModels.append(SearchResult(with: $0,type: .event))
                    })
                }
            case favouriteType.users.rawValue:
                if let users = UserDefaults.standard.array(forKey: UserDefaultsType.favUser.rawValue) as? [String] {
                    users.forEach({
                        viewModels.append(SearchResult(with: $0,type: .user))
                    })
                }
                
            default :
                print("Not yet implemented")
            }
            
            tableView.reloadData()
        }
        
    }
    
    
    override init(frame: CGRect) {
        let realm = try! Realm()
        relationships = realm.objects(RelationshipObject.self)
        
        super.init(frame: frame)
        [searchBar,tableView].forEach({addSubview($0)})
        
        searchBar.frame = CGRect(x: 0, y: top, width: width, height: 56)
        tableView.frame = CGRect(x: 0, y: searchBar.bottom, width: width, height: height-searchBar.height)
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
    }
    
    @objc private func didPullToRefresh(){
        let type = favType
        favType = type
        refreshControl.endRefreshing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
}

extension FavouritedTableCollectionViewCell:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relationships.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = relationships[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.targetUsername
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        delegate?.FavouritedTableCollectionViewCellDelegateDidTapResult(self, result: relationships[indexPath.row].targetUsername)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
