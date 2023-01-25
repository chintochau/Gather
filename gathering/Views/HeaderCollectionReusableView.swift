//
//  HeaderCollectionReusableView.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-18.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "HeaderCollectionReusableView"
    
    private let imageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image:UIImage) {
        imageView.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.fillSuperview()
    }
    
        
}
