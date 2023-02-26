//
//  EnrollViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-26.
//

import UIKit



struct EnrollViewModel {
    let name:String?
    let email:String
    let eventTitle:String
    let dateString:String
    let startDate:Date
    let endDate:Date
    let location:String
    let price:String
    let eventID:String
    let gender:String
    let event:Event
    
    init?(with event:Event) {
        guard let email = UserDefaults.standard.string(forKey: "email") else {return nil}
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        let gender = UserDefaults.standard.string(forKey: "gender") ?? "male"
        self.event = event
        self.gender = gender
        self.name = name
        self.email = email
        self.eventTitle = event.title
        self.dateString = event.startDateString
        self.location = event.location.name
        self.price = event.priceString
        self.eventID = event.id
        self.startDate = event.startDate
        self.endDate = event.endDate
    }
}


class EnrollViewController: UIViewController {
    
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private let nameField:GATextField = {
        let view = GATextField()
        view.configure(name: "Name")
        view.placeholder = "At least 2 characters"
        return view
    }()
    private let emailField:GATextField = {
        let view = GATextField()
        view.configure(name: "Email")
        view.isUserInteractionEnabled = false
        view.bottomLine.isHidden = true
        return view
    }()
    private let titleLabel:UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = 0
        return view
    }()
    
    private let dateLabel:UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .secondaryLabel
        return view
    }()
    private let locationLabel:UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .secondaryLabel
        return view
    }()
    private let confirmButton = GAButton(title: "Confirm")
    
    private let genderButton:UIButton = {
        let view = UIButton()
        view.setTitleColor(.label, for: .normal)
        return view
    }()
    
    private let genderSelectionView = GenderSelectionView()
    
    private let maleButton:UIButton = {
        let view = UIButton()
        view.tag = 0
        view.setTitle(genderType.allCases[view.tag].rawValue, for: .normal)
        view.setTitleColor(.label, for: .normal)
        return view
    }()
    private let femaleButton:UIButton = {
        let view = UIButton()
        view.tag = 1
        view.setTitle(genderType.allCases[view.tag].rawValue, for: .normal)
        view.setTitleColor(.label, for: .normal)
        return view
    }()
    private let nonBinaryButton:UIButton = {
        let view = UIButton()
        view.tag = 2
        view.setTitle(genderType.allCases[view.tag].rawValue, for: .normal)
        view.setTitleColor(.label, for: .normal)
        return view
    }()
    private let genderLabel:UILabel = {
        let view = UILabel()
        view.text = "Gender :"
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.textColor = .secondaryLabel
        return view
        
    }()
    
    private let eventID:String
    private let event:Event
    var completion: (() -> Void)?
    
    // MARK: - Init
    
    init(vm:EnrollViewModel){
        nameField.text = vm.name
        emailField.text = vm.email
        
        titleLabel.text = vm.eventTitle
        dateLabel.text = vm.dateString
        locationLabel.text = vm.location
        eventID = vm.eventID
        genderButton.setTitle(vm.gender, for: .normal)
        event = vm.event
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackBackground
        setupScrollView()
        anchorSubviews()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc private func didTapView(){
        view.endEditing(true)
        genderSelectionView.removeFromSuperview()
    }
    

    fileprivate func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.addSubview(containerView)
        containerView.anchor(
            top: scrollView.contentLayoutGuide.topAnchor,
            leading: scrollView.contentLayoutGuide.leadingAnchor,
            bottom: scrollView.contentLayoutGuide.bottomAnchor,
            trailing: scrollView.contentLayoutGuide.trailingAnchor)
        containerView.anchor(
            top: nil,
            leading: scrollView.frameLayoutGuide.leadingAnchor,
            bottom: nil,
            trailing: scrollView.frameLayoutGuide.trailingAnchor)
    }
    
    fileprivate func anchorSubviews() {
        [titleLabel,
         nameField,
         emailField,
         locationLabel,
         titleLabel,
         dateLabel,
         genderButton,
         genderLabel
        ].forEach({containerView.addSubview($0)})
        
        view.addSubview(confirmButton)
        
        titleLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor,padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        
        dateLabel.anchor(top: titleLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        locationLabel.anchor(top: dateLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        nameField.anchor(top: locationLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: emailField.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 50, left: 20, bottom: 30, right: 20))
        nameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailField.anchor(top: nameField.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 30, left: 20, bottom: 0, right: 20))
        
        genderLabel.anchor(top: emailField.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: genderButton.leadingAnchor,padding: .init(top: 20, left: 30, bottom: 0, right: 0))
        
        genderButton.anchor(top: genderLabel.topAnchor, leading: genderLabel.trailingAnchor, bottom: genderLabel.bottomAnchor, trailing: containerView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        confirmButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 20, bottom: 60, right: 20))
        
        
        nameField.delegate = self
        confirmButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        genderButton.addTarget(self, action: #selector(didTapGenderButton), for: .touchUpInside)
        
        maleButton.addTarget(self, action: #selector(didTapChooseGender(_:)), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(didTapChooseGender(_:)), for: .touchUpInside)
        nonBinaryButton.addTarget(self, action: #selector(didTapChooseGender(_:)), for: .touchUpInside)
        
        genderSelectionView.addArrangedSubview(maleButton)
        genderSelectionView.addArrangedSubview(femaleButton)
        genderSelectionView.addArrangedSubview(nonBinaryButton)
        
        
    }
    
    // MARK: - Register Event
    
    @objc func didTapConfirm(){
        
        guard let user = DefaultsManager.shared.getCurrentUser() else {
            print("cannot get user")
            return
        }
        
        DatabaseManager.shared.registerEvent(
            participant:user, eventID: eventID, event:event) {[weak self] success in
                         self?.completion?()
                         self?.dismiss(animated: true)
        }
    }
    
    @objc func didTapGenderButton(){
        view.addSubview(genderSelectionView)
        genderSelectionView.frame = CGRect(x: genderButton.left + (genderButton.width-100)/2, y: genderButton.top+20, width: 100, height: 0)
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.genderSelectionView.frame = CGRect(x: self.genderButton.left + (self.genderButton.width-100)/2, y: self.genderButton.bottom+5, width: 100, height: 120)
        }
    }
    
    @objc func didTapChooseGender(_ sender:UIButton) {
        genderSelectionView.removeFromSuperview()
        let text = genderType.allCases[sender.tag].rawValue
        genderButton.setTitle(text, for: .normal)
        UserDefaults.standard.set(text, forKey: "gender")
    }
    
    

}


extension EnrollViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              !text.isEmpty else {return}
        UserDefaults.standard.set(text, forKey: "name")
        textField.resignFirstResponder()
        
    }
}

