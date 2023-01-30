//
//  EventViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-18.
//

import UIKit

class EventViewController: UIViewController {
    
    private let image:UIImage
    var headerView:HeaderCollectionReusableView?
    public var completion: (() -> Void)?
    
    private let collectionView:UICollectionView = {
        let layout = StretchyHeaderLayout()
        let view = UICollectionView(frame: .zero,collectionViewLayout: layout)
        return view
    }()
    
    
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.text = "Price"
        view.font = .systemFont(ofSize: 16,weight: .bold)
        return view
    }()
    private let priceNumberLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    private let bottomSheet:ParticipantsViewController
    private let selectButton = GAButton(title: "Enroll")
    
    var LikeButton:UIBarButtonItem?
    var shareButton:UIBarButtonItem?
    
    
    var infoViewModels:[EventInfoCollectionViewCellViewModel]
    private let event:Event
    
    
    // MARK: - Init
    init(viewModel vm:EventMainViewModel){
        event = vm.event
        image = vm.image
        infoViewModels = [
            .owner(name: vm.owner),
            .title(title: vm.title),
            .info(title: vm.date.title, subTitle: vm.date.subTitle, type: .time),
            .info(title: vm.location.area, subTitle: vm.location.address, type: .location),
            .info(title: "Refund Policy", subTitle: vm.refundPolicy, type: .refundPolicy),
            .extraInfo(title: "About", info: vm.about)
        ]
        priceNumberLabel.text = vm.price
        bottomSheet = ParticipantsViewController(event: event)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureExit(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Publish", style: .done, target: self, action: #selector(didTapPublish))
    }
    
    @objc func didTapClose(){
        self.dismiss(animated: true)
    }
    @objc func didTapPublish(){
        guard let completion = completion else {return}
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        completion()
        self.dismiss(animated: true)
    }

    // MARK: - LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        configureCollectionView()
        configureCollectionViewLayout()
        configureNavBar(shouldBeTransparent: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        var insets = view.safeAreaInsets
        insets.top = 0
        insets.bottom = insets.bottom+180
        collectionView.contentInset = insets
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBottomSheet()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bottomSheet.removeFromParent()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - bottomSheet
    
    fileprivate func addBottomSheet() {
        addChild(bottomSheet)
        view.addSubview(bottomSheet.view)
        bottomSheet.didMove(toParent: self)
    }
    
    
    // MARK: - collectionView
    fileprivate func configureCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(EventInfoCollectionViewCell.self, forCellWithReuseIdentifier: EventInfoCollectionViewCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        collectionView.register(EventOwnerCollectionViewCell.self, forCellWithReuseIdentifier: EventOwnerCollectionViewCell.identifier)
        
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Layout
    fileprivate func configureCollectionViewLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: 16, left: 16, bottom: 16, right: 16)
            layout.minimumLineSpacing = 10
            layout.estimatedItemSize = CGSize(width: view.width-32, height: 0)
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    
    
    @objc private func didTapEnroll(){
        guard let vm = EnrollViewModel(with: event) else {
            print("Fail to create VM")
            return}
        let vc = EnrollViewController(vm: vm)
        present(vc, animated: true)
    }
}

extension EventViewController {
    // MARK: - NavBar
    private func configureNavBar(shouldBeTransparent:Bool){
        guard let navBar = navigationController?.navigationBar else {return}
        if navigationItem.rightBarButtonItem == nil {
            LikeButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: nil)
            shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: nil)
            navigationItem.rightBarButtonItems =  [
                shareButton!,LikeButton!
            ]
        }
        
        
        let transparentAppearance = UINavigationBarAppearance()
        transparentAppearance.configureWithTransparentBackground()
        
        
        let normalAppearance = UINavigationBarAppearance(idiom: .phone)
        
        // Apply white color to all the nav bar buttons.
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        transparentAppearance.buttonAppearance = barButtonItemAppearance
        transparentAppearance.backButtonAppearance = barButtonItemAppearance
        transparentAppearance.doneButtonAppearance = barButtonItemAppearance
        normalAppearance.buttonAppearance = barButtonItemAppearance
        normalAppearance.backButtonAppearance = barButtonItemAppearance
        normalAppearance.doneButtonAppearance = barButtonItemAppearance
        
        
        
        if shouldBeTransparent {
            navBar.standardAppearance = transparentAppearance
            navBar.compactAppearance = transparentAppearance
            navBar.scrollEdgeAppearance = transparentAppearance
            LikeButton?.tintColor = .white
            shareButton?.tintColor = .white
        }else {
            navBar.standardAppearance = normalAppearance
            navBar.compactAppearance = normalAppearance
            navBar.scrollEdgeAppearance = normalAppearance
            LikeButton?.tintColor = .label
            shareButton?.tintColor = .label
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first,
              let statusBarHeight = window.windowScene?.statusBarManager?.statusBarFrame.height,
              let navBar = navigationController?.navigationBar,
              let headerView = headerView
        else {return}
        let offset = headerView.height - statusBarHeight - (navBar.height)
        
        configureNavBar(shouldBeTransparent: offset>0)
    }
}

extension EventViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,EventInfoCollectionViewCellDelegate {
    func EventInfoCollectionViewCellDidTapShowMore(_ cell: EventInfoCollectionViewCell) {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoViewModels.count
    }
    
    // MARK: - cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: EventOwnerCollectionViewCell.identifier, for: indexPath)
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return UICollectionViewCell()}
        let padding = layout.sectionInset.left + layout.sectionInset.right
        
        let vm = infoViewModels[indexPath.row]
        
        if case .owner(let name) = vm {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventOwnerCollectionViewCell.identifier, for: indexPath) as! EventOwnerCollectionViewCell
            cell.configure(with: name)
            cell.widthAnchor.constraint(equalToConstant: view.width-padding).isActive = true
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventInfoCollectionViewCell.identifier, for: indexPath) as! EventInfoCollectionViewCell
        cell.widthAnchor.constraint(equalToConstant: view.width-padding).isActive = true
        cell.configureCell(with:vm)
        cell.delegate = self
        return cell
        
    }
    
    
 
    
    // MARK: - header, footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        header.configure(with: image)
        header.clipsToBounds = true
        headerView = header
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: view.width)
    }
    
    
}


