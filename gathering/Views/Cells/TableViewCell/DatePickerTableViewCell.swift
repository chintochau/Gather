//
//  DatePickerTableViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-17.
//

import UIKit

protocol DatePickerTableViewCellDelegate:AnyObject {
    func DatePickerTableViewCellDelegateOnDateChanged(_ cell:DatePickerTableViewCell, startDate:Date,endDate:Date)
}

class DatePickerTableViewCell: UITableViewCell {
    static let identifier = "DatePickerTableViewCell"
    
    weak var delegate:DatePickerTableViewCellDelegate?
    
    private let startDate:UILabel = {
        let view = UILabel()
        view.text = "Start date: "
        
        return view
    }()
    private let endDate:UILabel = {
        let view = UILabel()
        view.text = "End date: "
        return view
    }()
    let startDatePicker:UIDatePicker = {
        let view = UIDatePicker()
        view.minimumDate = Date()
        view.minuteInterval = 15
        return view
    }()
    let endDatePicker:UIDatePicker = {
        let view = UIDatePicker()
        
        view.minimumDate = Date()
        view.minuteInterval = 15
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        [startDate,endDate,startDatePicker,endDatePicker].forEach{contentView.addSubview($0) }
        
        startDatePicker.addTarget(self, action: #selector(onDateChanged(_:)), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(onDateChanged(_:)), for: .valueChanged)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func onDateChanged(_ sender:UIDatePicker ){
        
        endDatePicker.minimumDate = startDatePicker.date
        
        delegate?.DatePickerTableViewCellDelegateOnDateChanged(self, startDate: startDatePicker.date, endDate: endDatePicker.date)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        startDate.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0))
        
        endDate.anchor(top: startDate.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 20, bottom: 7, right: 0))
        
        startDatePicker.anchor(top: startDate.topAnchor, leading: startDate.trailingAnchor, bottom: startDate.bottomAnchor, trailing: contentView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        
        endDatePicker.anchor(top: endDate.topAnchor, leading: startDate.trailingAnchor, bottom: endDate.bottomAnchor, trailing: contentView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        
    }
    
}
