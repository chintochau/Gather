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
    
    var currentCell:BasicEventCollectionViewCell?
    
    
    private let refreshControl = UIRefreshControl()

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
        guard let collectionView else {return}
        collectionView.frame = view.safeAreaLayoutGuide.layoutFrame
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard var statusBarStyle = navigationController?.navigationBar.barStyle else {return}
        statusBarStyle = .`default`
        navigationController?.navigationBar.overrideUserInterfaceStyle = .unspecified

        navigationController?.navigationBar.barStyle = statusBarStyle
    }
    
    // MARK: - Fetch Data
    private func fetchDate(){
        DatabaseManager.shared.fetchEvents(){events in
            guard let events = events else {return}
            self.events = events
            self.createViewModels()
        }
        
    }
    // MARK: - Create VMs
    private func createViewModels(){
        viewModels = []
        events.forEach { event in
            viewModels.append(EventCollectionViewCellViewModel(imageUrlString: event.imageUrlString[0],
                                                               title: event.title,
                                                               date: event.startDateString,
                                                               location: event.location,
                                                               tag: nil,
                                                               isLiked: false,
                                                               capacity: event.capacity,
                                                               participants:event.participants
                                                              ))
        }
        collectionView?.reloadData()
    }
}

// MARK: - CollectionView
extension HomeViewController: UINavigationControllerDelegate{
    
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
                        heightDimension: .fractionalHeight(0.8)
                    ),
                subitem: item,
                count: 1
            )
            
            let group1 = NSCollectionLayoutGroup.vertical(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(200)),
                subitem: item,
                count: 1
            )
            
            // section
            return NSCollectionLayoutSection(group: index == 0 ? group0 : group1)
        }))
        
        // MARK: - Cell Registration
        collectionView.register(EventSmallCollectionViewCell.self, forCellWithReuseIdentifier: EventSmallCollectionViewCell.identifier)
        collectionView.register(EventLargeCollectionViewCell.self, forCellWithReuseIdentifier: EventLargeCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        
        self.collectionView = collectionView
    }
    
    @objc private func didPullToRefresh(){
        fetchDate()
        refreshControl.endRefreshing()
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
    
    // MARK: - select cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BasicEventCollectionViewCell
        
        currentCell = cell
        guard let image = cell.eventImageView.image else {return}
        
        guard let eventVM = EventMainViewModel(with: self.events[indexPath.section], image: image) else {return}
        
        DatabaseManager.shared.joinEvent(eventID: eventVM.event.id) { success in
            print(success)
        }
        
        
        let vc = EventViewController(viewModel: eventVM)
        
        navigationController?.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.delegate = nil
        
        
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return TransitionManager(duration: 0.2)
    }
    
    
    
}

