//
//  EventsTableCollectionViewCell.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-03-09.
//


import UIKit
import RealmSwift

protocol EventsTableCollectionViewCellDelegate:AnyObject {
    func EventsTableCollectionViewCellDidTapResult(_ cell:EventsTableCollectionViewCell, result:Any)
}

class EventsTableCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EventsTableCollectionViewCell"
    
    weak var delegate:EventsTableCollectionViewCellDelegate?
    
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
    
    var favType:String?{
        didSet{
            switch favType {
            case favouriteType.events.rawValue:
                break
                
            case favouriteType.users.rawValue:
                break
                
            default :
                print("Not yet implemented")
            }
            
            tableView.reloadData()
        }
        
    }
    
    
    override init(frame: CGRect) {
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

extension EventsTableCollectionViewCell:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

