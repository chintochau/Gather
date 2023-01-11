//
//  HomeViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit

class HomeViewController: UIViewController{
    
    private var collectionView:UICollectionView?
    
    private var viewModels = [EventCollectionViewCellViewModel]()
    private var events = [Event]()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Home"
        configureCollectionView()
        fetchDate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Fetch Data
    private func fetchDate(){
        // create mock data for now
        let event = MockData.event
        events.append(contentsOf: repeatElement(event, count: 10))
        createViewModels()
    }
    // MARK: - Create VMs
    private func createViewModels(){
        events.forEach { event in
            viewModels.append(EventCollectionViewCellViewModel(imageUrlString: event.imageUrlString,
                                                               title: event.title,
                                                               date: event.dateString,
                                                               location: event.location,
                                                               tag: nil,
                                                               isLiked: false))
        }
    }
}

// MARK: - CollectionView
extension HomeViewController{
    
    private func configureCollectionView(){
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
            // item
            
            let item = NSCollectionLayoutItem(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1))
            
            )
            let inset:CGFloat = 10
            item.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            
            // group
            let group0 = NSCollectionLayoutGroup.vertical(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(250)),
                subitem: item,
                count: 1
            )
            
            let group1 = NSCollectionLayoutGroup.vertical(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(100)),
                subitem: item,
                count: 1
            )
            
            // section
            print(index)
            return NSCollectionLayoutSection(group: index == 0 ? group0 : group1)
        }))
        
        // MARK: - Cell Registration
        collectionView.register(EventSmallCollectionViewCell.self, forCellWithReuseIdentifier: EventSmallCollectionViewCell.identifier)
        collectionView.register(EventLargeCollectionViewCell.self, forCellWithReuseIdentifier: EventLargeCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.frame = view.safeAreaLayoutGuide.layoutFrame
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView = collectionView
    }
}

// MARK: - Delegate, DataSource
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModels[indexPath.section]
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventLargeCollectionViewCell.identifier, for: indexPath) as! EventLargeCollectionViewCell
            cell.configure(with: model)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventSmallCollectionViewCell.identifier, for: indexPath) as! EventSmallCollectionViewCell
            cell.configure(with: model)
            return cell
        }
    }
}
