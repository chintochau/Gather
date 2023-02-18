//
//  UserProfileViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-08.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    private var collectionView:UICollectionView?
    
    private let user:User
    
    private var events:[Event] {
        didSet{
            collectionView?.reloadData()
        }
    }
    
    init(user:User){
        self.user = user
        self.events = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        fetchData()
    }
    
    
    private func fetchData() {
        DatabaseManager.shared.fetchUserEvents(with: user.username) { [weak self] events in
            
            guard let events = events else {return}
            self?.events = events
        }
    }
}


extension UserProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // MARK: - configure CollectionView
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.headerReferenceSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmojiEventCollectionViewCell.self, forCellWithReuseIdentifier: EmojiEventCollectionViewCell.identifier)
        collectionView.register(ProfileHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        self.collectionView = collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return events.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileHeaderCollectionReusableView
            view.user = self.user
            view.delegate = self
            return view
        }else {
            return UICollectionReusableView()
        }
        
        

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {return CGSize(width: view.width, height: 250)}
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = events[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiEventCollectionViewCell.identifier, for: indexPath) as! EmojiEventCollectionViewCell
        cell.configure(with: EventCollectionViewCellViewModel(with: model))
        cell.widthAnchor.constraint(equalToConstant: view.width-20).isActive = true
        return cell
    }
    
}


extension UserProfileViewController:ProfileHeaderReusableViewDelegate {
    // MARK: - Handle send Message
    func ProfileHeaderReusableViewDelegatedidTapMessage(_ header: UICollectionReusableView, user: User) {
        
        let vc = ChatMessageViewController()
        vc.setupNavBar()
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
        
    }
    
}
