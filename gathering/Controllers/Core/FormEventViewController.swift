//
//  FormEventViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-30.
//

import UIKit
import EmojiPicker


enum InputFieldType {
    case textField(title:String, placeholder:String,text:String = "")
    case textView(title:String, text:String,tag:Int = 0)
    case value(title:String, value:String)
    case userField(username:String,name:String?, profileUrl:String?)
    case textLabel(text:String)
    case datePicker
    case headCount
    case participants
    case titleField
}


class FormEventViewController: UIViewController {
    
    private let tableView:UITableView = {
        let view =  UITableView(frame: .zero, style: .grouped)
        return view
    }()
    
    private var viewModels = [[InputFieldType]()]
    
    private var emojiButton:UIButton?
    
    
    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    var completion: ((_ event:Event) -> Void)?
    
    var tempEvent = (
        title:"",
        emojiTitle: UserDefaults.standard.string(forKey: "selectedEmoji") ?? "😃",
        startDate:String.date(from: Date()),
        endDate:String.date(from: Date()),
        location:Location.toronto,
        detail:"",
        headcount:Headcount(isGenderSpecific: false, min: nil, max: nil, mMin: nil, mMax: nil, fMin: nil, fMax: nil),
        participants:["":""],
        participantsArray:[Participant](),
        addDetail:""
    )
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModels()
        view.backgroundColor = .systemBackground
        initialUser()
        configureTableView()
        setupNavBar()
        observeKeyboardChange()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - ViewModels
    
    private func initialUser(){
        guard let user = DefaultsManager.shared.getCurrentUser() else {return}
        tempEvent.participants = [user.username: user.gender!]
        tempEvent.participantsArray = [Participant(with: user)]
    }
    private func configureViewModels(){
        guard let _ = DefaultsManager.shared.getCurrentUser() else {return}
        
        var location = tempEvent.location.name
        if let address = tempEvent.location.address {
            location = location + "\n" + address
        }
        
        viewModels = [
            [
                .titleField,
                .textView(title: "Intro: ", text: tempEvent.detail,tag: 0)
            ],[
                .datePicker,
                .value(title: "Location: ", value: location),
                .textView(title: "Additional details: ", text: tempEvent.detail,tag: 1)
            ],[
                .headCount,
                .participants
            ]
        ]
        
        tableView.reloadData()
    }
    
    // MARK: - Nav Bar
    private func setupNavBar(){
        navigationItem.title = "Form an Event"
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
extension FormEventViewController:UITableViewDelegate,UITableViewDataSource {
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
            cell.delegate = self
            return cell
        case .participants:
            let cell = tableView.dequeueReusableCell(withIdentifier: ParticipantsTableViewCell.identifier, for: indexPath) as! ParticipantsTableViewCell
            cell.delegate = self
            return cell
        case .titleField:
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithImageTableViewCell.identifier, for: indexPath) as! TitleWithImageTableViewCell
            cell.emojiButton.addTarget(self, action: #selector(openEmojiPickerModule), for: .touchUpInside)
            cell.titleField.delegate = self
            emojiButton = cell.emojiButton
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
            return "Current User: "
        case 1:
            return "Event Details: "
        case 2:
            return "Participants"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}

extension FormEventViewController {
    // MARK: - Handle Preview/ Post
    
    private func createEventFromTempEvent() -> Event?{
        
        guard let user = DefaultsManager.shared.getCurrentUser() else {return nil}
        
        return Event(
            id: IdManager.shared.createEventId(),
            emojiTitle: tempEvent.emojiTitle,
            title: tempEvent.title,
            organisers: [user],
            imageUrlString: [],
            price: 0,
            startDateString: tempEvent.startDate ?? "Now",
            endDateString: tempEvent.endDate ?? "Now",
            location: tempEvent.location,
            tag: [],
            introduction: tempEvent.detail, additionalDetail: tempEvent.addDetail,
            refundPolicy: "",
            participants: tempEvent.participants,
            headcount: tempEvent.headcount)
    }
    
    @objc private func didTapPreview(){
        view.endEditing(true)
        
        guard let event = createEventFromTempEvent() else {return}
        
        let vc = PreviewViewController()
        vc.configure(with: PreviewViewModel(event: event))
        
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.action = didTapPost
        
        present(vc, animated: true)
        
        
    }
    
    @objc private func didTapPost(){
        view.endEditing(true)
        
        guard let event = createEventFromTempEvent() else {return}
        
        DatabaseManager.shared.createEvent(with: event,participants:tempEvent.participantsArray) { [weak self] success in
            self?.navigationController?.popToRootViewController(animated: false)
            self?.completion?(event)
            //            self?.tabBarController?.selectedIndex = 0
        }
        
    }
}

extension FormEventViewController: LocationSerchViewControllerDelegate {
    // MARK: - Handle Location
    func didChooseLocation(_ VC: LocationSearchViewController, location: Location) {
        tempEvent.location = location
        configureViewModels()
    }
}

extension FormEventViewController:DatePickerTableViewCellDelegate {
    // MARK: - Handle DatePicker
    func DatePickerTableViewCellDelegateOnDateChanged(_ cell: DatePickerTableViewCell, startDate: Date, endDate: Date) {
        tempEvent.startDate = .date(from: startDate)
        tempEvent.endDate = .date(from: endDate)
    }
    
    func DatePickerDidTapAddEndTime(_ cell: DatePickerTableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}

extension FormEventViewController:HeadcountTableViewCellDelegate {
    // MARK: - handle Headcount
    func HeadcountTableViewCellDidEndEditing(_ cell: HeadcountTableViewCell, headcount: Headcount) {
        tempEvent.headcount = headcount
    }
    
    
    func HeadcountTableViewCellDidTapExpand(_ cell: HeadcountTableViewCell, headcount: Headcount) {
        tempEvent.headcount = headcount
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
extension FormEventViewController:UITextFieldDelegate {
    // MARK: - Handle TextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {return}
        tempEvent.title = text
    }
}

extension FormEventViewController:UITextViewDelegate {
    // MARK: - Handle TextView
    func textViewDidChange(_ textView: UITextView) {
        switch textView.tag {
        case 0:
            // Intro View
            tempEvent.detail = textView.text
        case 1:
            // addDetail View
            tempEvent.addDetail = textView.text
        default:
            print("Invalid Tag")
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension FormEventViewController:ParticipantsTableViewCellDelegate {
    // MARK: - Handle Participants
    func ParticipantsTableViewCellTextViewDidEndEditing(_ cell: ParticipantsTableViewCell, _ textView: UITextView, participants: [String : String], participantsArray: [Participant]) {
        tempEvent.participants = participants
        tempEvent.participantsArray = participantsArray
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func ParticipantsTableViewCellTextViewDidChange(_ cell: ParticipantsTableViewCell, _ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    
}

extension FormEventViewController:EmojiPickerDelegate {
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
        tempEvent.emojiTitle = emoji
        emojiButton?.setTitle(emoji, for: .normal)
    }
    
}
