//
//  EditProfileViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-25.
//

import UIKit


class EditProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextViewDelegate {
    
    private let viewModels:[ProfileFieldType] = [
        .textField(title: "Name", placeholder: "Enter Name"),
        .textView(title: "Bio", placeholder: ""),
        .value(title: "Personality Type", value: personalityType.agreeableness.rawValue)
    ]
    
    private var headerViewViewModel:ProfileHeaderViewViewModel?
    
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

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let email = UserDefaults.standard.string(forKey: "email") else {return}
        headerViewViewModel = .init(
            profileUrlString: nil,
            username: username,
            email: email)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    // MARK: - Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = headerViewViewModel else {return nil}
        let view = ProfileHeaderView()
        view.configure(with: viewModel)
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
            
            return cell
        case .textView(title: let title, placeholder: let placeholder):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            
            cell.configure(withTitle: title, placeholder: placeholder)
            cell.textView.delegate = self
            return cell
        case .value(title: let title, value: let value):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ValueTableViewCell.identifier, for: indexPath) as! ValueTableViewCell
            
            cell.configure(withTitle: title, placeholder: value)
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
    
    
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Previeweditprofile: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        EditProfileViewController().toPreview()
    }
}
#endif

