//
//  NewEventViewController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-03-03.
//

import UIKit
import EmojiPicker



class NewPostViewController: UIViewController {
    
    
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
    
    lazy var imagePicker = UIImagePickerController()
    
    // MARK: - Class members
    private var viewModels = [[InputFieldType]()]
    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    var completion: ((_ event:Event?,_ image:UIImage?) -> Void)?
    
    
    private let bottomOffset:CGFloat = 150
    var newPost = NewPost()
    var image:UIImage? {
        didSet {
            if let image = image {
                if let cell = tableView.cellForRow(at: .init(row: 0, section: 0)) as? SingleImageTableViewCell {
                    cell.image = image
                }
            }
        }
    }
    private var isImageEdited:Bool = false
    
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
        imagePicker.delegate = self
        
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
                .imagePicker,
                .titleField(title: "活動名稱" ,placeholder: "例： 滑雪/食日本野/周末聚下..."),
                .textView(title: "活動簡介:", text: newPost.intro,tag: 0),
                .datePicker,
                .horizentalPicker(title: "地點:", selectedObject: newPost.location, objects: Location.filterArray),
                .headCount
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

extension NewPostViewController:UITableViewDelegate,UITableViewDataSource {
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
        tableView.register(SingleImageTableViewCell.self, forCellReuseIdentifier: SingleImageTableViewCell.identifier)
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
            cell.configure(withTitle: title, text: text,tag: tag)
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
            cell.isExpanded = self.isEditMode
            cell.newPost = self.newPost
            return cell
        case .headCount:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeadcountTableViewCell.identifier, for: indexPath) as! HeadcountTableViewCell
            cell.isOptional = true
            cell.delegate = self
            cell.backgroundColor = .clear
            cell.isEditMode = isEditMode
            
            cell.configureWithHeadCount(headcount: newPost.headcount)
            
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
            cell.isOptional = true
            cell.delegate  = self
            cell.backgroundColor = .clear
            if !isEditMode {
                cell.selectInitialCell()
            }
            return cell
        case .imagePicker:
            let cell = tableView.dequeueReusableCell(withIdentifier: SingleImageTableViewCell.identifier, for: indexPath) as! SingleImageTableViewCell
            if let image = self.image {
                cell.image = image
            }
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
        
        if indexPath.row == 0 {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
        
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
        
        
        LoadingIndicator.shared.showLoadingIndicator(on: view)
        
        if isImageEdited {
            publishPostWithImage { [weak self] finalEvent in
                LoadingIndicator.shared.hideLoadingIndicator()
                self?.navigationController?.popToRootViewController(animated: false)
                self?.completion?(finalEvent, self?.image)
            }
            
        }else {
            DatabaseManager.shared.createEvent(with: event) { [weak self] finalEvent in
                LoadingIndicator.shared.hideLoadingIndicator()
                self?.navigationController?.popToRootViewController(animated: false)
                self?.completion?(finalEvent,nil)
            }
        }
    }
    
    @objc private func didTapDeleteEvent(){
        view.endEditing(true)
        guard let eventRef = newPost.eventRef else {return}
        DatabaseManager.shared.deleteEvent(eventID:newPost.id, eventRef: eventRef) { [weak self] _ in
            // need to modify, should return success instead of an event
            self?.completion?(nil, nil)
        }
        
    }
    
    
    
    private func publishPostWithImage(completion: @escaping (Event) -> Void){
        
        var imagesData = [Data?]()
        
        for img in [image] {
            guard let image = img?.sd_resizedImage(with: CGSize(width: 1024, height: 1024), scaleMode: .aspectFill),
                  let data = image.jpegData(compressionQuality: 0.5)
            else {break}
            
            imagesData.append(data)
        }
        
        
        StorageManager.shared.uploadEventImage(id: newPost.id, data: imagesData) {[weak self] urlStrings in
            
            guard let event = self?.newPost.toEvent(urlStrings),
                  let _ = DefaultsManager.shared.getCurrentUser()
            else {return}
            
            
            DatabaseManager.shared.createEvent(with: event) { finalEvent in
                completion(finalEvent)
            }
        }
    }
    
    
}



extension NewPostViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    // MARK: - Pick Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[.editedImage] as? UIImage else {
            dismiss(animated: true)
            return
        }

        self.isImageEdited = true
        self.image = editedImage

        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}

extension NewPostViewController:DatePickerTableViewCellDelegate {
    // MARK: - Handle DatePicker
    func DatePickerTableViewCellDelegateOnDateChanged(_ cell: DatePickerTableViewCell, startDate: Date, endDate: Date) {
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
            newPost.intro = textView.text
            if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TextViewTableViewCell {
                cell.textCount.text = "\(textView.text.count)/1000"
            }
        case 1:
            // addDetail View
            print("add info not yet implemented")
        default:
            print("Invalid Tag")
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.tag == 0 {
            
            if textView.text.count >= 1000 {
                // Assume textView is a UITextView object
                let startIndex = 1000

                // Set the selected range of the text view to start at the specified index and extend to the end of the text
                let endIndex = textView.text.count
                let range = NSRange(location: startIndex, length: endIndex - startIndex)
                textView.selectedRange = range

                // Delete the selected text
                textView.deleteBackward()
            }
            
            return textView.text.count < 1000
        }
        return true
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



// MARK: - Handle Location
extension NewPostViewController:LocationPickerTableViewCellDelegate {
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

extension NewPostViewController: LocationSerchViewControllerDelegate {
    func didChooseLocation(_ VC: LocationSearchViewController, location: Location) {
        newPost.location = location
        configureViewModels()
    }
}

