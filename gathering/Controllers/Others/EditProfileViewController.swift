//
//  EditProfileViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-25.
//

import UIKit


class EditProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextViewDelegate,UITextFieldDelegate {
    
    deinit {
        print("released")
    }
    
    private let imagePicker = UIImagePickerController()
    
    private var headerView:ProfileHeaderView?
    
    private let viewModels:[ProfileFieldType] = [
        .textField(title: "Name", placeholder: "Enter Name"),
        .textView(title: "Bio", placeholder: ""),
        .value(title: "Gender", value: "")
    ]
    private var tempField = (
        name:"",
        bio:"",
        gender:""
    )
    
    private var headerViewViewModel:ProfileHeaderViewViewModel?
    
    private var shouldUpdateImage:Bool = false
    
    private let tableView:UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .systemBackground
        view.register(TextFieldTableViewCell.self,
                      forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        view.register(TextViewTableViewCell.self,
                      forCellReuseIdentifier: TextViewTableViewCell.identifier)
        view.register(ValueTableViewCell.self, forCellReuseIdentifier: ValueTableViewCell.identifier)
        return view
    }()
    
    var completion: (() -> Void)?

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let email = UserDefaults.standard.string(forKey: "email") else {return}
        
        
        setUpTempField()
        
        headerViewViewModel = .init(
            profileUrlString: UserDefaults.standard.string(forKey: UserDefaultsType.profileUrlString.rawValue),
            username: username,
            email: email)
        
        setUpNavBar()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    
    fileprivate func setUpTempField() {
        if let name = UserDefaults.standard.string(forKey: "name") {
            tempField.name = name
        }
        
        if let gender = UserDefaults.standard.string(forKey: "gender"){
            tempField.gender = gender
        }
    }
    
    // MARK: - Nav bar
    
    fileprivate func setUpNavBar() {
        navigationItem.title = "Edit Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    // MARK: - Save Profile
    
    
    @objc private func didTapSave(){
        view.endEditing(true)
        
        if shouldUpdateImage {
            StorageManager.shared.uploadprofileImage(image: (headerView?.imageView.image)!) {[weak self] urlString in
                self?.updateDatabase(urlString)
            }
        }else {
            updateDatabase()
        }
    }
    
    fileprivate func updateDatabase(_ urlString: String? = nil) {
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let email = UserDefaults.standard.string(forKey: "email") else {return}
        
        let user = User(
            username: username,
            email: email,
            name: self.tempField.name,
            profileUrlString: urlString ?? UserDefaults.standard.string(forKey: UserDefaultsType.profileUrlString.rawValue),
            hobbies: nil,
            gender: self.tempField.gender)
        
        DatabaseManager.shared.updateUserProfile(user: user) { [weak self] success in
            guard success else {return}
            
            UserDefaultsManager.shared.updateUserProfile(with: user)
            self?.completion?()
            self?.dismiss(animated: true)
        }
    }
    
    
    
    
    // MARK: - Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = headerViewViewModel else {return nil}
        
        let view = ProfileHeaderView()
        view.configure(with: viewModel)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapPickImage))
        view.imageView.addGestureRecognizer(gesture)
        headerView = view
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModels[indexPath.row] {
            
        case .textField(title: let title, placeholder: let placeholder):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.configure(withTitle: title, placeholder: placeholder)
            cell.textField.text = tempField.name
            cell.textField.delegate = self
            return cell
        case .textView(title: let title, placeholder: let placeholder):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            
            cell.configure(withTitle: title, placeholder: placeholder)
            cell.textView.delegate = self
            
            return cell
            
        case .value(title: let title, value: _):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ValueTableViewCell.identifier, for: indexPath) as! ValueTableViewCell
            
            cell.configure(withTitle: title, placeholder: tempField.gender)
            return cell
        case .labelField:
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Text Input
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            tempField.name = text
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    
    @objc func didTapPickImage(){
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        guard let headerView = headerView else {return}
        
        headerView.imageView.image = tempImage
        shouldUpdateImage = true
        
        imagePicker.dismiss(animated: true)
        
    }
    
}
