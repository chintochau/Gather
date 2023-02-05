//
//  PreviewViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-03.
//

import UIKit



class PreviewViewController: UIViewController {
    
    private let contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let eventDetail:UITextView = {
        let view = UITextView()
        view.font = .preferredFont(forTextStyle: .body)
        view.isEditable = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addBlurEffect()
        view.addSubview(contentView)
        contentView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: view.height/5, left: 20, bottom: view.height/5, right: 20))
        contentView.addSubview(eventDetail)
        
        eventDetail.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
    }
    
    private func addGesture(_ view:UIView){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    private func addBlurEffect(){
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        addGesture(blurEffectView)
    }
    
    @objc private func didTapView(){
        dismiss(animated: true)
    }
    
    func configure(with vm:PreviewViewModel) {
        eventDetail.text = vm.eventString
    }
    

}
