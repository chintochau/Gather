//
//  ViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-10.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let backGroundImageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "launchScreen")
        view.alpha = 0.7
        return view
    }()
    
    private let logo:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .righteousFont(ofSize: 24)
        label.text = "GaTher"
        return label
    }()
    
    private let slogan:UILabel = {
        let view = UILabel()
        view.font = .robotoRegularFont(ofSize: 14)
        view.text = "we’ve connected."
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backGroundImageView)
        view.addSubview(logo)
        view.addSubview(slogan)
        
        backGroundImageView.fillSuperview()
        
        logo.sizeToFit()
        logo.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 150, left: 0, bottom: 0, right: 0))
        slogan.sizeToFit()
        slogan.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil,
                      padding: .init(top: 180, left: 0, bottom: 0, right: 0))
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slogan.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        appInitialListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.logo.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.logo.alpha = 0
        }completion: { [weak self] _ in
            let vc = TabBarViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    
    fileprivate func appInitialListener() {
        guard let _ = UserDefaults.standard.string(forKey: "username") else {return}
        ChatMessageManager.shared.connectToChatServer(true)
        RelationshipManager.shared.observeFirebaseRelationshipsChangesIntoRealm()
        
//        DummyDataManager.shared.generateDummyEvents()
    }


}

