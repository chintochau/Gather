//
//  NewCategoryViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-24.
//

import UIKit

class NewCategoryViewController: UIViewController {
    
    private let viewModels = hobbyType.allCases.map{$0.rawValue}
    
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left:10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PhotoLabelCollectionViewCell.self, forCellWithReuseIdentifier: PhotoLabelCollectionViewCell.identifier)
        return view
    }()

    
    private let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "New Event"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AuthManager.shared.isSignedIn {
            configureCategoryView()
        }else {
            configureLoginView()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if AuthManager.shared.isSignedIn {
            layoutCategoryView()
        }else {
            loginView.frame = view.safeAreaLayoutGuide.layoutFrame
        }
    }
    
    private func configureCategoryView(){
        loginView.removeFromSuperview()
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func layoutCategoryView(){
        collectionView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
}

extension NewCategoryViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoLabelCollectionViewCell.identifier, for: indexPath) as! PhotoLabelCollectionViewCell
        
        cell.configure(withImage: UIImage(named: "test")!, text: viewModels[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageSize:CGFloat = (view.width-30)/2
        return CGSize(width: imageSize, height: imageSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = NewEventViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NewCategoryViewController:LoginViewDelegate {
    func didTapLogin(_ view: LoginView, email: String, password: String) {
        AuthManager.shared.logIn(email: email, password: password) { user in
            
            view.indicator.stopAnimating()
            view.loginButton.isHidden = false
            guard let user = user else {
                return
            }
            UserDefaults.standard.set(user.username, forKey: "username")
            UserDefaults.standard.set(user.email, forKey: "email")
            UserDefaults.standard.set(user.profileUrlString, forKey: "profileUrlString")
            self.loginView.removeFromSuperview()
        }
    }
    
    private func configureLoginView() {
        loginView.configureTitle(text: "Login to create new event")
        view.addSubview(loginView)
        loginView.delegate = self
        loginView.registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        present(UINavigationController(rootViewController: vc),animated: true)
    }
    
}
