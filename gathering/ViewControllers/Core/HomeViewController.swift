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
    
    
    private let titleLabel : UILabel = {
        let view = UILabel()
        view.text = "GaTher"
        view.font = .righteousFont(ofSize: 24)
        view.textColor = .label
        return view
    }()
    
    private let headerView :UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    // MARK: - Class members
    private var viewModel = HomeViewModel()
    var currentCell:BasicEventCollectionViewCell?
    private let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: nil)
    let eventsPerPage = 7
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureCollectionView()
        fetchInitialDataAndRefresh()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        resetNavBarPosition()
    }
    
    
    private func configureCollectionView(){
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
            
            // item
            let eventItem = NSCollectionLayoutItem(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(10))
            )
            
            // group
            let eventGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(30)),
                subitem: eventItem,
                count: 1
            )
            eventGroup.edgeSpacing = .init(leading: .fixed(0), top: .fixed(5), trailing: .fixed(0), bottom: .fixed(5))
            
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
            
            
            
            let section = NSCollectionLayoutSection(group: eventGroup)
            
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
        collectionView.backgroundColor = .secondarySystemBackground
        
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
        adapter.scrollViewDelegate = self

    }
    
    
    @objc private func didPullToRefresh(){
        fetchInitialDataAndRefresh {[weak self] in
            self?.collectionView?.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Fetch Data
    private func fetchInitialDataAndRefresh(completion: (() -> (Void))? = nil ){
        viewModel.fetchInitialData(perPage: eventsPerPage) { [weak self] events in
            self?.adapter.reloadData()
            completion?()
        }
    }
    
    private func fetchMoreData(completion: (() -> (Void))? = nil ){
        viewModel.fetchMoreData(perPage: eventsPerPage) {[weak self] events in
            guard let self = self else { return }
            self.adapter.performUpdates(animated: true)
            completion?()
        }
    }
    
}
 // MARK: - List Adapter
extension HomeViewController: ListAdapterDataSource,ListAdapterDelegate {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case _ as EventCellViewModel:
            return EventSectionController()
        default:
            return HomeSectionController()
        }
        
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        print("items: \(viewModel.items.count), current: \(index)")
        
        
        if index == viewModel.items.count - 1 {
            fetchMoreData()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
    }
}


extension HomeViewController:UIScrollViewDelegate  {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let magicalSafeAreaTop:CGFloat = 88
        let offset = scrollView.contentOffset.y + magicalSafeAreaTop
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        let cap = max(-44,-offset)
        let realOffset = max(cap,cap + translation.y)
        let alpha:CGFloat = 1 + realOffset/magicalSafeAreaTop*2
        navigationController?.navigationBar.transform = .init(
            translationX: 0,
            y: min(0,realOffset))
        titleLabel.alpha = alpha
        navigationController?.navigationBar.tintColor = .label.withAlphaComponent(alpha)
    }
    
    private func resetNavBarPosition(){
        titleLabel.alpha = 1
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
        
    }
    
    // MARK: - NavBar
    
    fileprivate func configureNavBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        headerView.addSubview(titleLabel)
        navigationItem.titleView = headerView
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 0, y: 0, width: titleLabel.width, height: 50)
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 50)
        
        
        navigationItem.rightBarButtonItems = [
            .init(image: UIImage(systemName: "message"), style: .done, target: self, action: #selector(didTapChat)),
            .init(image: UIImage(systemName: "bell"), style: .done, target: self, action: #selector(didTapNotification))
        ]
        
        
    }
    
    
    @objc private func didTapChat(){
        let vc = ChatMainViewController()
        let navVc = UINavigationController(rootViewController: vc)
        navVc.hero.isEnabled = true
        navVc.hero.modalAnimationType = .autoReverse(presenting: .push(direction: .left))
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
    }
    
    @objc private func didTapNotification(){
        let vc = NotificationsViewController()
        presentModallyWithHero(vc)
    }
}
