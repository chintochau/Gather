//
//  EventInfoCard.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-12.
//

import UIKit

class EventInfoCard:UIView {
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18,weight: .bold)
        return label
    }()
    
    private let subTitleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14,weight: .light)
        return label
    }()
    
    private let icon:UIImageView = {
        let view = UIImageView()
        view.tintColor = .label
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let button:UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(icon)
        addSubview(button)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize:CGFloat = 20
        icon.frame = CGRect(x: 20, y: 5, width: iconSize, height: iconSize)
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: icon.right+10, y: 2, width: titleLabel.width, height: titleLabel.height)
        subTitleLabel.sizeToFit()
        subTitleLabel.frame = CGRect(x: titleLabel.left, y: titleLabel.bottom+5, width: subTitleLabel.width, height: subTitleLabel.height)
        button.sizeToFit()
        button.frame = CGRect(x: titleLabel.left, y: subTitleLabel.bottom+3, width: button.width, height: button.height)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: InfoCardViewModel) {
        switch viewModel.infoType{
        case .location:
            icon.image = UIImage(systemName: "mappin.and.ellipse")
            button.setTitle("View on maps", for: .normal)
        case .refundPolicy:
            icon.image = UIImage(systemName: "dollarsign")
            button.frame = .zero
        case .time:
            icon.image = UIImage(systemName: "calendar")
            button.setTitle("Add to calendar", for: .normal)
        }
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Preview2: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        EventMainViewController(event: MockData.event, image: UIImage(named: "test")!).toPreview()
    }
}
#endif

