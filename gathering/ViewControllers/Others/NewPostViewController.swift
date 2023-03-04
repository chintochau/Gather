//
//  NewPostViewController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-24.


import UIKit
import EmojiPicker



class NewPostViewController: UIViewController {
    
    
    // MARK: - Components
    private let tableView:UITableView = {
        let view =  UITableView(frame: .zero, style: .grouped)
        return view
    }()
    
    private let tempButton:UIButton = {
        let view = UIButton()
        view.setTitle("Submit", for: .normal)
        view.setTitleColor(.label, for: .normal)
        return view
    }()
    
    private var emojiButton:UIButton?
    
    
    // MARK: - Class members
    private var viewModels = [[InputFieldType]()]
    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    var completion: ((_ event:Event) -> Void)?
    
    var newPost = NewPost()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModels()
        view.backgroundColor = .systemBackground
        initialUser()
        configureTableView()
        setupNavBar()
        observeKeyboardChange()
        
        view.addSubview(tempButton)
        
        tempButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 30, right: 0))
        tempButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tempButton.addTarget(self, action: #selector(didTapPost), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - ViewModels
    
    private func initialUser(){
        guard let user = DefaultsManager.shared.getCurrentUser() else {return}
        newPost.participants = [user.username: Participant(with: user,status: Participant.participantStatus.going.rawValue)]
    }
    private func configureViewModels(){
        guard let _ = DefaultsManager.shared.getCurrentUser() else {return}
        
        var location = newPost.location.name
        if let address = newPost.location.address {
            location = location + "\n" + address
        }
        
        viewModels = [
            [
                .titleField(placeholder: "例： 滑雪/食日本野/周末聚下..."),
                .textView(title: "簡介:", text: newPost.intro,tag: 0)
            ],[
                .datePicker,
                .horizentalPicker(title: "地點:", selectedObject: newPost.location, objects: Location.filterArray)
            ],[
                .headCount,
                .participants
                    
            ]
        ]
        
        tableView.reloadData()
    }
    
    // MARK: - Nav Bar
    private func setupNavBar(){
        navigationItem.title = "組團"
        let postButton = UIBarButtonItem(image: UIImage(systemName: "paperplane"), style: .done, target: self, action: #selector(didTapPost))
        let previewButton = UIBarButtonItem(image: UIImage(systemName: "doc.text.magnifyingglass"), style: .done, target: self, action:#selector(didTapPreview))
        navigationItem.rightBarButtonItems = [postButton,previewButton]
    }
    
    // MARK: - Keyboard Handling
    private func observeKeyboardChange(){
        
        observer = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) {[weak self] notification in
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height+100, right: 0)
                }
            
        }
        
        hideObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
                self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        }
    }
}

extension NewPostViewController:UITableViewDelegate,UITableViewDataSource {
    // MARK: - TableView
    fileprivate func configureTableView() {
        view.addSubview(tableView)
        tableView.contentInset = .zero
        tableView.backgroundColor = .systemBackground
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: TextViewTableViewCell.identifier)
        tableView.register(TextLabelTableViewCell.self, forCellReuseIdentifier: TextLabelTableViewCell.identifier)
        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.identifier)
        tableView.register(ValueTableViewCell.self, forCellReuseIdentifier: ValueTableViewCell.identifier)
        tableView.register(HeadcountTableViewCell.self, forCellReuseIdentifier: HeadcountTableViewCell.identifier)
        tableView.register(ParticipantsTableViewCell.self, forCellReuseIdentifier: ParticipantsTableViewCell.identifier)
        tableView.register(TitleWithImageTableViewCell.self, forCellReuseIdentifier: TitleWithImageTableViewCell.identifier)
        tableView.register(HorizontalCollectionView.self, forCellReuseIdentifier: HorizontalCollectionView.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = viewModels[indexPath.section][indexPath.row]
//        let cell = UITableViewCell()
        
        switch vm {
        case .userField:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
            let user = DefaultsManager.shared.getCurrentUser()!
            cell.configure(with: user)
            cell.selectionStyle = .none
            cell.separator(hide: true)
            
            return cell
        case .textField(title: let title, placeholder: let placeholder,text: let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.configure(withTitle: title, placeholder: placeholder,text: text)
            cell.textField.delegate = self
            return cell
        case .textView(title: let title, text: let text,tag: let tag):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            cell.configure(withTitle: title, placeholder: text,tag: tag)
            cell.isOptional = true
            cell.textView.delegate = self
            return cell
        case .value(title: let title, value: let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: ValueTableViewCell.identifier, for: indexPath) as! ValueTableViewCell
            cell.configure(withTitle: title, value: value)
            return cell
        case .textLabel(text: let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextLabelTableViewCell.identifier, for: indexPath) as! TextLabelTableViewCell
            cell.configure(with: text)
            cell.separator(hide: true)
            return cell
        case .datePicker:
            let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as! DatePickerTableViewCell
            cell.delegate = self
            return cell
        case .headCount:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeadcountTableViewCell.identifier, for: indexPath) as! HeadcountTableViewCell
            cell.isOptional = true
            cell.delegate = self
            return cell
        case .participants:
            let cell = tableView.dequeueReusableCell(withIdentifier: ParticipantsTableViewCell.identifier, for: indexPath) as! ParticipantsTableViewCell
            cell.delegate = self
            return cell
        case .titleField(title:_,placeholder: let placeholder):
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithImageTableViewCell.identifier, for: indexPath) as! TitleWithImageTableViewCell
            cell.emojiButton.addTarget(self, action: #selector(openEmojiPickerModule), for: .touchUpInside)
            cell.titleField.delegate = self
            cell.titleField.placeholder = placeholder
            emojiButton = cell.emojiButton
            return cell
        case .horizentalPicker(title: let title,selectedObject: let selectedObject, objects: let objects):
            let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalCollectionView.identifier, for: indexPath) as! HorizontalCollectionView
            cell.configure(title: title, selectedObject: selectedObject, with: objects)
            cell.isOptional = true
            cell.delegate  = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ParticipantsTableViewCell.identifier, for: indexPath) as! ParticipantsTableViewCell
            cell.delegate = self
            return cell
        }
    }
    
    // MARK: - Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 && indexPath.section == 1 {
            let vc = LocationSearchViewController()
            vc.delegate = self
            let navVc = UINavigationController(rootViewController: vc)
            present(navVc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "有無人想: "
        case 1:
            return "時間/地點: "
        case 2:
            return "現有參加者:"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}

