//
//  EventDetailViewController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-27.
//

import UIKit
import IGListKit

class EventDetailViewController: UIViewController {
    
    var headerHeight:CGFloat = 0
    
    private let headerView = EventHeaderView()
    
    var navBarAppearance = UINavigationBarAppearance()
    
    private let collectionView :UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInsetAdjustmentBehavior = .never
        view.contentInset = .init(top: 0, left: 0, bottom: 88, right: 0)
        
        view.register(EventDetailInfoCell.self, forCellWithReuseIdentifier: EventDetailInfoCell.identifier)
        view.register(EventDetailParticipantsCell.self, forCellWithReuseIdentifier: EventDetailParticipantsCell.identifier)
        return view
        
    }()
    
    private let ownerView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        return view
    }()
    
    private let nameLabel:UILabel = {
        let view = UILabel()
        return view
    }()
    private let profileImageView:UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        return view
    }()
    
    private let messageButton:UIButton = {
        let view = UIButton()
        view.backgroundColor = .systemBackground
        view.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        view.tintColor = .label
        return view
    }()
    
    private let enrollButton:GradientButton = {
        let view = GradientButton(type: .system)
        view.setTitle("我要參加", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.setGradient(colors: [.lightMainColor!,.darkMainColor!], startPoint: .init(x: 0.5, y: 0.1), endPoint: .init(x: 0.5, y: 0.9))
        return view
    }()
    
    
    var viewModel:EventHomeCellViewModel? {
        didSet {
            guard let vm = viewModel else {return}
            if let image = vm.image {
                headerView.image = image
                headerHeight = view.width
            }else {
                headerHeight = 111
            }
            nameLabel.text = vm.organiser?.name
            profileImageView.sd_setImage(with: URL(string: vm.organiser?.profileUrlString ?? ""))
            navigationItem.title = vm.title
            headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: headerHeight)
            headerView.event = vm.event
            
            VMs = [
                EventDetails(event: vm.event),
                EventParticipants(participants: vm.participants)
            ]
        }
    }
    
    var VMs:[ListDiffable] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
        hero.modalAnimationType = .autoReverse(presenting: .push(direction: .left))
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(collectionView)
        view.addSubview(enrollButton)
        view.addSubview(ownerView)
        view.addSubview(messageButton)
        ownerView.addSubview(nameLabel)
        ownerView.addSubview(profileImageView)
        
        collectionView.backgroundColor = .clear
        collectionView.scrollIndicatorInsets = .init(top: -100, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        enrollButton.anchor(top: collectionView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 5, left: 30, bottom: 40, right: 30),size: .init(width: view.width-60, height: 50))
        enrollButton.layer.cornerRadius = 25
        ownerView.anchor(top: nil, leading: view.leadingAnchor, bottom: headerView.bottomAnchor, trailing: nil,
                         padding: .init(top: 0, left: 30, bottom: 20, right: 30),size: .init(width: 0, height: 50))
        ownerView.layer.cornerRadius = 25
        
        messageButton.anchor(top: nil, leading: nil, bottom: headerView.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 20, right: 30),size: .init(width: 50, height: 50))
        messageButton.layer.cornerRadius = 25
        
        let profileSize:CGFloat = 40
        profileImageView.anchor(top: ownerView.topAnchor, leading: ownerView.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 5, left: 5, bottom: 0, right: 0),size: .init(width: profileSize, height: profileSize))
        profileImageView.layer.cornerRadius = 20
        nameLabel.anchor(top: ownerView.topAnchor, leading: profileImageView.trailingAnchor, bottom: ownerView.bottomAnchor, trailing: ownerView.trailingAnchor,
                         padding: .init(top: 5, left: 10, bottom: 5, right: 10))
        
        
        
        configureCollectionViewLayout()

    }
    
    
    
    fileprivate func configureCollectionViewLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: view.width, height: 200)
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Set the navigation bar to be transparent
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        if let tabBarController = navigationController?.tabBarController as? TabBarViewController {
            tabBarController.hideTabBar()
        }
//        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.standardAppearance = UINavigationBarAppearance()
        if let tabBarController = navigationController?.tabBarController as? TabBarViewController {
            tabBarController.showTabBar()
        }
//        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    

}


extension EventDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vm = VMs[indexPath.row]
        
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDetailInfoCell.identifier, for: indexPath) as! EventDetailInfoCell
            cell.bindViewModel(vm)
            cell.widthAnchor.constraint(equalToConstant: view.width).isActive = true
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDetailParticipantsCell.identifier, for: indexPath) as! EventDetailParticipantsCell
            cell.bindViewModel(vm)
            cell.widthAnchor.constraint(equalToConstant: view.width).isActive = true
            return cell
            
        default:
            fatalError()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.width, height: headerHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let headerHeight: CGFloat = headerHeight // set the height of your header view here
        let headerBottom = headerHeight - 110
        headerView.alpha = 1.3 - offset/(headerHeight-200)
        
        if offset < 0 { // pull to enlarge photo
            headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: headerHeight-offset)
        }else {
            headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: headerHeight-offset)
        }
        
        
        if offset >= headerBottom {
            // The header is scrolled to the top of the navigation bar, so make the navigation bar solid
            navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        } else {
            // The header is still visible, so keep the navigation bar transparent
            navBarAppearance.configureWithTransparentBackground()
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
            
        }

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
}

