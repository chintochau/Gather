//
//  FormEventViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-30.
//

import UIKit


enum InputFieldType {
    case textField(title:String, placeholder:String)
    case textView(title:String, text:String)
    case value(title:String, value:String)
    case userField(username:String,name:String?, profileUrl:String?)
    case textLabel(text:String)
    case datePicker(Void)
}


class FormEventViewController: UIViewController {
    
    private let tableView:UITableView = {
        let view =  UITableView(frame: .zero, style: .grouped)
        return view
    }()
    
    private var viewModels = [[InputFieldType]()]

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModels()
        view.backgroundColor = .systemBackground
        configureTableView()
        setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - ViewModels
    private func configureViewModels(){
        guard let user = UserDefaultsManager.shared.getCurrentUser() else {return}
        
        viewModels = [
            [
             .userField(username: user.username, name: user.name, profileUrl: user.profileUrlString)],
            [
             .textField(title: "Title", placeholder: "Enter eyecatching title!"),
             .datePicker(()),
             .textView(title: "Detail", text: "")
             
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
    
    @objc private func didTapPost(){
        
    }
    @objc private func didTapPreview(){
        
    }
    

}
extension FormEventViewController:UITableViewDelegate,UITableViewDataSource {
    // MARK: - TableView
    fileprivate func configureTableView() {
        view.addSubview(tableView)
        tableView.contentInset = .zero
        tableView.backgroundColor = .systemBackground
        tableView.frame = view.bounds
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: TextViewTableViewCell.identifier)
        tableView.register(TextLabelTableViewCell.self, forCellReuseIdentifier: TextLabelTableViewCell.identifier)
        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.identifier)
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
            let user = UserDefaultsManager.shared.getCurrentUser()!
            cell.configure(with: user)
            cell.selectionStyle = .none
            cell.separator(hide: true)
            return cell
        case .textField(title: let title, placeholder: let placeholder):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.configure(withTitle: title, placeholder: placeholder)
            return cell
        case .textView(title: let title, text: let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            cell.configure(withTitle: title, placeholder: text)
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
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 70
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Current User: "
        case 1:
            return "Event Details: "
        default:
            return nil
        }
    }
    
}

extension FormEventViewController:DatePickerTableViewCellDelegate {
    // MARK: - Handle DatePicker
    func DatePickerTableViewCellDelegateOnDateChanged(_ cell: DatePickerTableViewCell, startDate: Date, endDate: Date) {
        
    }
    
    func DatePickerDidTapAddEndTime(_ cell: DatePickerTableViewCell) {
    }
    
}

extension FormEventViewController:UITextViewDelegate {
    // MARK: - Handle TextView
    func textViewDidChange(_ textView: UITextView) {
            tableView.beginUpdates()
            tableView.endUpdates()
    }
}
