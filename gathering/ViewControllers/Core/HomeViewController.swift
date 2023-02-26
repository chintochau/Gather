//
//  HomeViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit
import Hero
import IGListKit

class HomeViewController: UIViewController{
    
    
    // MARK: - Components
    private var collectionView:UICollectionView?
    private let refreshControl = UIRefreshControl()
    
    
    
    // MARK: - Class members
    private var viewModel = HomeViewModel()
    var currentCell:BasicEventCollectionViewCell?
    private let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: nil)
    var currentPage = 1
    let eventsPerPage = 7
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavBar()
        fetchMoreData()
    }
    
    private func configureCollectionView(){
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
            
            // item
            let smallItem = NSCollectionLayoutItem(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(10))
            )
            
            
            // group
            let group1 = NSCollectionLayoutGroup.horizontal(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(30)),
                subitem: smallItem,
                count: 1
            )
            
            
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
            
            
            
            let section = NSCollectionLayoutSection(group: group1)
            
            // MARK: - add header to first section if needed
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = index == 0 ? [] : []
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            return section
        }))
        
        view.addSubview(collectionView)
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
        
        view.addSubview(collectionView)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        view.backgroundColor = .streamWhiteSnow
        collectionView.fillSuperview()
        self.collectionView = collectionView
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.delegate = self
        adapter.viewController = self

    }
    
    
    @objc private func didPullToRefresh(){
        initialFetchDate {[weak self] in
            self?.adapter.reloadData()
            self?.collectionView?.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard var statusBarStyle = navigationController?.navigationBar.barStyle else {return}
        statusBarStyle = .`default`
        navigationController?.navigationBar.overrideUserInterfaceStyle = .unspecified
        navigationController?.navigationBar.barStyle = statusBarStyle
    }
    
    
    // MARK: - Fetch Data
    private func initialFetchDate(completion: (() -> (Void))? = nil ){
        currentPage = 1
        viewModel.fetchInitialData(page: currentPage, perPage: eventsPerPage) { [weak self] events in
            self?.adapter.performUpdates(animated: true)
            completion?()
        }
    }
    
    private func fetchMoreData(completion: (() -> (Void))? = nil ){
        viewModel.fetchMoreData(page: currentPage, perPage: eventsPerPage) {[weak self] events in
            guard let self = self else { return }
            self.adapter.performUpdates(animated: true)
            completion?()
        }
    }
    
}

extension HomeViewController: ListAdapterDataSource,ListAdapterDelegate {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case _ as EventHomeCellViewModel:
            return EventSectionController()
        case _ as PostViewModel:
            return PostSectionController()
        default:
            return HomeSectionController()
        }
        
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        
            if index == viewModel.items.count - 1 {
                currentPage += 1
                fetchMoreData()
            }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
    }
    
    
    
    
}


extension HomeViewController{
    // MARK: - NavBar
    
    fileprivate func configureNavBar() {
        navigationItem.title = "Home"
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "message"), style: .done, target: self, action: #selector(didTapChat))
    }
    
    
    @objc private func didTapChat(){
        let vc = ChatMainViewController()
        let navVc = UINavigationController(rootViewController: vc)
        navVc.hero.isEnabled = true
        navVc.hero.modalAnimationType = .autoReverse(presenting: .push(direction: .left))
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
    }
}
