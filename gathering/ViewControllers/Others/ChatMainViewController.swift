//
//  ChatMainViewController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-17.
//

import UIKit
import Hero
import PubNub

class ChatMainViewController: UIViewController {
    
    private let listener = SubscriptionListener(queue: .main)
    private let channels = ["awesomeChannel"]
    private let pubnub = ChatMessageManager.shared.pubnub

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavBar()
        setUpPanGesture()
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        ChatMessageManager.shared.fetchChannelGroup(groupid: username) { channels in
            print(channels)
        }
        
        
        
        listener.didReceiveMessage = { message in
            print("[Message]: \(message)")
        }
        
        
        listener.didReceiveStatus = { status in
            switch status {
            case .success(let connection):
                
                if connection == .connected {
                    
                    self.pubnub.publish(channel: self.channels[0], message: "Hello, PubNub Swift!") { result in
                        print(result.map { "Publish Response at \($0.timetokenDate)" })
                    }
                }
                
            case .failure(let error):
                print("Status Error: \(error.localizedDescription)")
            }
        }

        pubnub.add(listener)

        pubnub.subscribe(to: channels, withPresence: true)
        
        
    }
    
    private func setupNavBar(){
        navigationItem.title = "Chat"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(didTapBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(didTapNewMessage))
    }
    
    @objc private func didTapNewMessage(){
        let vc = ChatMessageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapBack (){
        dismiss(animated: true)
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
    

}
