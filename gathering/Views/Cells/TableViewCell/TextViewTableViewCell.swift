//
//  TextViewCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-15.
//

import UIKit


class TextViewTableViewCell: UITableViewCell {
    static let identifier = "TextViewCollectionViewCell"
    
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
        textView.fillSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with placeholder:String, type:newEventPageType){
        textView.text = placeholder
        textView.layer.name = type.rawValue
    }
}


extension TextViewTableViewCell:UITextViewDelegate {
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Previewnew11: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        NewEventViewController().toPreview()
    }
}
#endif

