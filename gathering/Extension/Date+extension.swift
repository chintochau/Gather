//
//  Date+extension.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-25.
//

import UIKit

extension Date {
    func weekOfYearString() -> String {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: self)
        let year = calendar.component(.year, from: self)
        return String(format: "%02d%04d", weekOfYear, year)
    }
    
    
    
}
