//
//  HeaderCollectionReusableView.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-18.
//

import UIKit
import UIImageColors

class EventHeaderView: UICollectionReusableView {
    
    static let identifier = "HeaderCollectionReusableView"
    
    var image:UIImage? {
        didSet {
            titleLabel.alpha = 0
            imageView.image = image
            
            image?.getColors(quality: .lowest){[weak self] colorSet in
                UIView.animate(withDuration: 1, delay: 0) {
                    self?.titleLabel.textColor = colorSet?.primary
                    self?.titleLabel.alpha = 1
                }
                
            }
            
        }
    }
    
    var event:Event? {
        didSet {
            titleLabel.text = event?.title
        }
    }
    
    private let titleLabel:UILabel = {
        let view = UILabel()
        view.font = .robotoSemiBoldFont(ofSize: 30)
        view.numberOfLines = 2
        return view
    }()
    
    private let imageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.addSubview(titleLabel)
        imageView.fillSuperview()
        titleLabel.anchor(top: nil, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor,padding: .init(top: 0, left: 30, bottom: 0, right: 30))
        titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
        
}
