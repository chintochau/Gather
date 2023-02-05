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
    
    
    let switchButton:UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "lessthan.square"), for: .normal)
        view.tintColor = .secondaryLabel
        return view
    }()
    
    var cellHeightAnchor:NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        selectionStyle = .none
        [startDate,endDate,startDatePicker,endDatePicker,switchButton].forEach{contentView.addSubview($0) }
        
        
        startDatePicker.addTarget(self, action: #selector(onDateChanged(_:)), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(onDateChanged(_:)), for: .valueChanged)
        switchButton.addTarget(self, action: #selector(didTapAddEndTime), for: .touchUpInside)
        
        
        switchButton.anchor(
            top: startDatePicker.topAnchor, leading: startDatePicker.trailingAnchor, bottom: startDatePicker.bottomAnchor, trailing: contentView.trailingAnchor,
            padding: .init(top: 0, left: 10, bottom: 0, right: 10))

        cellHeightAnchor = contentView.heightAnchor.constraint(equalToConstant: 44)
        cellHeightAnchor.priority = .defaultHigh
        cellHeightAnchor.isActive = true
        
        startDate.anchor(
            top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: nil,
            padding: UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 0))

        startDatePicker.anchor(
            top: startDate.topAnchor, leading: nil, bottom: startDate.bottomAnchor,
                               trailing: switchButton.leadingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 10))
        
        
        endDate.anchor(
            top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil,
            padding: .init(top: 0, left: 20, bottom: 5, right: 0))

        endDatePicker.anchor(
            top: endDate.topAnchor, leading: nil, bottom: endDate.bottomAnchor, trailing: startDatePicker.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0))



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
                self?.cellHeightAnchor.constant = 44
                self?.switchButton.transform = .identity
                self?.startDate.text = "Date: "
            }else {
                self?.cellHeightAnchor.constant = 80
                self?.switchButton.transform = .init(rotationAngle: .pi*3/2)
                self?.startDate.text = "Start date: "
                
            }
        }
        delegate?.DatePickerDidTapAddEndTime(self)
        
        
    }
    
    @objc private func onDateChanged(_ sender:UIDatePicker ){
        
        endDatePicker.minimumDate = startDatePicker.date
        
        delegate?.DatePickerTableViewCellDelegateOnDateChanged(self, startDate: startDatePicker.date, endDate: endDatePicker.date)
    }
    
    
}
