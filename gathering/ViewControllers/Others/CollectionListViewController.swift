//
//  CollectionListViewController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-03-13.
//
import UIKit

class CollectionListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var users: [User] = []
    private var filteredUsers: [User] = []
    
    private let searchBar = UISearchBar()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPanBackGestureAndBackButton()
        setupViews()
        setupConstraints()
        loadData()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        searchBar.placeholder = "Search users"
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func loadData() {
        // Load user data here, and assign to both users and filteredUsers arrays
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter { user in
            return user.username.lowercased().contains(searchText.lowercased())
        }
        collectionView.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension CollectionListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterContentForSearchText("")
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .gray
        
        let user = filteredUsers[indexPath.item]
        let label = UILabel(frame: cell.contentView.bounds)
        label.text = user.name
        label.textAlignment = .center
        label.textColor = .white
        cell.contentView.addSubview(label)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / 2 - 10, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
