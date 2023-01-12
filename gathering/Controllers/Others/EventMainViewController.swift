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
    private var statusBarFrame:CGRect = {
        let frame = CGRect.zero
        return frame
    }()
    private var statusBarView = UIView()
    
    private let scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        return scroll
    }()
    
    private let contentView:UIView = {
        let view = UIView()
        return view
    }()
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    
    // MARK: - Init
    init(event:Event,image:UIImage) {
        self.event = event
        self.eventImage = image
        imageView.image = eventImage
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
        contentView.addSubview(imageView)
        
        
        configureNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard var statusBarStyle = navigationController?.navigationBar.barStyle else {return}
        statusBarStyle = .`default`
        navigationController?.navigationBar.overrideUserInterfaceStyle = .unspecified
        navigationController?.navigationBar.barStyle = statusBarStyle
        //        let appearance = UINavigationBarAppearance()
        //        let navBar = self.navigationController?.navigationBar
        //        //        appearance.configureWithDefaultBackground()
        //        //        appearance.backgroundColor = .black
        //        //        appearance.shadowColor = .black
        //        navBar?.standardAppearance = appearance
        //        navBar?.scrollEdgeAppearance = appearance
        //        navBar?.compactAppearance = appearance
        
    }
    
    
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
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: view.width, height: 300)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        
        // scrollView.frame = view.safeAreaLayoutGuide.layoutFrame
        contentView.frame = CGRect(x: 0, y: 0, width: view.width, height: 3000)
        scrollView.contentSize = contentView.frame.size
        
        let gradient = CAGradientLayer()
        gradient.frame = imageView.bounds
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.4).cgColor,
            UIColor.white.withAlphaComponent(0).cgColor]
        imageView.layer.insertSublayer(gradient, at: 0)
    }
    
    
    
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

