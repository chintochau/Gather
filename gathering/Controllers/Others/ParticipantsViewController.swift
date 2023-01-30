//
//  ParticipantsViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-29.
//

import UIKit



class ParticipantsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let tableView:UITableView = {
        let view = UITableView()
        return view
    }()
    
    private var headerView:ParticipantsViewHeaderView?
    

    private let eventID:String
    private let event:Event
    
    init? (event:Event) {
        self.event = event
        self.eventID = event.id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModels = [User]()
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 20
//        view.layer.borderColor = UIColor.opaqueSeparator.cgColor
//        view.layer.borderWidth = 0.5
        view.clipsToBounds = true
        view.frame = CGRect(x: 0, y: view.height-130, width: view.width, height: view.height)
        configureHeaderView()
        configureViewModels()
        addGesture()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    
    // MARK: - ViewModels
    
    fileprivate func configureViewModels() {
        DatabaseManager.shared.fetchParticipants(with:eventID){[weak self] participants in
            guard let participants = participants else {return}
            self?.viewModels = participants
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - HeaderView
    fileprivate func configureHeaderView() {
        let header = ParticipantsViewHeaderView()
        header.configure(with: EventCollectionViewCellViewModel(with: event))
        view.addSubview(header)
        header.frame = CGRect(x: 0, y: 0, width: view.width, height: 130)
        header.delegate = self
        headerView = header
    }
    
    // MARK: - Background View
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .regular)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
    }
    
    // MARK: - Gesture
    fileprivate func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        guard let headerView = headerView else {return}
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        tapGesture.numberOfTapsRequired = 1
        headerView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Tap Gesture
    @objc func tapGesture(sender: UITapGestureRecognizer){
        
        UIView.animate(withDuration: 0.2) {
            self.view.frame = CGRect(x: 0, y: self.view.width, width: self.view.width, height: self.view.height)
        }
    }
    
    // MARK: - Pan Gesture adjust height
    @objc func panGesture(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let y = view.frame.minY
        let swipeSpeed = sender.velocity(in: view).y
        
        switch sender.state{
        case .began:
            break
        case .changed:
            if y < 100 {
                break
            }
            view.frame = CGRect(
                x: 0,
                y: y + (translation.y),
                width: view.width,
                height: view.height)
            sender.setTranslation(.zero, in: view)
        case .ended:
            let initialY = view.height-130
            var finalY:CGFloat
            
            if y < view.height/3.5 {
                // upper half
                if swipeSpeed > 1000 {
                    finalY = view.width
                } else {
                    finalY = 100
                }
            }else if y > view.height*2/3 {
                // lower half
                if swipeSpeed < -1000 {
                    finalY = view.width
                }else {
                    finalY = initialY
                    
                }
            }else {
                // middle range
                switch swipeSpeed {
                case 1000...:
                    finalY = initialY
                case ...(-1000):
                    finalY = 100
                case -1000...1000:
                    finalY = view.width
                default:
                    finalY = view.width
                }
                
            }
            UIView.animate(withDuration: 0.2) {
                self.view.frame = CGRect(x: 0, y: finalY, width: self.view.width, height: self.view.height)
            }
            sender.setTranslation(.zero, in: view)
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard  let gesture = gestureRecognizer as? UIPanGestureRecognizer else { return false}
            
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (tableView.contentOffset.y == 0 && direction > 0 || y == view.height-100)  {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        return false
    }
    
    
}

extension ParticipantsViewController:UITableViewDelegate,UITableViewDataSource {
    // MARK: - TableView
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        guard let headerView = headerView else {return}
        tableView.frame = CGRect(x: 0, y: headerView.bottom, width: view.width, height: view.height-headerView.height)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = viewModels[indexPath.row]
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        cell!.textLabel?.text = vm.name
        cell!.detailTextLabel?.text = vm.username
        cell?.imageView?.sd_setImage(with: URL(string: vm.profileUrlString ?? ""))
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension ParticipantsViewController:ParticipantsViewHeaderViewDelegate {
    func didTapEnroll(_ view: ParticipantsViewHeaderView) {
        
        guard let vm = EnrollViewModel(with: event) else {
            print("Fail to create VM")
            return}
        
        let vc = EnrollViewController(vm: vm)
        vc.completion = {[weak self] in
            self?.view.frame = CGRect(x: 0, y: (self?.view.width)!, width: self!.view.width, height: self!.view.height)
            self?.configureViewModels()
        }
        
        present(vc, animated: true)
    }
}
