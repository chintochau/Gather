//
//  TicketViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit

enum favouriteType:String, CaseIterable {
    case users = "Users"
    case events = "Events"
}

class FavouritedViewController: UIViewController {
    
    var favouritedItems = DefaultsManager.shared.getFavouritedEvents()
    
    private var titles:[String] = {
        return favouriteType.allCases.compactMap({$0.rawValue})
    }()
    
    private let tableView:UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var segmentedButtonsView:SegmentedButtonsView = {
        let segmentedButtonsView = SegmentedButtonsView()
        segmentedButtonsView.setLablesTitles(titles: titles)
        return segmentedButtonsView
    }()
    
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view  = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(FavouritedTableCollectionViewCell.self, forCellWithReuseIdentifier: FavouritedTableCollectionViewCell.identifier)
        view.isPagingEnabled = true
        return view
    }()
    
    private let refreshControl:UIRefreshControl = {
        let view = UIRefreshControl()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        [segmentedButtonsView,collectionView].forEach({view.addSubview($0)})
        navigationItem.title = "Favourites"
        view.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        segmentedButtonsView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentedButtonsView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 44)
        collectionView.frame = CGRect(x: 0, y: segmentedButtonsView.bottom, width: view.width, height: view.height-44)
    }
    
    @objc private func didPullToRefresh(){
        favouritedItems = DefaultsManager.shared.getFavouritedEvents()
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
}

extension FavouritedViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouritedTableCollectionViewCell.identifier, for: indexPath) as! FavouritedTableCollectionViewCell
        cell.favType = titles[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        segmentedButtonsView.collectionViewDidScroll(for: scrollView.contentOffset.x / CGFloat(titles.count))
    }
    
}

extension FavouritedViewController:FavouritedTableCollectionViewCellDelegate {
    func FavouritedTableCollectionViewCellDelegateDidTapResult(_ cell: FavouritedTableCollectionViewCell, result: SearchResult) {
        if result.type == .user {
            DatabaseManager.shared.findUserWithUsername(with: result.title) {[weak self] user in
                guard let user = user else {return}
                let vc = UserProfileViewController(user: user)
                self?.present(vc, animated: true)
            }
            
        }
    }
    
    
}

extension FavouritedViewController:SegmentedControlDelegate {
    
    func didIndexChanged(at index: Int) {
        if index == 0 {
            // scroll forward
            let collectionBounds = collectionView.bounds
            let contentOffset = CGFloat(floor(collectionView.contentOffset.x - collectionBounds.size.width))
            moveToFrame(contentOffset: contentOffset)
            
        }else if index == 1 {
            // scroll backward
            let collectionBounds = collectionView.bounds
            let contentOffset = CGFloat(floor(collectionView.contentOffset.x + collectionBounds.size.width))
            moveToFrame(contentOffset: contentOffset)
        }else if index == 2 {
            // scroll backward
            let collectionBounds = collectionView.bounds
            let contentOffset = CGFloat(floor(collectionView.contentOffset.x + collectionBounds.size.width))
            moveToFrame(contentOffset: contentOffset)
        }
        
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        
        let frame: CGRect = CGRect(x : contentOffset ,y : collectionView.contentOffset.y ,width : self.collectionView.frame.width,height : collectionView.frame.height)
        
        self.collectionView.scrollRectToVisible(frame, animated: true)
    }
    
    
}
