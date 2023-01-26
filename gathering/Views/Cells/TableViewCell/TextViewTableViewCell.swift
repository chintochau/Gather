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
    
    let textView:UITextView = {
        let view = UITextView()
        view.backgroundColor = .systemBackground
        view.textColor = .label
        view.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.isScrollEnabled = false
        view.font = .preferredFont(forTextStyle: .headline)
        return view
    }()
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textView)
        contentView.addSubview(titleLabel)
        selectionStyle = .none
        
        titleLabel.frame = CGRect(x: contentView.left+30, y: 0, width: contentView.width, height: 30)
        textView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor,padding: .init(top: 20, left: 10, bottom: 0, right: 0))
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
    
    
    func configure(withTitle title: String, placeholder:String) {
        titleLabel.text = title
        textView.text = placeholder
    }
}


extension TextViewTableViewCell:UITextViewDelegate {
}