extension NewPostViewController {
    // MARK: - Handle Preview/ Post
    
    private func createPostFromNewPost() -> Event?{
        newPost.toEvent()
    }
    
    @objc private func didTapPreview(){
        view.endEditing(true)
        
        guard let event = createPostFromNewPost(), event.title.count > 1 else {
            AlertManager.shared.showAlert(title: "Oops~", message: "請輸入最少兩個字的標題", from: self)
            return
        }
        
        let vc = PreviewViewController()
        vc.configure(with: PreviewViewModel(event: event))
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.action = didTapPost
        present(vc, animated: true)
    }
    
    @objc private func didTapPost(){
        view.endEditing(true)
        
        guard let event = createPostFromNewPost(), event.title.count > 1 else {
            AlertManager.shared.showAlert(title: "Oops~", message: "請輸入最少兩個字的標題", from: self)
            return
        }
        DatabaseManager.shared.createEvent(with: event) { [weak self] success in
            self?.navigationController?.popToRootViewController(animated: false)
            self?.completion?(event)
        }
        
    }
}

extension NewPostViewController: LocationSerchViewControllerDelegate {
    // MARK: - Handle Location
    func didChooseLocation(_ VC: LocationSearchViewController, location: Location) {
        newPost.location = location
        configureViewModels()
    }
}

extension NewPostViewController:DatePickerTableViewCellDelegate {
    // MARK: - Handle DatePicker
    func DatePickerTableViewCellDelegateOnDateChanged(_ cell: DatePickerTableViewCell, startDate: Date, endDate: Date) {
        
        print(startDate)
        print(endDate)
        
        newPost.startDate = startDate
        newPost.endDate = endDate
    }
    
    func DatePickerDidTapAddEndTime(_ cell: DatePickerTableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}

extension NewPostViewController:HeadcountTableViewCellDelegate {
    // MARK: - handle Headcount
    func HeadcountTableViewCellDidEndEditing(_ cell: HeadcountTableViewCell, headcount: Headcount) {
        newPost.headcount = headcount
    }
    
    
    func HeadcountTableViewCellDidTapExpand(_ cell: HeadcountTableViewCell, headcount: Headcount) {
        newPost.headcount = headcount
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
extension NewPostViewController:UITextFieldDelegate {
    // MARK: - Handle TextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {return}
        newPost.title = text
    }
}

extension NewPostViewController:UITextViewDelegate {
    // MARK: - Handle TextView
    func textViewDidChange(_ textView: UITextView) {
        switch textView.tag {
        case 0:
            // Intro View
            newPost.intro = textView.text
        case 1:
            // addDetail View
            print("add info not yet implemented")
        default:
            print("Invalid Tag")
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension NewPostViewController:ParticipantsTableViewCellDelegate {
    // MARK: - Handle Participants
    func ParticipantsTableViewCellTextViewDidEndEditing(_ cell: ParticipantsTableViewCell, _ textView: UITextView, participants: [String : Participant]) {
        newPost.participants = participants
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func ParticipantsTableViewCellTextViewDidChange(_ cell: ParticipantsTableViewCell, _ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    
}

extension NewPostViewController:EmojiPickerDelegate {
    // MARK: - Pick Emoji
    
    @objc private func openEmojiPickerModule(sender: UIButton) {
        let viewController = EmojiPickerViewController()
        viewController.selectedEmojiCategoryTintColor = .mainColor
        viewController.delegate = self
        viewController.sourceView = sender
        present(viewController, animated: true)
    }
    
    
    func didGetEmoji(emoji: String) {
        UserDefaults.standard.setValue(emoji, forKey: "selectedEmoji")
        newPost.emojiTitle = emoji
        emojiButton?.setTitle(emoji, for: .normal)
    }
    
}

extension NewPostViewController:HorizontalCollectionViewCellDelegate {
    func horizontalCollectionViewCell(_ cell: HorizontalCollectionView, didSelectObject object: Any) {
        if let object = object as? Location {
            newPost.location = object
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
}
