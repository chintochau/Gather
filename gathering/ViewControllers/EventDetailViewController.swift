//
//  EventDetailViewController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-27.
//

import UIKit
import IGListKit
import SwipeCellKit

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
        view.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        view.register(TextViewCollectionViewCell.self, forCellWithReuseIdentifier: TextViewCollectionViewCell.identifier)
        
        
        view.register(EventHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EventHeaderView.identifier)
        view.register(SectionHeaderRsuableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderRsuableView.identifier)
        view.keyboardDismissMode = .interactive
        return view
        
    }()
    
    private let ownerView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
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
        view.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        view.tintColor = .label
        return view
    }()
    
    
    private lazy var refreshControl:UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return view
    }()
    
    private let buttonStackView:UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .fillEqually
        return view
    }()
    
    // MARK: - Configure VM

    var viewModel:EventCellViewModel? {
        didSet {
            buttonStackView.arrangedSubviews.forEach({
                buttonStackView.removeArrangedSubview($0)
            })
            
            guard let vm = viewModel else {
                return
            }
            
            if let image = vm.image {
                headerView.image = image
                headerHeight = view.width
            } else if let imageUrl = vm.imageUrlString {
                headerView.setImageWithUrl(urlString: imageUrl) {[weak self] image in
                    vm.image = image
                    if let self = self {
                        self.headerHeight = self.view.width
                    }
                }
            } else {
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
                EventDetailsViewModel(event: vm.event),
                EventParticipantsViewModel(event: vm.event)
            ]
            
            participantsList = []
            participantsList.append(contentsOf: vm.friends)
            participantsList.append(contentsOf: vm.participantsExcludFriends)
            
            if vm.isOrganiser {
                configureButtonForOrganiser()
            } else if vm.isJoined {
                configureButtonForParticipant()
            } else {
                configureButton()
            }
            
            comments = vm.comments
            
            latestComments = Array(comments.sorted(by: {$0.timestamp > $1.timestamp}).prefix(3))
            
            collectionView.reloadData()
        }
    }
    
    var participantsList:[Participant] = []
    var VMs:[ListDiffable] = []
    
    var comments:[Comment] = []
    var latestComments:[Comment] = []
    var commentText:String? = ""
    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    private let bottomOffset:CGFloat = 150
    
    deinit {
        print("EventViewController: released")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(collectionView)
        view.addSubview(buttonStackView)
        view.addSubview(titleLabel)
        view.addSubview(messageButton)
        view.addSubview(ownerView)
        ownerView.addSubview(nameLabel)
        ownerView.addSubview(profileImageView)
        
        observeKeyboardChange()
        
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
        
        
        
        buttonStackView.anchor(top: collectionView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 5, left: 30, bottom: 40, right: 30),size: .init(width: view.width-60, height: 50))

        
        configureCollectionViewLayout()

    }
    
    
    // MARK: - Bottom Button
    fileprivate func configureButtonForOrganiser() {
        addEditButton()
        addFormGroupButton()
        addInviteButton()
    }
    
    fileprivate func configureButtonForParticipant(){
        addQuitButton()
        addInviteButton()
    }
    
    fileprivate func configureButton(){
        if let canJoin = viewModel?.canJoin, canJoin {
            addJoinButton()
            addInviteButton()
        } else {
            addFullButton()
            addWaitListButton()
        }
    }
    
    private func addEditButton(){
        
        lazy var editButton:GradientButton = {
            let view = GradientButton(type: .system)
            view.setTitleColor(.white, for: .normal)
            view.titleLabel?.font = .robotoMedium(ofSize: 16)
            view.setGradient(colors: [.lightMainColor,.darkMainColor], startPoint: .init(x: 0.5, y: 0.1), endPoint: .init(x: 0.5, y: 0.9))
            view.setTitle("編輯活動", for: .normal)
            view.gradientLayer?.cornerRadius = 15
            view.addTarget(self, action: #selector(didTapEnrollButton), for: .touchUpInside)
            return view
        }()
        buttonStackView.addArrangedSubview(editButton)
        
    }
    
    private func addQuitButton(){
        lazy var quitButton:GradientButton = {
            let view = GradientButton(type: .system)
            view.setTitleColor(.white, for: .normal)
            view.titleLabel?.font = .robotoMedium(ofSize: 16)
            view.setGradient(colors: [.lightMainColor,.darkMainColor], startPoint: .init(x: 0.5, y: 0.1), endPoint: .init(x: 0.5, y: 0.9))
            view.setTitle("退出", for: .normal)
            view.gradientLayer?.cornerRadius = 15
            view.addTarget(self, action: #selector(didTapEnrollButton), for: .touchUpInside)
            return view
        }()
        buttonStackView.addArrangedSubview(quitButton)
        
        
    }
    private func addInviteButton(){
        lazy var formGroupButton:GradientButton = {
            let view = GradientButton(type: .system)
            view.setTitleColor(.white, for: .normal)
            view.titleLabel?.font = .robotoMedium(ofSize: 16)
            view.setGradient(colors: [.lightMainColor,.darkMainColor], startPoint: CGPoint(x: 0.5, y: 0.1), endPoint: CGPoint(x: 0.5, y: 0.9))
            view.setTitle("邀請朋友", for: .normal)
            view.gradientLayer?.cornerRadius = 15
            view.addTarget(self, action: #selector(didTapInviteFriend), for: .touchUpInside)
            return view
        }()
        buttonStackView.addArrangedSubview(formGroupButton)
    }
    
    private func addFormGroupButton(){
        let isFormed = (viewModel?.event.eventStatus ?? .grouping) == .confirmed
        lazy var formGroupButton:GradientButton = {
            let view = GradientButton(type: .system)
            view.setTitleColor(.white, for: .normal)
            view.titleLabel?.font = .robotoMedium(ofSize: 16)
            view.setGradient(colors: [.lightMainColor,.darkMainColor], startPoint: CGPoint(x: 0.5, y: 0.1), endPoint: CGPoint(x: 0.5, y: 0.9))
            view.setTitle(isFormed ? "己成團" : "成團", for: .normal)
            view.gradientLayer?.cornerRadius = 15
            view.addTarget(self, action: #selector(didTapFormEvent), for: .touchUpInside)
            return view
        }()
        buttonStackView.addArrangedSubview(formGroupButton)
    }
    
    private func addWaitListButton(){
        if viewModel?.allowWaitList ?? false {
            lazy var quitButton:GradientButton = {
                let view = GradientButton(type: .system)
                view.setTitleColor(.white, for: .normal)
                view.titleLabel?.font = .robotoMedium(ofSize: 16)
                view.setGradient(colors:[.lightMainColor,.darkMainColor] , startPoint: .init(x: 0.5, y: 0.1), endPoint: .init(x: 0.5, y: 0.9))
                view.setTitle("加入候補名單", for: .normal)
                view.gradientLayer?.cornerRadius = 15
                view.addTarget(self, action: #selector(didTapEnrollButton), for: .touchUpInside)
                return view
            }()
            buttonStackView.addArrangedSubview(quitButton)
        }
    }
    
    private func addJoinButton(){
        lazy var quitButton:GradientButton = {
            let view = GradientButton(type: .system)
            view.setTitleColor(.white, for: .normal)
            view.titleLabel?.font = .robotoMedium(ofSize: 16)
            view.setGradient(colors: [.lightMainColor,.darkMainColor] , startPoint: .init(x: 0.5, y: 0.1), endPoint: .init(x: 0.5, y: 0.9))
            view.setTitle("參加", for: .normal)
            view.gradientLayer?.cornerRadius = 15
            view.addTarget(self, action: #selector(didTapEnrollButton), for: .touchUpInside)
            return view
        }()
        buttonStackView.addArrangedSubview(quitButton)
    }
    
    private func addFullButton(){
        lazy var quitButton:GradientButton = {
            let view = GradientButton(type: .system)
            view.setTitleColor(.white, for: .normal)
            view.titleLabel?.font = .robotoMedium(ofSize: 16)
            view.setGradient(colors:[.lightGray,.lightGray] , startPoint: .init(x: 0.5, y: 0.1), endPoint: .init(x: 0.5, y: 0.9))
            view.setTitle("已滿", for: .normal)
            view.gradientLayer?.cornerRadius = 15
            view.addTarget(self, action: #selector(didTapEnrollButton), for: .touchUpInside)
            return view
        }()
        buttonStackView.addArrangedSubview(quitButton)
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
    

    
    fileprivate func configureCollectionViewLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: view.width, height: 200)
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
            
        }
    }

    private func eventDoesNotExist (){
        AlertManager.shared.showAlert(title: "Oops~",message: "活動不存在或者已取消", buttonText: "Dismiss",cancelText: nil, from: self) {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func didTapShare(){
        guard let string = viewModel?.event.toString(includeTime: true) else {return}
        let activityVC = UIActivityViewController(activityItems: [string], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
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
                if viewModel?.canJoin ?? false {
                    registerEvent()
                }else {
                    print("Full, join wait list")
                }
            }
        }
    }
    
    @objc private func didTapFormEvent(){
        
        guard let eventStatus = viewModel?.event.eventStatus,
              eventStatus != .confirmed
        else {return}
        
        // confirm this event
        // send notification to all joiners
        guard let eventID = viewModel?.event.id,
              let eventRef = viewModel?.event.referencePath else {return}
        
        DatabaseManager.shared.confirmFormEvent(eventID: eventID, eventRef: eventRef) { [weak self] success in
            self?.refreshPage()
        }
    }
    
    @objc private func didTapChat(){
        guard AuthManager.shared.isSignedIn else {
            AlertManager.shared.showAlert(title: "Oops~", message: "Please login to send message", from: self)
            return
        }
        
        guard let targetusername = viewModel?.organiser?.username else {return}
        let vc = ChatMessageViewController(targetUsername: targetusername)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapInviteFriend(){
        let vc = InviteViewController()
        let navVc = UINavigationController(rootViewController: vc)
        navVc.hero.isEnabled = true
        navVc.hero.modalAnimationType = .autoReverse(presenting: .push(direction: .left))
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
        
        
    }
    
    
    private func editEvent(){
        // MARK: - Edit Event (need modify)
        // edit event does not have event ref, changing date will create another event, need to modify
        let vc = NewPostViewController()
        if let editPost = viewModel?.event.toNewPost() {
            vc.newPost = editPost
            vc.image = viewModel?.image
            vc.isEditMode = true
            vc.eventStatus = viewModel?.event.eventStatus ?? .grouping
        }
        
        vc.completion = {[weak self] event, image in
            if let _ = event {
                // event modified
                self?.dismiss(animated: true)
                self?.refreshPage()
                
            }else {
                // event deleted
                self?.dismiss(animated: false)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        present(vc, animated: true)
    }
    
    private func registerEvent(){
        if !AuthManager.shared.isSignedIn {
            AlertManager.shared.showAlert(title: "Oops~", message: "Please login to join events", from: self)
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
    
    @objc private func didPullToRefresh(){
        refreshPage()
    }
    
    private func refreshPage(){
        guard let event = viewModel?.event,
              let vm = EnrollViewModel(with: event) else {
            print("Fail to create VM")
            return}
        
        DatabaseManager.shared.fetchSingleEvent(event: vm.event) { [weak self] event in
            guard let event = event else {
                
                self?.dismiss(animated: true)
                return
            }
            let viewModel = EventCellViewModel(event: event)
            
            if let imageUrl = viewModel.imageUrlString, let self = self {
                
            }else {
                viewModel.image = self?.viewModel?.image
            }
            
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return VMs.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case ..<VMs.count:
            return 1
        case VMs.count: //Comments number
            return latestComments.count+1
        case VMs.count+1: // Participants number
            return min(participantsList.count, 5)
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0: // event detail
            let vm = VMs[indexPath.section]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDetailInfoCell.identifier, for: indexPath) as! EventDetailInfoCell
            cell.bindViewModel(vm)
            cell.widthAnchor.constraint(equalToConstant: view.width).isActive = true
            return cell
            
        case 1: // event participants number
            let vm = VMs[indexPath.section]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDetailParticipantsCell.identifier, for: indexPath) as! EventDetailParticipantsCell
            cell.bindViewModel(vm)
            cell.widthAnchor.constraint(equalToConstant: view.width).isActive = true
            return cell
            
        case 2: // event comments
            switch indexPath.row {
            case latestComments.count: // the last cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextViewCollectionViewCell.identifier, for: indexPath) as! TextViewCollectionViewCell
                cell.widthAnchor.constraint(equalToConstant: view.width).isActive = true
                cell.configure(withTitle: "", text: commentText)
                cell.textView.delegate = self
                cell.sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
                cell.bindViewModel(latestComments[indexPath.row])
                cell.widthAnchor.constraint(equalToConstant: view.width).isActive = true
                return cell
            }
            
            
        default: // Participants List
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier, for: indexPath) as! UserCollectionViewCell
            cell.bindViewModel(participantsList[indexPath.row])
            cell.widthAnchor.constraint(equalToConstant: view.width).isActive = true
            cell.heightAnchor.constraint(equalToConstant: 60).isActive = true
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section ==  VMs.count+1{
            didTapUserProfile(participant: participantsList[indexPath.row])
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch section {
        case 0:
            return .init(width: view.width, height: headerHeight)
        case VMs.count:
            return .init(width: view.width, height: 30)
        case VMs.count+1:
            return .init(width: view.width, height: 30)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderRsuableView.identifier, for: indexPath) as! SectionHeaderRsuableView
        sectionHeader.delegate = self
        
        switch indexPath.section {
        case VMs.count:
            sectionHeader.configure(with: .init(title: "留言:  ", buttonText: "全部(\(comments.count))", index: 2))
            return sectionHeader
        case VMs.count+1:
            if let vm = VMs[1] as? EventParticipantsViewModel {
                sectionHeader.configure(with: .init(title: vm.numberOfFriends, buttonText: "全部(\(participantsList.count))", index: 3))
            }
            return sectionHeader
        default:
            return sectionHeader
        }
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

extension EventDetailViewController:UITextViewDelegate,SectionHeaderReusableViewDelegate {
    func SectionHeaderReusableViewDidTapActionButton(_ view: SectionHeaderRsuableView, button: UIButton) {
        let vc = CollectionListViewController()
        
        let navVc = UINavigationController(rootViewController: vc)
        navVc.hero.isEnabled = true
        navVc.hero.modalAnimationType = .autoReverse(presenting: .push(direction: .left))
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
        
    }
    
    
    @objc private func didTapSend(){
        guard let vm = viewModel, let text = commentText else {return}
        
        
        DatabaseManager.shared.postComments(event: vm.event, message: text) { [weak self] success in
            if success {
                
                DatabaseManager.shared.fetchSingleEvent(event: vm.event) { [weak self] event in
                    guard let event = event else {
                        
                        self?.dismiss(animated: true)
                        return
                    }
                    let viewModel = EventCellViewModel(event: event)
                    
                    if let imageUrl = viewModel.imageUrlString, let self = self {
                        
                    }else {
                        viewModel.image = self?.viewModel?.image
                    }
                    self?.commentText = ""
                    self?.viewModel = viewModel
                    self?.collectionView.reloadSections(.init(integer: 2))
                    
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        commentText = textView.text
        
        collectionView.performBatchUpdates {
            
        }
        
    }
    
    
    // MARK: - Keyboard Handling
    private func observeKeyboardChange(){
        
        observer = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) {[weak self] notification in
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self?.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + self!.bottomOffset, right: 0)
                }
            
        }
        
        hideObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
            self?.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self!.bottomOffset, right: 0)
        }
    }
}
