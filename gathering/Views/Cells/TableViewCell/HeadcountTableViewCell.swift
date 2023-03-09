//
//  HeadcountTableViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-01.
//

import UIKit

import UIKit

protocol HeadcountTableViewCellDelegate:AnyObject {
    func HeadcountTableViewCellDidEndEditing(_ cell:HeadcountTableViewCell, headcount:Headcount)
    func HeadcountTableViewCellDidTapExpand(_ cell :HeadcountTableViewCell, headcount:Headcount)
}

class HeadcountTableViewCell: UITableViewCell {
    static let identifier = "HeadcountTableViewCell"
    
    weak var delegate:HeadcountTableViewCellDelegate?
    
    
    private let headcountLabel:UILabel = {
        let view = UILabel()
        view.text = "成團人數: "
        return view
    }()
    
    private let genderLabel:UILabel = {
        let view = UILabel()
        view.text = "(按性別)"
        
        return view
    }()
    
    let optionalLabel:UILabel = {
        let view = UILabel()
        view.textColor = .secondaryLabel
        view.font = .systemFont(ofSize: 14)
        view.text = "(選填)"
        view.isHidden = true
        return view
    }()
    
    private let maleIcon:UIImageView = {
        let view = UIImageView()
        view.image = .personIcon
        view.tintColor = .blueColor
        return view
    }()
    
