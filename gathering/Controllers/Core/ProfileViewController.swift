//
//  ProfileViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    private let logoutButton:UIButton = {
        let view = UIButton()
        view.setTitle("LogOut", for: .normal)
        view.tintColor = .label
        view.backgroundColor = .mainColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let loginView = LoginView()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        if AuthManager.shared.isSignedIn {
            configureProfileView()
        }else {
            configureLoginView()
        }
        
    }
    
    private func configureProfileView() {
        view.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)
    }
    private func layoutProfileView(){
        navigationItem.title = "Profile"
        logoutButton.frame = CGRect(x: 10, y: view.safeAreaInsets.top+10, width: view.width-20, height: 50)
    }
    
    private func configureLoginView() {
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
    
    @objc private func didTapLogOut(){
        AuthManager.shared.signOut { bool in
            self.logoutButton.removeFromSuperview()
            self.configureLoginView()
        }
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        present(UINavigationController(rootViewController: vc),animated: true)
    }
    
}

extension ProfileViewController:LoginViewDelegate {
    
    func didTapLogin(_ view: LoginView, email: String, password: String) {
        
        AuthManager.shared.signIn(email: email, password: password) { user in

            view.indicator.stopAnimating()
            view.SigninButton.isHidden = false
            guard let user = user else {
                return
            }
            UserDefaults.standard.set(user.username, forKey: "username")
            UserDefaults.standard.set(user.email, forKey: "email")
            UserDefaults.standard.set(user.profileUrlString, forKey: "profileUrlString")
            self.loginView.removeFromSuperview()
            self.configureProfileView()
            
        }
        
    }
    
    
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Preview5: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        ProfileViewController().toPreview()
    }
}
#endif

