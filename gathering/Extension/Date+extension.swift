//
//  Date+extension.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-25.
//

import UIKit
import SwiftDate

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
    
    
    
    static func todayAtMidnight() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 00:00:00"
        let dateString = dateFormatter.string(from: Date())
        let todayAtMidnight = dateFormatter.date(from: dateString)
        
        return todayAtMidnight!
    }
    
    static func tomorrowAtMidnight() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 00:00:00"
        let currentDate = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        let dateString = dateFormatter.string(from: tomorrow)
        let tomorrowAtMidnight = dateFormatter.date(from: dateString)
        return tomorrowAtMidnight!
    }
    
    static func startOfThisWeek() -> Date {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: calendar.startOfDay(for: Date())))!
        return startOfWeek
    }
    
    static func startOfNextWeek() -> Date {
        let calendar = Calendar.current
        let startOfNextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfThisWeek())!
        return startOfNextWeek
    }
    
    static func startOfTwoWeeksAfter() -> Date {
        let calendar = Calendar.current
        let startOfTwoWeeksAfter = calendar.date(byAdding: .weekOfYear, value: 2, to: startOfThisWeek())!
        return startOfTwoWeeksAfter
    }
    
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func subtract(days: Int) -> Date {
        let secondsInDay: TimeInterval = Double(days) * 86400
        return self.addingTimeInterval(-secondsInDay)
    }
    
    
    
    
}


extension String {
    
    static func date(from date: Date) -> String? {
        let formatter = DateFormatter.formatter
        let string = formatter.string(from: date)
        return string
    }
    
    static func localeDate(from date:String,_ identifier: LocaleIdentifier) -> (date:String,dayOfWeek:String,time:String,relative:String) {
        let formatter = DateFormatter.formatter
        guard let date = formatter.date(from: date) else {return ("nil","nil","nil","nil")}
        
        let fullDateString = localeDate(from: date, identifier)
        
        return (fullDateString.date,fullDateString.dayOfWeek,fullDateString.time,fullDateString.relative)
    }
    
    static func localeDate(from date:Date,_ identifier: LocaleIdentifier) -> (date:String,dayOfWeek:String,time:String,relative:String) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: identifier.rawValue)
        
        
        
        let dateInDeviceLocalTime = DateInRegion(date,region: .current)
        
        // Date
        let dateString = dateInDeviceLocalTime.toFormat("M月d日")
        
        // Day of the week
        let dayString = dateInDeviceLocalTime.weekdayName(.short)
        
        // Time
        let timeString = dateInDeviceLocalTime.toFormat("h:mma")
        
        
        // Relative
        let relativeString = dateInDeviceLocalTime.toRelative(locale:Locales.chineseTraditional)
        
        
        return (dateString,dayString,timeString,relativeString)
    }
    
    
}
