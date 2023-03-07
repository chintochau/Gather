//
//  Date+extension.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-25.
//

import UIKit

extension Date {
    
    
    /// return String in format yyyyMM, i.e. 202312
    /// Used for User event reference
    func getYearMonth () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        return dateFormatter.string(from: self)
    }
    
    
    /// used for ref: "events/{YearWeek}"
    func getYearWeek() -> String {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: self)
        let year = calendar.component(.year, from: self)
        return String(format: "%04d%02d", year, weekOfYear)
    }
    
    
    func firstDayOfWeekTimestamp() -> Double {
        return firstDayOfWeek().timeIntervalSince1970
    }
    
    func lastDayOfWeekTimestamp() -> Double {
        let calendar = Calendar.current
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return weekStart.adding(days: 7).timeIntervalSince1970
    }
    
    func firstDayOfWeek() -> Date{
        let calendar = Calendar.current
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return weekStart
    }
    
    
    func getMonthInDate () -> Date {
        let calendar = Calendar.current // The calendar to use for the conversion
        let components = calendar.dateComponents([.year, .month], from: self) // Extract the year and month components of the date
        return calendar.date(from: components)! // Create a new date using the year and month components
    }
    
    func startOfNextMonth() -> Date {
        let calendar = Calendar.current
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: self)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: nextMonth))!
        return startOfMonth
    }
    
}
