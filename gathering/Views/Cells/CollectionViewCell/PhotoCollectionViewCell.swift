//
//  PhotoCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-16.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    
    let imageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "photo.on.rectangle.angled")
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
        view.tintColor = .lightGray.withAlphaComponent(0.5)
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withUrlString url:String){
        imageView.sd_setImage(with: URL(string: url))
    }
    
    func configure(withImage image:UIImage){
        imageView.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
     
    
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Previepgpt: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        NewEventViewController().toPreview()
    }
}
#endif

