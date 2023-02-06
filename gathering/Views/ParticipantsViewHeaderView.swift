//
//  ParticipantsViewHeaderView.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-29.
//

import UIKit

protocol ParticipantsViewHeaderViewDelegate:AnyObject {
    func didTapEnroll(_ view:ParticipantsViewHeaderView)
}

class ParticipantsViewHeaderView: UIView {
    
    weak var delegate:ParticipantsViewHeaderViewDelegate?
    
    private let participantsLabel:UILabel = {
        let view = UILabel()
        view.text = "Participants: "
        view.sizeToFit()
        return view
    }()
    private let genderLabel:UILabel = {
        let view = UILabel()
        view.text = "M:- F:- O:-"
        return view
    }()
    
    private let priceTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Price: "
        view.font = .systemFont(ofSize: 20,weight: .bold)
        view.sizeToFit()
        return view
    }()
    private let priceValueLabel: UILabel = {
        let view = UILabel()
        view.text = "CA$ -"
        return view
    }()
    
    private let selectButton = GAButton(title: "Enroll")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [
            participantsLabel,
            priceTitleLabel,
            priceValueLabel,
            selectButton,
            genderLabel
        ].forEach({addSubview($0)})
        backgroundColor = .systemBackground.withAlphaComponent(0.4)
        selectButton.addTarget(self, action: #selector(didTapEnroll), for: .touchUpInside)
        
        
        layer.cornerRadius = 20
        layer.borderColor = UIColor.opaqueSeparator.cgColor
        layer.borderWidth = 0.5
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with vm: EventCollectionViewCellViewModel) {
        priceValueLabel.text = "CA$: \(vm.priceString)"
        genderLabel.text = "\(vm.totalPeopleCount)/\(String(vm.totalCapacity))"
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding:CGFloat = 30
        
        
        priceTitleLabel.frame = CGRect(x: padding, y: 20, width: priceTitleLabel.width, height: priceTitleLabel.height)
        
        
        let buttonWidth:CGFloat = (width-40)/2
        selectButton.frame = CGRect(x: width-padding-buttonWidth, y: priceTitleLabel.top, width: buttonWidth, height: 50)
        
        
        priceValueLabel.sizeToFit()
        priceValueLabel.frame = CGRect(x: priceTitleLabel.left, y: selectButton.bottom-priceValueLabel.height, width: priceValueLabel.width, height: priceValueLabel.height)
        
        participantsLabel.frame = CGRect(x: padding, y: priceValueLabel.bottom+20, width: participantsLabel.width, height: participantsLabel.height)
        genderLabel.sizeToFit()
        genderLabel.frame = CGRect(x: participantsLabel.right+5, y: participantsLabel.top, width: width-participantsLabel.width-padding, height: genderLabel.height)
        
    }
    @objc private func didTapEnroll(){
        delegate?.didTapEnroll(self)
    }
    
    
}
