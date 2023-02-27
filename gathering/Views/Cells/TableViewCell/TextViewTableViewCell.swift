//
//  TextViewCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-15.
//

import UIKit


class TextViewTableViewCell: UITableViewCell {
    static let identifier = "TextViewCollectionViewCell"
    
    
    let titleLabel:UILabel = {
        let view = UILabel()
        return view
    }()
    
    let optionalLabel:UILabel = {
        let view = UILabel()
        view.textColor = .secondaryLabel
        view.font = .systemFont(ofSize: 14)
        view.text = "(選填)"
        return view
    }()
    
    let textView:UITextView = {
        let view = UITextView()
        view.textColor = .label
        view.backgroundColor = .clear
        view.textContainerInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 20)
        view.isScrollEnabled = false
        view.font = .preferredFont(forTextStyle: .body)
        return view
    }()
    
    var isOptional:Bool = false {
        didSet {
            optionalLabel.isHidden = !isOptional
        }
    }
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(optionalLabel)
        selectionStyle = .none
        
        titleLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: nil,
                          padding: .init(top: 5, left: 20, bottom: 0, right: 0))
        textView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor,padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        
        optionalLabel.anchor(top: nil, leading: titleLabel.trailingAnchor, bottom: titleLabel.bottomAnchor, trailing: nil)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = nil
        titleLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with placeholder:String, type:newEventPageType){
        textView.text = placeholder
        textView.layer.name = type.rawValue
        titleLabel.text = "\(type.rawValue):"
        
        
    }
    
    
    func configure(withTitle title: String, placeholder:String?,tag:Int = 0,_ isOptional:Bool = false) {
        titleLabel.text = title
        textView.text = placeholder
        textView.tag = tag
        self.isOptional = isOptional
    }
}


extension TextViewTableViewCell:UITextViewDelegate {
}
