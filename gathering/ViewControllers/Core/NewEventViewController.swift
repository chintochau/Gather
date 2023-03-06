//
//  NewEventViewController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-03-03.
//

import UIKit
import EmojiPicker



class NewEventViewController: UIViewController {
    
    
    // MARK: - Components
    private let tableView:UITableView = {
        let view =  UITableView(frame: .zero, style: .grouped)
        return view
    }()
    
    
    private var emojiButton:UIButton?
    
    private let headerView:UIView = {
        let headerImageView:UIImageView = {
            let view = UIImageView()
            view.image  = UIImage(named: "eventHeader")
            view.contentMode = .scaleAspectFit
            return view
        }()
        
        let titleLabel:UILabel = {
            let view = UILabel()
            view.text = "組團"
            view.font = .robotoSemiBoldFont(ofSize: 24)
            return view
        }()
        
        
        let view = UIView()
        view.addSubview(headerImageView)
        headerImageView.frame = CGRect(x: 0, y: 0, width: 390, height: 130)
        view.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 30, y: 130, width: 100, height: 60)
        
        return view
    }()
    
    
    private let tempButton:UIButton = {
        let view = UIButton()
        view.setTitle("提交", for: .normal)
        view.setTitleColor(.label, for: .normal)
        return view
    }()
    
    private let deleteButton:UIButton = {
        let view = UIButton()
        view.setTitle("刪除", for: .normal)
        view.setTitleColor(.red, for: .normal)
        view.isHidden = true
        return view
    }()
    
    // MARK: - Class members
    private var viewModels = [[InputFieldType]()]
    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    var completion: ((_ event:Event) -> Void)?
    
    
    private let bottomOffset:CGFloat = 150
    var newPost = NewPost()
    var isEditMode:Bool = false {
        didSet {
            deleteButton.isHidden = !isEditMode
        }
    }
    
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
        
        tempButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 30, right: 60))
        tempButton.addTarget(self, action: #selector(didTapPost), for: .touchUpInside)
        
        view.addSubview(deleteButton)
        deleteButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 60, bottom: 30, right: 0))
        deleteButton.addTarget(self, action: #selector(didTapDeleteEvent), for: .touchUpInside)
        
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
        
        
        viewModels = [
            [
                .titleField(title: "活動名稱" ,placeholder: "例： 滑雪/食日本野/周末聚下..."),
                .textView(title: "活動簡介:", text: newPost.intro,tag: 0),
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
                self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + self!.bottomOffset, right: 0)
                }
            
        }
        
        hideObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
            self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self!.bottomOffset, right: 0)
        }
    }
}

extension NewEventViewController:UITableViewDelegate,UITableViewDataSource {
    // MARK: - TableView
    fileprivate func configureTableView() {
        
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 65, right: 0))
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.backgroundView = nil
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
        tableView.register(LocationPickerTableViewCell.self, forCellReuseIdentifier: LocationPickerTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 0, left: 0, bottom: bottomOffset, right: 0)
        
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
            cell.backgroundColor = .clear
            return cell
        case .textView(title: let title, text: let text,tag: let tag):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            cell.configure(withTitle: title, placeholder: text,tag: tag)
            cell.isOptional = true
            cell.textView.delegate = self
            cell.backgroundColor = .clear
            return cell
        case .value(title: let title, value: let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: ValueTableViewCell.identifier, for: indexPath) as! ValueTableViewCell
            cell.configure(withTitle: title, value: value)
            cell.backgroundColor = .clear
            return cell
        case .textLabel(text: let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextLabelTableViewCell.identifier, for: indexPath) as! TextLabelTableViewCell
            cell.configure(with: text)
            cell.separator(hide: true)
            cell.backgroundColor = .clear
            return cell
        case .datePicker:
            let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as! DatePickerTableViewCell
            cell.delegate = self
            cell.backgroundColor = .clear
            return cell
        case .headCount:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeadcountTableViewCell.identifier, for: indexPath) as! HeadcountTableViewCell
            cell.isOptional = true
            cell.delegate = self
            cell.backgroundColor = .clear
            return cell
        case .participants:
            let cell = tableView.dequeueReusableCell(withIdentifier: ParticipantsTableViewCell.identifier, for: indexPath) as! ParticipantsTableViewCell
            cell.delegate = self
            cell.backgroundColor = .clear
            return cell
        case .titleField(title: let title,placeholder: let placeholder):
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithImageTableViewCell.identifier, for: indexPath) as! TitleWithImageTableViewCell
            cell.emojiButton.addTarget(self, action: #selector(openEmojiPickerModule), for: .touchUpInside)
            cell.titleField.delegate = self
            cell.titleField.placeholder = placeholder
            cell.titleLabel.text = title
            cell.titleField.text = newPost.title
            emojiButton = cell.emojiButton
            cell.emojiButton.setTitle(newPost.emojiTitle, for: .normal)
            cell.backgroundColor = .clear
            return cell
        case .horizentalPicker(title: let title,selectedObject: let selectedObject, objects: let objects):
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationPickerTableViewCell.identifier, for: indexPath) as! LocationPickerTableViewCell
            cell.configure(title: title, selectedObject: selectedObject, with: objects)
            cell.selectInitialCell()
            cell.isOptional = true
            cell.delegate  = self
            cell.backgroundColor = .clear
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ParticipantsTableViewCell.identifier, for: indexPath) as! ParticipantsTableViewCell
            cell.delegate = self
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    // MARK: - Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            return headerView
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 180 : 30
    }
    
}

extension NewEventViewController {
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
        DatabaseManager.shared.createEvent(with: event) { [weak self] finalEvent in
            self?.navigationController?.popToRootViewController(animated: false)
            self?.completion?(finalEvent)
        }
        
    }
    
    @objc private func didTapDeleteEvent(){
        view.endEditing(true)
        guard let eventRef = newPost.eventRef else {return}
        DatabaseManager.shared.deleteEvent(eventID:newPost.id, eventRef: eventRef) { [weak self] _ in
            // need to modify, should return success instead of an event
            self?.completion?((self?.newPost.toEvent())!)
        }
        
    }
}


extension NewEventViewController:DatePickerTableViewCellDelegate {
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

extension NewEventViewController:HeadcountTableViewCellDelegate {
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
extension NewEventViewController:UITextFieldDelegate {
    // MARK: - Handle TextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {return}
        newPost.title = text
    }
}

extension NewEventViewController:UITextViewDelegate {
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

extension NewEventViewController:ParticipantsTableViewCellDelegate {
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

extension NewEventViewController:EmojiPickerDelegate {
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



// MARK: - Handle Location
extension NewEventViewController:LocationPickerTableViewCellDelegate {
    func didStartEditing(_ cell: LocationPickerTableViewCell, textField: UITextField) {
        textField.resignFirstResponder()
        let vc = LocationSearchViewController()
        vc.delegate = self
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    func didChangeText(_ cell: LocationPickerTableViewCell, textField: UITextField) {
        
    }
    
    func didEndEditing(_ cell: LocationPickerTableViewCell, textField: UITextField) {
        
    }
    
    func didSelectLocation(_ cell: LocationPickerTableViewCell, didSelectObject object: Any) {
        if let object = object as? Location {
            newPost.location = object
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension NewEventViewController: LocationSerchViewControllerDelegate {
    func didChooseLocation(_ VC: LocationSearchViewController, location: Location) {
        newPost.location = location
        configureViewModels()
    }
}

