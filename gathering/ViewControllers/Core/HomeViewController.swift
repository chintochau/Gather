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
    
    private var viewModel = HomeViewModel()
    var currentCell:BasicEventCollectionViewCell?
    private let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: nil)
    
    // MARK: - Components
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let refreshControl = UIRefreshControl()
        view.register(EventCell.self, forCellWithReuseIdentifier: EventCell.identifier)
        view.alwaysBounceVertical = true
        view.refreshControl = refreshControl
        return view
    }()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        view.backgroundColor = .streamWhiteSnow
        collectionView.fillSuperview()
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.viewController = self
        configureNavBar()
        fetchData()
    }
    
    
    @objc private func didPullToRefresh(){
        fetchData()
        collectionView.refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard var statusBarStyle = navigationController?.navigationBar.barStyle else {return}
        statusBarStyle = .`default`
        navigationController?.navigationBar.overrideUserInterfaceStyle = .unspecified
        navigationController?.navigationBar.barStyle = statusBarStyle
    }
    
    
    // MARK: - Fetch Data
    private func fetchData(){
        viewModel.fetchData {[weak self] in
            self?.adapter.performUpdates(animated: true)
        }
    }
    
}

extension HomeViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is EventHomeCellViewModel {
            return EventSectionController()
        } else {
            return HomeSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
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
