//
//  TextFieldCollectionViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-15.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    static let identifier = "TextFieldCollectionViewCell"
    
    
    private let textField:UITextField = {
        let view = UITextField()
        view.backgroundColor = .systemBackground
        view.textColor = .label
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.leftViewMode = .always
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
        textField.placeholder = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with placeholder:String){
        textField.placeholder = placeholder
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Previewnew: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        NewEventViewController().toPreview()
    }
}
#endif

