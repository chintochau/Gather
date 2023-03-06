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
        view.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
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
    
    private let titleLabel:UILabel = {
        let view = UILabel()
        view.font = .robotoSemiBoldFont(ofSize: 30)
        view.numberOfLines = 2
        return view
    }()
    
    private let profileImageView:UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.image = .personIcon
        view.tintColor = .lightGray
        return view
    }()
    
    private lazy var messageButton:UIButton = {
        let view = UIButton()
        view.backgroundColor = .systemBackground
        view.setImage(.messageIcon, for: .normal)
        return view
    }()
    
    private lazy var enrollButton:GradientButton = {
        let view = GradientButton(type: .system)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.setGradient(colors: [.lightMainColor!,.darkMainColor!], startPoint: .init(x: 0.5, y: 0.1), endPoint: .init(x: 0.5, y: 0.9))
        view.addTarget(self, action: #selector(didTapEnrollButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var refreshControl:UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return view
    }()
    
    
    var viewModel:EventHomeCellViewModel? {
        didSet {
            guard let vm = viewModel else {return}
            if let image = vm.image {
                headerView.image = image
                headerHeight = view.width
                
            }else {
                headerHeight = 250
            }
            
            nameLabel.text = vm.organiser?.name
            titleLabel.text = vm.title
            if let profileUrlString = vm.organiser?.profileUrlString {
                profileImageView.sd_setImage(with: URL(string: profileUrlString))
                
            }
            navigationItem.title = vm.title
            headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: headerHeight)
            
            VMs = [
                EventDetails(event: vm.event),
                EventParticipants(participants: vm.participants)
            ]
            
            participantsList = []
            participantsList.append(contentsOf: vm.friends)
            participantsList.append(contentsOf: vm.participantsExcludFriends)
            
            if vm.isOrganiser {
                enrollButton.setTitle("輯編活動", for: .normal)
            }else {
                enrollButton.setTitle(vm.isJoined ? "己參加": "我要參加", for: .normal)
            }
            
            collectionView.reloadData()
        }
    }
    
    var participantsList:[Participant] = []
    var VMs:[ListDiffable] = []
    
    
    deinit {
        print("EventViewController: released")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(collectionView)
        view.addSubview(enrollButton)
        view.addSubview(titleLabel)
        view.addSubview(messageButton)
        view.addSubview(ownerView)
        ownerView.addSubview(nameLabel)
        ownerView.addSubview(profileImageView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(didTapShare))
        
        
        collectionView.backgroundColor = .clear
        collectionView.scrollIndicatorInsets = .init(top: -100, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Add the refresh control as a subview of the collection view layout
        collectionView.addSubview(refreshControl)

        // Adjust the refresh control position to be below the header view
        refreshControl.anchor(top: headerView.bottomAnchor, leading: nil, bottom: nil, trailing: nil)
        refreshControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        enrollButton.anchor(top: collectionView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 5, left: 30, bottom: 40, right: 30),size: .init(width: view.width-60, height: 50))
        enrollButton.layer.cornerRadius = 25
        ownerView.anchor(top: nil, leading: view.leadingAnchor, bottom: headerView.bottomAnchor, trailing: nil,
                         padding: .init(top: 0, left: 30, bottom: 20, right: 30),size: .init(width: 0, height: 50))
        ownerView.layer.cornerRadius = 25
        
        
        titleLabel.anchor(top: nil, leading: ownerView.leadingAnchor, bottom: ownerView.topAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 20, right: 30))
        
        messageButton.anchor(top: nil, leading: nil, bottom: headerView.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 20, right: 30),size: .init(width: 50, height: 50))
        messageButton.layer.cornerRadius = 25
        messageButton.addTarget(self, action: #selector(didTapChat), for: .touchUpInside)
        
        let profileSize:CGFloat = 40
        profileImageView.anchor(top: ownerView.topAnchor, leading: ownerView.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 5, left: 5, bottom: 0, right: 0),size: .init(width: profileSize, height: profileSize))
        profileImageView.layer.cornerRadius = 20
        nameLabel.anchor(top: ownerView.topAnchor, leading: profileImageView.trailingAnchor, bottom: ownerView.bottomAnchor, trailing: ownerView.trailingAnchor,
                         padding: .init(top: 5, left: 10, bottom: 5, right: 10))
        
        
        
        configureCollectionViewLayout()

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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.standardAppearance = UINavigationBarAppearance()
        
        if let tabBarController = navigationController?.tabBarController as? TabBarViewController {
            tabBarController.showTabBar()
        }
    }
    
    // MARK: - Public Functions
    
    public func configureWithID(eventID:String, eventReferencePath:String) {
        DatabaseManager.shared.fetchSingleEvent(eventID: eventID, eventReferencePath: eventReferencePath) {[weak self] event in
            guard let event = event else {
                self?.eventDoesNotExist()
                return}
            self?.viewModel = .init(event: event)
        }
    }
    
    public func configureCloseButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    
    // MARK: - Private Functions
    
    
    private func eventDoesNotExist (){
        AlertManager.shared.showAlert(title: "Oops~",message: "活動不存在或者己取消", buttonText: "Dismiss",cancelText: nil, from: self) {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func didTapShare(){
        guard let string = viewModel?.event.toString(includeTime: true) else {return}
        let activityVC = UIActivityViewController(activityItems: [string], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    
    
    fileprivate func configureCollectionViewLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: view.width, height: 200)
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
            
        }
    }
    
    
    @objc private func didTapEnrollButton(){
        
        if viewModel?.isOrganiser ?? false {
            editEvent()
        }else {
            if viewModel?.isJoined ?? false {
                // if already joined, tap to unregister
                unregisterEvent()
            }else {
                // if not joined, tap to join
                registerEvent()
            }
        }
    }
    
    @objc private func didTapChat(){
        guard AuthManager.shared.isSignedIn else {
            AlertManager.shared.showAlert(title: "Oops~", message: "Please login in to send message", from: self)
            return
        }
        
        guard let targetusername = viewModel?.organiser?.username else {return}
        let vc = ChatMessageViewController(targetUsername: targetusername)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didPullToRefresh(){
        refreshPage()
    }
    
    private func editEvent(){
        let vc = NewEventViewController()
        present(vc, animated: true)
    }
    
    private func registerEvent(){
        if !AuthManager.shared.isSignedIn {
            AlertManager.shared.showAlert(title: "Oops~", message: "Please login in to join events", from: self)
        }
        
        guard let event = viewModel?.event,
              let vm = EnrollViewModel(with: event) else {
            print("Fail to create VM")
            return}
        
        let vc = EnrollViewController(vm: vm)
        vc.completion = {[weak self] in
            self?.refreshPage()
        }
        present(vc, animated: true)
    }
    
    private func unregisterEvent(){
        AlertManager.shared.showAlert(title: "要退出嗎?", buttonText: "退出", from: self) {[weak self] in
            // Perform the function here
            guard let event = self?.viewModel?.event else {return}
            DatabaseManager.shared.unregisterEvent(event: event) { bool in
                self?.refreshPage()
            }
        }
    }
    
    private func refreshPage(){
        guard let event = viewModel?.event,
              let vm = EnrollViewModel(with: event) else {
            print("Fail to create VM")
            return}
        DatabaseManager.shared.fetchSingleEvent(event: vm.event) { [weak self] event in
            guard let event = event else {return}
            let viewModel = EventHomeCellViewModel(event: event)
            viewModel.image = self?.viewModel?.image
            self?.viewModel = viewModel
            self?.collectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Open user profile
    private func didTapUserProfile(participant:Participant){
        guard let user = User(with: participant) else {return}
        let vc = UserProfileViewController(user: user)
        present(vc, animated: true)
    }
    
    
    @objc private func didTapClose(){
        dismiss(animated: true)
    }
    
}


extension EventDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VMs.count + participantsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let vm = VMs[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDetailInfoCell.identifier, for: indexPath) as! EventDetailInfoCell
            cell.bindViewModel(vm)
            cell.widthAnchor.constraint(equalToConstant: view.width).isActive = true
            return cell
            
        case 1:
            let vm = VMs[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDetailParticipantsCell.identifier, for: indexPath) as! EventDetailParticipantsCell
            cell.bindViewModel(vm)
            cell.widthAnchor.constraint(equalToConstant: view.width).isActive = true
            return cell
        case 2...participantsList.count+1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier, for: indexPath) as! UserCollectionViewCell
            cell.bindViewModel(participantsList[indexPath.row-2])
            cell.widthAnchor.constraint(equalToConstant: view.width).isActive = true
            cell.heightAnchor.constraint(equalToConstant: 60).isActive = true
            return cell
        default:
            fatalError()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2...participantsList.count+1:
            didTapUserProfile(participant: participantsList[indexPath.row-2])
        default:
            break
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
            // Run code in iOS 15 or later.
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

