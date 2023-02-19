//
//  ChatMainViewController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-17.
//

import UIKit
import Hero
import PubNub
import RealmSwift

class ChatMainViewController: UIViewController {
    
    // MARK: - Components
    private let tableView:UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemBackground
        view.register(ChatConversationTableViewCell.self, forCellReuseIdentifier: ChatConversationTableViewCell.identifier)
        return view
    }()
    
    private let signinMessage:UILabel = {
        let view = UILabel()
        view.text = "Login to send Message"
        view.textColor = .label
        return view
    }()
    
    // MARK: - Properties
    
    private let pubnub = ChatMessageManager.shared.pubnub
    private var conversations:[ConversationObject] = []
    let realm = try! Realm()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(signinMessage)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.fillSuperview()
        setupNavBar()
        setUpPanGesture()
        loadConversationsFromRealm()
        ChatMessageManager.shared.ConnectToChatServer()
        
        signinMessage.isHidden = AuthManager.shared.isSignedIn
        print(signinMessage.isHidden)
        signinMessage.sizeToFit()
        signinMessage.center = view.center
        
    }
    
    private func loadConversationsFromRealm() {
        let results = realm.objects(ConversationObject.self)
        conversations = Array(results)
        tableView.reloadData()
    }
    
    private func setupNavBar(){
        navigationItem.title = "Chat"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(didTapBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(didTapNewMessage))
    }
    
    @objc private func didTapNewMessage(){
        
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

extension ChatMainViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = conversations[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatMessageViewController(targetUsername: model.targetname)
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatConversationTableViewCell.identifier, for: indexPath) as! ChatConversationTableViewCell
        cell.conversation = model
        return cell
    }
    
    
}
