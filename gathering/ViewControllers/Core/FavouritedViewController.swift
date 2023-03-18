//
//  TicketViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit

enum favouriteType:String, CaseIterable {
    case users = "Friends"
    case events = "Events"
}

class FavouritedViewController: UIViewController {
    
    var favouritedItems = DefaultsManager.shared.getFavouritedEvents()
    
    private var titles:[String] = {
        return favouriteType.allCases.compactMap({$0.rawValue})
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
        view.register(FriendsTableCollectionViewCell.self, forCellWithReuseIdentifier: FriendsTableCollectionViewCell.identifier)
        view.register(EventsTableCollectionViewCell.self, forCellWithReuseIdentifier: EventsTableCollectionViewCell.identifier)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        [collectionView].forEach({view.addSubview($0)})
        
        view.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        segmentedButtonsView.delegate = self
        let navView = UIView()
        navView.addSubview(segmentedButtonsView)
        navigationItem.titleView = navView
        segmentedButtonsView.frame = CGRect(x: 0, y: 0, width: view.width, height: 35)
        print(navView.frame)
        print(segmentedButtonsView.frame)
        print(navigationController?.navigationBar.frame)
        
//        collectionView.frame = CGRect(x: 0, y: navigationItem.titleView?.bottom ?? 0, width: view.width, height: view.height-44-88)
    }
    
}

extension FavouritedViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsTableCollectionViewCell.identifier, for: indexPath) as! FriendsTableCollectionViewCell
            cell.delegate = self
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventsTableCollectionViewCell.identifier, for: indexPath) as! EventsTableCollectionViewCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsTableCollectionViewCell.identifier, for: indexPath) as! FriendsTableCollectionViewCell
            cell.delegate = self
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        segmentedButtonsView.collectionViewDidScroll(for: scrollView.contentOffset.x / CGFloat(titles.count))
    }
    
}

extension FavouritedViewController:FriendsCollectionViewCellDelegate {
    func FriendsCollectionViewCellDidSelectFriend(_ cell: FriendsTableCollectionViewCell, result: Any) {
        guard let username = result as? String else {return}
        
        if let userObject = RealmManager.shared.getObject(ofType: UserObject.self, forPrimaryKey: username) {
            let vc = UserProfileViewController(user: userObject.toUser())
            
            navigationController?.pushViewController(vc, animated: true)
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
        }
        
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        
        let frame: CGRect = CGRect(x : contentOffset ,y : collectionView.contentOffset.y ,width : self.collectionView.frame.width,height : collectionView.frame.height)
        
        self.collectionView.scrollRectToVisible(frame, animated: true)
    }
    
    
}
