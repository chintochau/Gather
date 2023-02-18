//
//  ChatViewController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-17.
//


import UIKit

class ChatMessageViewController: UIViewController {
    
    let tableView:UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemBackground
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.keyboardDismissMode = .interactive
        return view
    }()
    
    let textView:UITextView = {
        let view = UITextView()
        view.backgroundColor = .lightGray
        view.font = .preferredFont(forTextStyle: .body)
        view.layer.cornerRadius = 5
        return view
    }()
    let sendButton:UIButton = {
        let view = UIButton()
        view.setTitle("Send", for: .normal)
        view.setTitleColor(.link, for: .normal)
        return view
    }()
    
    let maxNumberOfLines = 5
    
    var textViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        [textView,sendButton,tableView].forEach({view.addSubview($0)})
        setupTableView()
        setupInputComponent()
        scrollToBottom()
        registerKeyboardNotifications()
        scrollToBottom()
    }
    
    func setupNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(didTapGoBack))
    }
    
    @objc private func didTapGoBack (){
        self.dismiss(animated: true)
    }
    
    fileprivate func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate func registerKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupInputComponent(){
        
        sendButton.anchor(top: nil, leading: nil, bottom: textView.bottomAnchor, trailing: view.trailingAnchor,size: CGSize(width: 80, height: 0))
        
        textView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor,padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
        textView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 5)
        textViewBottomConstraint?.isActive = true
        
        textView.delegate = self
        
    }
    
    func scrollToBottom(animated:Bool = true) {
        let lastRow = tableView.numberOfRows(inSection: 0) - 1
        if lastRow >= 0 {
            let lastIndexPath = IndexPath(row: lastRow, section: 0)
            tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: animated)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            textViewBottomConstraint?.constant = -keyboardSize.height + 10
            
            DispatchQueue.main.async {
                self.scrollToBottom()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        textViewBottomConstraint?.constant = 10
    }
}


extension ChatMessageViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Message \(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

extension ChatMessageViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let lineHeight = textView.font?.lineHeight ?? 0
        let numberOfLines = Int(estimatedSize.height / lineHeight)
        if numberOfLines > maxNumberOfLines {
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
            textView.constraints.forEach { [weak self] constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                    if let scrollView = self?.tableView {
                        if(scrollView.contentSize.height - scrollView.frame.height - scrollView.contentOffset.y < 100) {
                            self?.scrollToBottom(animated: false)
                        }
                    }
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}



#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct PreviewChatMes: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        ChatMessageViewController().toPreview()
    }
}
#endif

