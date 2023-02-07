//
//  HomeViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit

class HomeViewController: UIViewController{
    
    private var collectionView:UICollectionView?
    
    private var viewModels = [[EventCollectionViewCellViewModel]]()
    private var events = [Event]()
    private var selfEvents = [Event]()
    
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
        
        if let user = DefaultsManager.shared.getCurrentUser() {
            DatabaseManager.shared.fetchUserEvents(with: user.username) {[weak self] selfEvents in
                guard let selfEvents = selfEvents else {return}
                self?.selfEvents = selfEvents
                DatabaseManager.shared.fetchEvents(exclude: selfEvents) { events in
                    guard let events = events else {return}
                    self?.events = events
                    self?.createViewModels()
                }
            }
        }else {
            self.selfEvents = []
            DatabaseManager.shared.fetchEvents{ [weak self] events in
                guard let events = events else {return}
                self?.events = events
                self?.createViewModels()
            }
        }
        
        
    }
    // MARK: - Create VMs
    private func createViewModels(){
        viewModels = [[],[]]
        
        selfEvents.forEach { event in
            viewModels[0].append(EventCollectionViewCellViewModel(with: event))
        }
        events.forEach { event in
            viewModels[1].append(EventCollectionViewCellViewModel(with: event))
        }
        
        collectionView?.reloadData()
    }
}

// MARK: - CollectionView
extension HomeViewController: UINavigationControllerDelegate{
    
    private func configureCollectionView(){
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
            
            
            
            // item for registered group
            let horizeltanitem = NSCollectionLayoutItem(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(30))
            )
            
            // registered event group
            let registeredEventGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .absolute(self.view.width-20),
                        heightDimension: .estimated(30)
                    ),
                subitem: horizeltanitem,
                count: 1
            )
            registeredEventGroup.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
            
            // item for group 0
            let LargeItem = NSCollectionLayoutItem(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1))
            
            )
            LargeItem.contentInsets = .init(top: 5, leading: 10, bottom: 0, trailing: 10)
            
            // group 0, not in use
            let group0 = NSCollectionLayoutGroup.vertical(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(0.5)
                    ),
                subitem: LargeItem,
                count: 1
            )
            
            // item for group 1
            let smallItem = NSCollectionLayoutItem(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(30))
            )
            smallItem.edgeSpacing = .init(leading: .none, top: .fixed(5), trailing: .none, bottom: .fixed(5))
            
            // group 1
            let group1 = NSCollectionLayoutGroup.horizontal(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(30)),
                subitem: smallItem,
                count: 1
            )
            group1.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            
            //Header
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(44)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            sectionHeader.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
            
            switch index {
            case 0:
                let section = NSCollectionLayoutSection(group: registeredEventGroup)
                section.boundarySupplementaryItems = self.selfEvents.isEmpty ? [] : [sectionHeader]
                section.orthogonalScrollingBehavior = .groupPagingCentered
                return section
            case 1:
                let section = NSCollectionLayoutSection(group: group1)
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            default:
                return NSCollectionLayoutSection(group: group1)
            }
        }))
        
        // MARK: - Cell Registration
        collectionView.register(SmallEventCollectionViewCell.self, forCellWithReuseIdentifier: SmallEventCollectionViewCell.identifier)
        collectionView.register(LargeEventCollectionViewCell.self, forCellWithReuseIdentifier: LargeEventCollectionViewCell.identifier)
        collectionView.register(EmojiEventCollectionViewCell.self, forCellWithReuseIdentifier: EmojiEventCollectionViewCell.identifier)
        collectionView.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderCollectionReusableView.identifier)
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
        
        self.collectionView = collectionView
    }
    
    @objc private func didPullToRefresh(){
        fetchDate()
        refreshControl.endRefreshing()
    }
}

// MARK: - Delegate, DataSource
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderCollectionReusableView.identifier, for: indexPath) as! SectionHeaderCollectionReusableView
            
            switch indexPath.section {
            case 0:
                header.configure(with: SectionHeaderViewModel(title: "Your Events", buttonText: "Show All"))
            case 1:
                header.configure(with: SectionHeaderViewModel(title: "Explore Events", buttonText: "Show All"))
            default:
                print("section number is not handled")
            }
            return header
        default: fatalError()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return selfEvents.count
        case 1:
            return events.count
        default:
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModels[indexPath.section][indexPath.row]
        
        if model.imageUrlString == nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiEventCollectionViewCell.identifier, for: indexPath) as! EmojiEventCollectionViewCell
            cell.configure(with: model)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeEventCollectionViewCell.identifier, for: indexPath) as! LargeEventCollectionViewCell
            cell.configure(with: model)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallEventCollectionViewCell.identifier, for: indexPath) as! SmallEventCollectionViewCell
            cell.configure(with: model)
            return cell
        }
        
        
    }
    
    // MARK: - select cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BasicEventCollectionViewCell
        
        currentCell = cell
        guard let image = cell.eventImageView.image ?? UIImage(named: "test"),
              let eventVM:EventMainViewModel = {
                  switch indexPath.section {
                  case 0:
                      return EventMainViewModel(with: self.selfEvents[indexPath.row], image: image)
                  case 1:
                      return EventMainViewModel(with: self.events[indexPath.row], image: image)
                  default:
                      print("section not handled")
                      return nil
                  }
              }() else {return}
        
        let vc = EventViewController(viewModel: eventVM)
        
        navigationController?.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.delegate = nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        

        if let _ = toVC as? EventViewController {
            return TransitionManager(duration: 0.2)
        }else {
            return nil
        }
        
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Preview: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        HomeViewController().toPreview()
    }
}
#endif

