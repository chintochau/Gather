//
//  EditProfileViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-25.
//

import UIKit
import FirebaseMessaging


class EditProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextViewDelegate,UITextFieldDelegate {
    
    
    private let imagePicker = UIImagePickerController()
    
    private var headerView:ProfileHeaderView?
    
    private let viewModels:[InputFieldType] = [
        .textField(title: "Name", placeholder: "Enter Name"),
        .value(title: "Gender", value: ""),
        .value(title: "Age (only visible to yourself)", value: "")
    ]
    private var tempField = (
        name:"",
        bio:"",
        gender:""
    )
    
    private var headerViewViewModel:ProfileHeaderViewViewModel?
    private let genderSelectionView = GenderSelectionView()
    
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
    private var shouldUpdateImage:Bool = false

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        setUpTempField()
        configureViewModels()
        setUpNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
    }
    
    private func configureViewModels(){
        guard let user = DefaultsManager.shared.getCurrentUser() else {return}
        headerViewViewModel = .init(user:user)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    // MARK: - setUpTempField
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
            gender: self.tempField.gender,
            fcmToken: Messaging.messaging().fcmToken
        )
        
        DatabaseManager.shared.updateUserProfile(user: user) { [weak self] user in
            
            DefaultsManager.shared.updateUserProfile(with: user)
            
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
            
        case .textField(title: let title, placeholder: let placeholder,text: _):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.configure(withTitle: title, placeholder: placeholder)
            cell.textField.text = tempField.name
            cell.textField.delegate = self
            return cell
        case .textView(title: let title, text: let text,tag: _):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            
            if title == "Bio" {
                cell.configure(withTitle: title, placeholder: tempField.bio)
            }else {
                cell.configure(withTitle: title, placeholder: text)
            }
            cell.textView.delegate = self
            return cell
            
        case .value(title: let title, value: _):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ValueTableViewCell.identifier, for: indexPath) as! ValueTableViewCell
            
            cell.configure(withTitle: title, value: tempField.gender)
            cell.selectionStyle = .none
            return cell
        case  .userField, .textLabel,.datePicker,.headCount :
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedCell = tableView.cellForRow(at: indexPath) else {return}
        
        switch viewModels[indexPath.row] {
        case .value(title: let title, value: _):
            if title == "Gender" {
                genderSelectionView.delegate = self
                view.addSubview(genderSelectionView)
                let viewWidth:CGFloat = 100
                genderSelectionView.frame = CGRect(
                    x: selectedCell.width-viewWidth-20,
                    y: selectedCell.bottom+selectedCell.height,
                    width: viewWidth,
                    height: 0)
                
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.genderSelectionView.frame = CGRect(
                        x: selectedCell.width-viewWidth-20,
                        y: selectedCell.bottom+selectedCell.height+10,
                        width: viewWidth,
                        height: 120)
                }
            }else {return}
        default: break
            
        }
        
    }
    
    
//    @objc func didTapChooseGender(_ sender:UIButton) {
//        genderSelectionView.removeFromSuperview()
//        let text = genderType.allCases[sender.tag].rawValue
//        genderButton.setTitle(text, for: .normal)
//        UserDefaults.standard.set(text, forKey: "gender")
//    }
    
    
    // MARK: - Text Input
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        if let text = textView.text {
            tempField.bio = text
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            tempField.name = text
        }
    }
}

extension EditProfileViewController:GenderSelectionViewDelegate {
    // MARK: - Pick Gender
    func GenderSelectionViewDidSelectItem(_ view: GenderSelectionView, item: String) {
        tempField.gender = item
        tableView.reloadData()
    }
    
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    // MARK: - Pick Image
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
