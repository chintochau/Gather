//
//  ChatMainViewController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-17.
//

import UIKit
import Hero

class ChatMainViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavBar()
        setUpPanGesture()
    }
    
    private func setupNavBar(){
        navigationItem.title = "Chat"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(didTapBack))
    }
    
    private func setUpPanGesture(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        let progress = translation.x / view.bounds.width

        switch gestureRecognizer.state {
        case .began:
            dismiss(animated: true, completion: nil)
        case .changed:
            
            Hero.shared.update(progress)
            let translation = gestureRecognizer.translation(in: nil)
            let relativeTranslation = translation.x / view.bounds.width
            let newProgress = max(0, min(1, relativeTranslation))
            Hero.shared.apply(modifiers: [.position(CGPoint(x: view.center.x, y: translation.y))], to: view)
            Hero.shared.update(newProgress)
        case .ended, .cancelled:
            if progress + gestureRecognizer.velocity(in: view).x / view.bounds.width > 0.5 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        default:
            break
        }
    }
    
    @objc private func didTapBack (){
        dismiss(animated: true)
    }

}
