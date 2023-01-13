//
//  EventMainViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit

class EventMainViewController: UIViewController, UIScrollViewDelegate {
    
    private let event:Event
    private let eventImage:UIImage
    
    private var statusBarFrame = CGRect.zero
    private var statusBarView = UIView()
    
    var LikeButton:UIBarButtonItem?
    var shareButton:UIBarButtonItem?
    
    private let scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        return scroll
    }()
    
    let contentView:UIView = {
        let view = UIView()
        return view
    }()
    
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let dateCard = EventInfoCard()
    let locationCard = EventInfoCard()
    let refundPolicyCard = EventInfoCard()
    
    private let bottomBar:UIToolbar = {
        let view = UIToolbar()
        view.backgroundColor = .mainColor
        view.tintColor = .mainColor
        view.barTintColor = .mainColor
        return view
    }()
    
    
    // MARK: - Init
    init(event:Event,image:UIImage) {
        self.event = event
        self.eventImage = image
        imageView.image = eventImage
        titleLabel.text = event.title
        dateCard.configure(with: InfoCardViewModel(title: event.dateString, subTitle: "3pm - 10pm", infoType: .time))
        locationCard.configure(with: InfoCardViewModel(title: event.location, subTitle: "Kwun Tong", infoType: .location))
        refundPolicyCard.configure(with: InfoCardViewModel(title: "Refund Policy", subTitle: "NO refund!!", infoType: .refundPolicy))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [imageView,dateCard,titleLabel,locationCard,refundPolicyCard].forEach{ contentView.addSubview($0)}
        
        view.addSubview(bottomBar)
        
        LikeButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: nil)
        shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems =  [
            shareButton!,LikeButton!
        ]
        
        
        configureNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Layout Subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.fillSuperview()
        
        contentView.anchor(
            top: scrollView.contentLayoutGuide.topAnchor,
            leading: scrollView.contentLayoutGuide.leadingAnchor,
            bottom: scrollView.contentLayoutGuide.bottomAnchor,
            trailing: scrollView.contentLayoutGuide.trailingAnchor)
        
        contentView.anchor(
            top: nil,
            leading: scrollView.frameLayoutGuide.leadingAnchor,
            bottom: nil,
            trailing: scrollView.frameLayoutGuide.trailingAnchor)
        
        imageView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: nil,
            trailing: nil)
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        
        titleLabel.anchor(top: imageView.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor,padding: .init(top: 10, left: 10, bottom: 0, right: 0))
        
        
        dateCard.anchor(top: titleLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: nil)
        
        locationCard.anchor(top: dateCard.bottomAnchor, leading: dateCard.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        refundPolicyCard.anchor(top: locationCard.bottomAnchor, leading: dateCard.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil,padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        
        let gradient = CAGradientLayer()
        gradient.frame = imageView.bounds
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.2).cgColor,
            UIColor.white.withAlphaComponent(0).cgColor]
        imageView.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard var statusBarStyle = navigationController?.navigationBar.barStyle else {return}
        statusBarStyle = .`default`
        navigationController?.navigationBar.overrideUserInterfaceStyle = .unspecified
        navigationController?.navigationBar.barStyle = statusBarStyle
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Navigation Bar
    
    private func configureNavBar(){
        let appearance = UINavigationBarAppearance()
        let navBar = self.navigationController?.navigationBar
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        //        appearance.titleTextAttributes = [.foregroundColor:UIColor.label] //title text color
        
        navBar?.standardAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance
        navBar?.compactAppearance = appearance
        navBar?.tintColor = .label
        navBar?.backgroundColor = .clear
        
        //header view begins under the navigation bar
        scrollView.contentInsetAdjustmentBehavior = .never
        
        
        guard var statusBarStyle = navBar?.barStyle else {return}
        statusBarStyle = .black
        // statusBarStyle is .black or .default
        if case .black = statusBarStyle {
            navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        } else {
            navigationController?.navigationBar.overrideUserInterfaceStyle = .unspecified
        }
        navigationController?.navigationBar.barStyle = .black
        
        statusBarView = UIView(frame: UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
        statusBarView.isOpaque = false
        statusBarView.backgroundColor = .clear
        view.addSubview(statusBarView)
        
        scrollView.delegate = self
        
        
        if #available(iOS 13.0, *) {
            statusBarFrame = UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            // Fallback on earlier versions
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
    }
    
    // MARK: - Scroll Effect
    
    //function that is called everytime the scrollView scrolls
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //Mark the end of the offset
        let targetHeight = imageView.height - (navigationController?.navigationBar.bounds.height ?? 0) - statusBarFrame.height
        
        //calculate how much has been scrolled relative to the targetHeight
        var offset = scrollView.contentOffset.y / targetHeight
        
        //print(String(describing: targetHeight), String(describing: offset))
        
        //cap offset to 1 to conform to UIColor alpha parameter
        if offset > 1 {offset = 1}
        
        //once the scroll reaches halfway to the target, flip the style/color of the status bar
        //this only affect the information in status bar. DOES NOT affect the background color.
        if offset < 0.5 { // scroll up
            guard var statusBarStyle = navigationController?.navigationBar.barStyle else {return}
            statusBarStyle = .black
            navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
            navigationController?.navigationBar.barStyle = statusBarStyle
            navigationItem.title = ""
            
            
        } else { // scroll down
            guard var statusBarStyle = navigationController?.navigationBar.barStyle else {return}
            statusBarStyle = .`default`
            navigationController?.navigationBar.overrideUserInterfaceStyle = .unspecified
            navigationController?.navigationBar.barStyle = statusBarStyle
            navigationItem.title = event.title
        }
        //Define colors that change based off the offset
        let clearToWhite = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
//        let whiteToBlack = UIColor(hue: 1, saturation: 0, brightness: 1-offset, alpha: 1 )
        
        //Dynamically change the color of the barbuttonitems and title (OLD CODE: does not work, need to rework for newer ios version
        //        self.navigationController?.navigationBar.tintColor = whiteToBlack
        //        self.navigationController?.navigationBar.backgroundColor = whiteToBlack
        //        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : whiteToBlack]
        
        //Dynamically change the background color of the navigation bar
        self.navigationController?.navigationBar.backgroundColor = clearToWhite
        
        //Change the status bar to match the navigation bar background color
        statusBarView.backgroundColor = clearToWhite
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Preview: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        EventMainViewController(event: MockData.event, image: UIImage(named: "test")!).toPreview()
    }
}
#endif

