//
//  PickerTableViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-25.
//

import UIKit

class ValueTableViewCell: UITableViewCell {
    static let identifier = "ValueTableViewCell"
    
    
    let titleLabel:UILabel = {
        let view = UILabel()
        return view
    }()
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        contentView.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: contentView.left+30, y: 0, width: contentView.width, height: contentView.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(withTitle title: String, placeholder:String) {
        titleLabel.text = title
        detailTextLabel?.text = placeholder
    }
}
