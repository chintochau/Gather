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
    
    // MARK: - Class members
    
    private let pubnub = ChatMessageManager.shared.pubnub
    private var conversations:Results<ConversationObject>?
    
    var notificationToken:NotificationToken?
    
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
        setUpPanBackGestureAndBackButton()
        observeConversationsFromRealm()
        
//        ChatMessageManager.shared.ConnectToChatServer()
        
        signinMessage.isHidden = AuthManager.shared.isSignedIn
        signinMessage.sizeToFit()
        signinMessage.center = view.center
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    private func observeConversationsFromRealm() {
        let realm = try! Realm()
        let results = realm.objects(ConversationObject.self)
        notificationToken = results.observe({ [weak self] changes in
            guard let self = self else {return}
            switch changes {
            case .initial(_):
                self.tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                // Subsequent notification blocks will return .update, which is where you can update the UI to reflect changes to the MyObject instance
                print("Collection state has changed:")
                print("Deletions: \(deletions)")
                print("Insertions: \(insertions)")
                print("Modifications: \(modifications)")
                self.tableView.reloadData()
            case .error(let error):
                print("Error observing Realm changes: \(error.localizedDescription)")
            }
        })
        conversations = results
    }
    
    private func setupNavBar(){
        navigationItem.title = "Chat"
        navigationController?.navigationBar.tintColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(didTapBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(didTapNewMessage))
    }
    
    @objc private func didTapNewMessage(){
        print("Tapped new message")
    }
    
    @objc private func didTapBack (){
        dismiss(animated: true)
    }
    
}

extension ChatMainViewController:UITableViewDataSource,UITableViewDelegate{
    
    
    // MARK: - Delegate + DataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let model = conversations?[indexPath.row] else {return}
        
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatMessageViewController(targetUsername: model.targetname)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatConversationTableViewCell.identifier, for: indexPath) as! ChatConversationTableViewCell
        cell.conversation = model
        return cell
    }
    
    
}
