//
//  ResultTableCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-10.
//

import UIKit

protocol FavouritedTableCollectionViewCellDelegate:AnyObject {
    func FavouritedTableCollectionViewCellDelegateDidTapResult(_ cell:FavouritedTableCollectionViewCell, result:SearchResult)
}

class FavouritedTableCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ResultTableCollectionViewCell"
    
    weak var delegate:FavouritedTableCollectionViewCellDelegate?
    
    private var viewModels:[SearchResult] = []
    
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
    
    override init(frame: CGRect) {
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
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        delegate?.FavouritedTableCollectionViewCellDelegateDidTapResult(self, result: viewModels[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
