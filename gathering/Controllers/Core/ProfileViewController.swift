//
//  ProfileViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    private let logoutButton = GAButton(title: "Logout")
    
    private let tableView:UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .systemBackground
        
        view.register(ValueTableViewCell.self, forCellReuseIdentifier: ValueTableViewCell.identifier)
        return view
    }()
    
    private var viewModels = [[InputFieldType]]()
    private var headerViewModel:ProfileHeaderViewViewModel?
    private let loginView = LoginView()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AuthManager.shared.isSignedIn {
            configureViewModels()
            configureProfileView()
        }else {
            configureLoginView()
        }
    }
    
    private func configureViewModels(){
        
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let email = UserDefaults.standard.string(forKey: "email")
        else {return}
        
        headerViewModel = .init(
            profileUrlString: UserDefaults.standard.string(forKey: UserDefaultsType.profileUrlString.rawValue),
            username: username,
            email: email)
        
        viewModels = [
            // events
            [],
            // setting
            [.value(title: "Location", value: "Toronto"),
             .value(title: "Language", value: "English")],
            // support
            [.value(title: "Suggestions", value: "")],
            // about
            [.value(title: "Privacy", value: ""),
             .value(title: "Terms of service", value: ""),
             .value(title: "Cookie Policy", value: "")]
        ]
        
    }
    
    private func configureProfileView() {
        view.addSubview(tableView)
        
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
    }
    private func configureLoginView() {
        navigationItem.title = "Login"
        navigationItem.rightBarButtonItem = nil
        view.addSubview(loginView)
        loginView.delegate = self
        loginView.registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if AuthManager.shared.isSignedIn {
            layoutProfileView()
        }else {
            loginView.frame = view.safeAreaLayoutGuide.layoutFrame
        }
    }
    private func layoutProfileView(){
        navigationItem.title = "Profile"
        self.loginView.removeFromSuperview()
    }
    
    @objc private func didTapEditProfile(){
        let vc = EditProfileViewController()
        vc.completion = { [weak self] in
            self?.configureViewModels()
            self?.tableView.reloadData()
        }
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    @objc private func didTapLogOut(){
        
        AuthManager.shared.signOut { bool in
            UserDefaultsManager.shared.resetUserProfile()
            self.tableView.removeFromSuperview()
            self.configureLoginView()
        }
    }
    
    // MARK: - Tap Register
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.completion = {[weak self] in
            self?.configureViewModels()
            self?.configureProfileView()
        }
        present(UINavigationController(rootViewController: vc),animated: true)
    }
    
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource {
    // MARK: - Section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels.count
    }
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModels[indexPath.section][indexPath.row] {
        case .value(title: let title, value: let value) :
            let cell = tableView.dequeueReusableCell(withIdentifier: ValueTableViewCell.identifier, for: indexPath) as! ValueTableViewCell
            cell.configure(withTitle: title, value: value)
            return cell
        default: return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            guard let headerViewModel = headerViewModel else {return nil}
            let headerView = ProfileHeaderView()
            headerView.configure(with: headerViewModel)
            return headerView
        case 1:
            let view = SectionHeaderView()
            view.configure(with: "Setting")
            return view
        case 2:
            let view = SectionHeaderView()
            view.configure(with: "Support")
            return view
        case 3:
            let view = SectionHeaderView()
            view.configure(with: "About")
            return view
        default: return nil
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 200
        }
        return 40
        
    }
    
    
    // MARK: - Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard section == viewModels.count - 1 else { return nil }
        let footerView = UIView()
        footerView.addSubview(logoutButton)
        logoutButton.anchor(
            top: footerView.topAnchor,
            leading: footerView.leadingAnchor,
            bottom: footerView.bottomAnchor,
            trailing: footerView.trailingAnchor,
            padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        logoutButton.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEditProfile) )
        return footerView
    }
    
    
}

extension ProfileViewController:LoginViewDelegate {
    
    // MARK: - didTapLogin
    
    func didTapLogin(_ view: LoginView, email: String, password: String) {
        
        AuthManager.shared.logIn(email: email, password: password) { [weak self] user in

            view.indicator.stopAnimating()
            view.loginButton.isHidden = false
            
            guard user != nil else {
                print("Failed to retrive user data")
                return
            }
            self?.configureViewModels()
            self?.loginView.removeFromSuperview()
            self?.configureProfileView()
            
        }
        
    }
    
    
}

