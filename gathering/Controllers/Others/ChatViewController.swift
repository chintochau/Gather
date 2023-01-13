//
//  EventViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-12.
//

import UIKit
import IGListKit


class ChatViewController: UIViewController{
    
    
    private let collectionView:UICollectionView = {
        let view = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var adapter:ListAdapter = {
        return ListAdapter(
            updater: ListAdapterUpdater(),
            viewController: self,
            workingRangeSize: 0)
    }()
    
    private let event:Event
    private let eventImage:UIImage
    
    private var statusBarFrame:CGRect = {
        let frame = CGRect.zero
        return frame
    }()
    private var statusBarView = UIView()
    
    private let scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        return scroll
    }()
    
    private let contentView:UIView = {
        let view = UIView()
        return view
    }()
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    
    // MARK: - Init
    init(event:Event,image:UIImage) {
        self.event = event
        self.eventImage = image
        imageView.image = eventImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    private func setup(){
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        
    }
}

extension ChatViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let data: [NSString] = ["Apple","Facebook","Amazon","","1"]
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return LabelSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
