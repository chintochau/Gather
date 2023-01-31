//
//  DatePickerTableViewCell.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-17.
//

import UIKit

protocol DatePickerTableViewCellDelegate:AnyObject {
    func DatePickerTableViewCellDelegateOnDateChanged(_ cell:DatePickerTableViewCell, startDate:Date,endDate:Date)
    func DatePickerDidTapAddEndTime(_ cell :DatePickerTableViewCell)
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
    
    
    let addEndTimeButton:UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "lessthan.square"), for: .normal)
        view.tintColor = .secondaryLabel
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        selectionStyle = .none
        [startDate,endDate,startDatePicker,endDatePicker,addEndTimeButton].forEach{contentView.addSubview($0) }
        
        startDatePicker.addTarget(self, action: #selector(onDateChanged(_:)), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(onDateChanged(_:)), for: .valueChanged)
        addEndTimeButton.addTarget(self, action: #selector(didTapAddEndTime), for: .touchUpInside)
        
        _ = startDate.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0))
        
        _ = endDate.anchor(top: startDate.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 20, bottom: 7, right: 0))
        
        _ = startDatePicker.anchor(top: startDate.topAnchor, leading: startDate.trailingAnchor, bottom: startDate.bottomAnchor,
                               trailing: addEndTimeButton.leadingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 10))
        _ = addEndTimeButton.anchor(top: startDatePicker.topAnchor, leading: startDatePicker.trailingAnchor, bottom: startDatePicker.bottomAnchor, trailing: contentView.trailingAnchor,padding: .init(top: 0, left: 10, bottom: 0, right: 10))
        
        _ = endDatePicker.anchor(top: endDate.topAnchor, leading: startDate.trailingAnchor, bottom: endDate.bottomAnchor, trailing: startDatePicker.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        endDatePicker.isHidden = true
        endDate.isHidden = true
        startDate.text = "Date: "
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didTapAddEndTime(){
        
        endDatePicker.isHidden = !endDatePicker.isHidden
        endDate.isHidden = !endDate.isHidden
        let isHidden = endDatePicker.isHidden
        
        endDatePicker.date = startDatePicker.date
        UIView.animate(withDuration: 0.3) {[weak self] in
            if isHidden {
                self?.addEndTimeButton.transform = .identity
                self?.startDate.text = "Date: "
            }else {
                self?.addEndTimeButton.transform = .init(rotationAngle: .pi*3/2)
                self?.startDate.text = "Start date: "
                
            }
        }
        
        layoutIfNeeded()
        delegate?.DatePickerDidTapAddEndTime(self)
        
        
    }
    
    @objc private func onDateChanged(_ sender:UIDatePicker ){
        
        endDatePicker.minimumDate = startDatePicker.date
        
        delegate?.DatePickerTableViewCellDelegateOnDateChanged(self, startDate: startDatePicker.date, endDate: endDatePicker.date)
    }
    
    
}
