//
//  TabBarViewController.swift
//  Instagram
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit
import Foundation

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    
    let extraButton = GradientButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        //        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .mainColor
        self.tabBar.unselectedItemTintColor = .gray.withAlphaComponent(0.5)
        self.tabBar.backgroundColor = .streamWhiteSnow
        self.tabBar.barTintColor = .streamWhiteSnow
        
        
        //Define VC
        let home = HomeViewController()
        let explore = ExploreViewController()
        let newevent = NewCategoryViewController()
        let tickets = FavouritedViewController()
        let profile = ProfileViewController()
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: newevent)
        let nav4 = UINavigationController(rootViewController: tickets)
        let nav5 = UINavigationController(rootViewController: profile)
        
        
        // Define tab items
        
        let tabIconSize:CGFloat = 22
        
        
        nav1.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: tabIconSize, weight: .regular)), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: tabIconSize, weight: .regular)), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus.app", withConfiguration: UIImage.SymbolConfiguration(pointSize: tabIconSize, weight: .regular)), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: tabIconSize, weight: .regular)), tag: 4)
        nav5.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: tabIconSize, weight: .regular)), tag: 5)
        
        if #available(iOS 14.0, *) {
            home.navigationItem.backButtonDisplayMode = .minimal
            explore.navigationItem.backButtonDisplayMode = .minimal
            newevent.navigationItem.backButtonDisplayMode = .minimal
            tickets.navigationItem.backButtonDisplayMode = .minimal
            profile.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
        
        //        [nav1,nav2,nav4].forEach({
        //            $0.navigationBar.tintColor = .label
        //            $0.navigationBar.prefersLargeTitles = true
        //        })
        [nav1,nav2,nav3,nav4,nav5].forEach({
            $0.navigationBar.tintColor = .label
            $0.navigationBar.prefersLargeTitles = false
        })
        
        
        
        if #available(iOS 14.0, *) {
            nav3.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
            nav3.navigationItem.backButtonTitle = ""
        }
        
        // set controllers
        self.setViewControllers([
            nav1,
            //            nav2,
            nav3,
            //            nav4,
            nav5
        ], animated: false)
        
        
        appInitialListener()
    }
    
    
    
    public func hideTabBar(){
        tabBar.isHidden = true
        extraButton.isHidden = true
    }
    
    public func showTabBar() {
        tabBar.isHidden = false
        extraButton.isHidden = false
    }
    
    
    
    private func addExtraButton(){
        // Set up the extra button
        let buttonSize:CGFloat = 60
        extraButton.frame = CGRect(x: (view.bounds.width - buttonSize) / 2, y: view.height-tabBar.height-buttonSize, width: buttonSize, height: buttonSize)
        extraButton.layer.cornerRadius = 20
        extraButton.setGradient(colors: [.lightMainColor!,.darkSecondaryColor!], startPoint: .init(x: 0.5, y: 0.1), endPoint: .init(x: 0.5, y: 1),image: UIImage(systemName: "plus"))
        extraButton.addTarget(self, action: #selector(didSelectTap(_:)), for: .touchUpInside)
        view.addSubview(extraButton)
        
    }
    
    @objc private func didSelectTap(_ sender:UIButton) {
        selectedIndex = 1
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        // Check if the second tab (index 1) is clicked
        if let viewController = viewController as? UINavigationController {
            if viewController.topViewController is NewCategoryViewController {
                let vc = CategoryViewController()
                
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                
                vc.firstAction = {[weak self] in
                    self?.openCreateNewPost()
                }
                
                vc.secondAction = {[weak self] in
                    self?.openNewCreateNewEvent()
                }
                
                
                present(vc, animated: true)
                return false
            }
        }
        
        return true
    }
    
    private func openCreateNewPost () {
        
        dismiss(animated: false)
        
        let vc = NewEventViewController()
        vc.completion = { [weak self] post in
            self?.dismiss(animated: false)
            let vc = EventDetailViewController()
            vc.viewModel = .init(event: post)
            vc.configureCloseButton()
            let navVc = UINavigationController(rootViewController: vc)
            navVc.modalPresentationStyle = .fullScreen
            self?.present(navVc, animated: true)
        }
        present(vc, animated: true)
    }
    
    
    private func openCreateNewEvent () {
        dismiss(animated: false)
        let vc = CreateNewEventViewController()
        vc.completion = { [weak self] event, image in
            let vc = EventViewController(viewModel: EventViewModel(with: event, image: image)!)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        present(vc, animated: true)
    }
    
    private func openNewCreateNewEvent(){
        dismiss(animated: false)
        let vc = NewEventViewController()
        
        present(vc, animated: true)
    }
    
    // MARK: - Initial Listener
    
    fileprivate func appInitialListener() {
        guard let _ = UserDefaults.standard.string(forKey: "username") else {return}
        ChatMessageManager.shared.connectToChatServer(true)
        RelationshipManager.shared.observeFirebaseRelationshipsChangesIntoRealm()
        
//        DummyDataManager.shared.generateDummyEvents()
    }
    
}
