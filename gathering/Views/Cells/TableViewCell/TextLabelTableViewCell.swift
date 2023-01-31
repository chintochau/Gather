//
//  TextLabelTableViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-30.
//

import UIKit

class TextLabelTableViewCell: UITableViewCell {

    static let identifier = "TextLabelTableViewCell"
    
    let label:UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20)
        view.textColor = .secondaryLabel
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.frame = .init(x: 20, y: contentView.bottom-label.height, width: label.width, height: label.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with text:String) {
        label.text = text
    }
    

}