    private let femaleIcon:UIImageView = {
        let view = UIImageView()
        view.image = .personIcon
        view.tintColor = .redColor
        return view
    }()
    
    
    let expandButton:UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "lessthan.square"), for: .normal)
        view.tintColor = .secondaryLabel
        return view
    }()
    
    private let miniumTextField:UITextField = {
        let view = UITextField()
        view.placeholder = "最少"
        view.tag = 0
        view.keyboardType = .numberPad
        return view
    }()
    private let maxTextField:UITextField = {
        let view = UITextField()
        view.placeholder = "最多"
        view.tag = 1
        view.keyboardType = .numberPad
        return view
    }()
    private let maleMinField:UITextField = {
        let view = UITextField()
        view.placeholder = "最少"
        view.tag = 2
        view.keyboardType = .numberPad
        return view
    }()
    private let maleMaxField:UITextField = {
        let view = UITextField()
        view.placeholder = "最多"
        view.tag = 3
        view.keyboardType = .numberPad
        return view
    }()
    private let femaleMinField:UITextField = {
        let view = UITextField()
        view.placeholder = "最少"
        view.tag = 4
        view.keyboardType = .numberPad
        return view
    }()
    private let femaleMaxField:UITextField = {
        let view = UITextField()
        view.placeholder = "最多"
        view.tag = 5
        view.keyboardType = .numberPad
        return view
    }()
    
    var cellHeightAnchor:NSLayoutConstraint!
    
    var isEditMode:Bool = false
    
    var tempHeadcount = Headcount()
    
    
    var isOptional:Bool = false {
        didSet {
            optionalLabel.isHidden = !isOptional
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        selectionStyle = .none
        [headcountLabel,genderLabel,maleIcon,femaleIcon,expandButton,
         miniumTextField,maxTextField,maleMinField,maleMaxField,femaleMinField,femaleMaxField,optionalLabel
        ].forEach{
            contentView.addSubview($0)
            if let field = $0 as? UITextField {
                field.delegate = self
            }
        }
        
        headcountLabel.sizeToFit()
        headcountLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: nil,
                              padding: .init(top: 10, left: 30, bottom: 0, right: 0),size: CGSize(width: headcountLabel.width, height: 0))
        
        optionalLabel.anchor(top: nil, leading: headcountLabel.trailingAnchor, bottom: headcountLabel.bottomAnchor, trailing: nil)
        
        miniumTextField.anchor(top: headcountLabel.topAnchor, leading: nil, bottom: nil, trailing: nil,
                               padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        maxTextField.anchor(top: headcountLabel.topAnchor, leading: miniumTextField.trailingAnchor, bottom: nil, trailing: expandButton.leadingAnchor,padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        maleIcon.anchor(top: headcountLabel.topAnchor, leading: nil, bottom: nil, trailing: maxTextField.leadingAnchor,
                         padding: .init(top: 0, left: 10, bottom: 0, right: 70))
        femaleIcon.anchor(top: nil, leading: nil, bottom: contentView.bottomAnchor, trailing: femaleMaxField.leadingAnchor,
                           padding: .init(top: 0, left: 0, bottom: 10, right: 70))
        
        genderLabel.anchor(top: nil, leading: headcountLabel.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 10, right: 0))
        
        maleMinField.anchor(top: headcountLabel.topAnchor, leading: nil, bottom: nil, trailing: nil,
                               padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        maleMaxField.anchor(top: headcountLabel.topAnchor, leading: maleMinField.trailingAnchor, bottom: nil, trailing: expandButton.leadingAnchor,padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        
        femaleMinField.anchor(top: femaleIcon.topAnchor, leading: nil, bottom: nil, trailing: nil,
                               padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        femaleMaxField.anchor(top: femaleIcon.topAnchor, leading: femaleMinField.trailingAnchor, bottom: nil, trailing: expandButton.leadingAnchor,padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        expandButton.anchor(top: headcountLabel.topAnchor, leading: nil, bottom: nil, trailing: contentView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 10))
        expandButton.addTarget(self, action: #selector(didTapExpand), for: .touchUpInside)
        
        
        [maleMinField,
         maleMaxField,
         femaleMinField,
         femaleMaxField,
         maleIcon,
         femaleIcon,
         genderLabel
        ].forEach({$0.isHidden = true})
        
        cellHeightAnchor = contentView.heightAnchor.constraint(equalToConstant: 44)
        cellHeightAnchor.priority = .defaultHigh
        cellHeightAnchor.isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configureForNewEvent(){
        headcountLabel.text = "人數上限: "
        [miniumTextField,maleMinField,femaleMinField].forEach({$0.removeFromSuperview()})
    }
    
    @objc private func didTapExpand(){
        
        
        [maleMinField,
         maleMaxField,
         femaleMinField,
         femaleMaxField,
         maleIcon,
         femaleIcon,
         miniumTextField,
         maxTextField,
         genderLabel
        ].forEach({$0.isHidden = !$0.isHidden})
        
        let isHidden = maleMinField.isHidden
        
        UIView.animate(withDuration: 0.3) {[weak self] in
            if isHidden {
                // not gender specific
                
                self?.cellHeightAnchor.constant = 44
                self?.expandButton.transform = .identity
                self?.tempHeadcount.isGenderSpecific = false
                self?.tempHeadcount.fMin = nil
                self?.tempHeadcount.fMax = nil
                self?.tempHeadcount.mMin = nil
                self?.tempHeadcount.mMax = nil
                self?.maleMinField.text = nil
                self?.maleMaxField.text = nil
                self?.femaleMinField.text = nil
                self?.femaleMaxField.text = nil
                
            }else {
                // gender specific
                self?.cellHeightAnchor.constant = 70
                self?.expandButton.transform = .init(rotationAngle: .pi*3/2)
                self?.tempHeadcount.isGenderSpecific = true
                self?.tempHeadcount.max = nil
                self?.tempHeadcount.min = nil
                self?.maxTextField.text = nil
                self?.miniumTextField.text = nil
            }
        }
        layoutIfNeeded()
        delegate?.HeadcountTableViewCellDidTapExpand(self, headcount: tempHeadcount)
    }
}

extension HeadcountTableViewCell:UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text:Int? = Int(textField.text ?? "")
        
        switch textField.tag {
        case 0:
            tempHeadcount.min = text
        case 1:
            tempHeadcount.max = text
        case 2:
            tempHeadcount.mMin = text
        case 3:
            tempHeadcount.mMax = text
        case 4:
            tempHeadcount.fMin = text
        case 5:
            tempHeadcount.fMax = text
        default:
            print("invalud tag")
        }
        
        delegate?.HeadcountTableViewCellDidEndEditing(self, headcount: tempHeadcount)
    }
    
}
