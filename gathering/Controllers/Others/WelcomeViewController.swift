//
//  ViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-10.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let logo:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Impact", size: 40)
        label.text = "Gather"
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mainColor")
        view.addSubview(logo)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logo.sizeToFit()
        logo.center = view.center
        
        UIView.animate(withDuration: 0.4, delay: 0) {
            self.logo.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.logo.alpha = 0
        }completion: { _ in
            let vc = TabBarViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }


}

