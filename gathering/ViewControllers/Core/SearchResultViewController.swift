//
//  SearchResultViewController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-03-17.
//

import UIKit
import IGListKit


class SearchResultViewController: UIViewController {
    
    var collectionView:UICollectionView?
    var searchText:String
    private let loadingIndicator:UIActivityIndicatorView = {
        let view  = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.startAnimating()
        view.sizeThatFits(.init(width: 50, height: 50))
        return view
    }()
    
    var events:[UserEvent] = []
    
    init(searchText:String) {
        self.searchText = searchText
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = searchText
        configureCollectionView()
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        performSearch()
    }
    
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .init(width: 50, height: 50)
        layout.sectionInset = .init(top: 0, left: 0, bottom: 1, right: 0)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserEventCell.self, forCellWithReuseIdentifier: UserEventCell.identifier)
        collectionView.register(UserProfileHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeaderReusableView.identifier)
        
        self.collectionView = collectionView
    }
    
    
    public func performSearch() {
        SearchManager.shared.searchForEvents(words: searchText) {[weak self] userEvents in
            DispatchQueue.main.async {
                print(userEvents)
                self?.events = userEvents
                self?.collectionView?.reloadData()
                self?.loadingIndicator.stopAnimating()
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vm = events[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserEventCell.identifier, for: indexPath) as! UserEventCell
        cell.userEvent = vm
        cell.widthAnchor.constraint(equalToConstant: view.width).isActive = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
}
