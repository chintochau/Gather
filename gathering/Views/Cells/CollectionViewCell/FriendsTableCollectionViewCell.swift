//
//  ResultTableCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-10.
//

import UIKit
import RealmSwift

protocol FavouritedTableCollectionViewCellDelegate:AnyObject {
    func FavouritedTableCollectionViewCellDelegateDidTapResult(_ cell:FriendsTableCollectionViewCell, result:Any)
}

class FriendsTableCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FriendsTableCollectionViewCell"
    
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
    
    
    // MARK: - Class members
    private var relationships:Results<RelationshipObject>
    
    
    
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
        
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.identifier)
        
    }
    
    @objc private func didPullToRefresh(){
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
}

extension FriendsTableCollectionViewCell:UITableViewDelegate,UITableViewDataSource, FriendTableViewCellDelegate {
    
    func FriendTableViewCellDidTapFollow(_ cell: FriendTableViewCell) {
        
        // MARK: - Rewrite using realm listener to update tableview
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relationships.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = relationships.sorted(by: {$0.status > $1.status})[indexPath.row]
        let cell = FriendTableViewCell(username: model.targetUsername)
        cell.relationship = model
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        
        if let cell = tableView.cellForRow(at: indexPath) as? FriendTableViewCell {
            cell.updateUserProfile()
        }
        
        delegate?.FavouritedTableCollectionViewCellDelegateDidTapResult(self, result: relationships[indexPath.row].targetUsername)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
