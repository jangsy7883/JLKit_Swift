//
//  Date+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 2. 26..
//  Copyright © 2018년 Goodoc. All rights reserved.
//

import Foundation

enum DateComparisonType {
    // Days
    case isToday
    case isTomorrow
    case isYesterday
    case isSameDay(as:Date)
    // Weeks
    case isThisWeek
    case isNextWeek
    case isLastWeek
    case isSameWeek(as:Date)
    // Months
    case isThisMonth
    case isNextMonth
    case isLastMonth
    case isSameMonth(as:Date)
    // Years
    case isThisYear
    case isNextYear
    case isLastYear
    case isSameYear(as:Date)
    // Relative Time
    case isInTheFuture
    case isInThePast
    case isEarlier(than:Date)
    case isLater(than:Date)
    case isWeekday
    case isWeekend
}

enum DateComponentType {
    case second, minute, hour, day, weekday, nthWeekday, week, month, year
}

extension Date {
    
    // MARK: Intervals In Seconds
    internal static let minuteInSeconds: Double = 60
    internal static let hourInSeconds: Double = 3600
    internal static let dayInSeconds: Double = 86400
    internal static let weekInSeconds: Double = 604800
    internal static let yearInSeconds: Double = 31556926
    
    internal static func componentFlags() -> Set<Calendar.Component> {
        return [Calendar.Component.year,
                Calendar.Component.month,
                Calendar.Component.day,
                Calendar.Component.weekOfYear,
                Calendar.Component.hour,
                Calendar.Component.minute,
                Calendar.Component.second,
                Calendar.Component.weekday,
                Calendar.Component.weekdayOrdinal,
                Calendar.Component.weekOfYear]
    }
    internal static func components(_ fromDate: Date) -> DateComponents {
        return Calendar.current.dateComponents(Date.componentFlags(), from: fromDate)
    }
    
    func compare(_ comparison: DateComparisonType) -> Bool {
        switch comparison {
        case .isToday:
            return compare(.isSameDay(as: Date()))
        case .isTomorrow:
            let comparison = Date().adjust(.day, offset: 1)
            return compare(.isSameDay(as: comparison))
        case .isYesterday:
            let comparison = Date().adjust(.day, offset: -1)
            return compare(.isSameDay(as: comparison))
        case .isSameDay(let date):
            return component(.year) == date.component(.year)
                && component(.month) == date.component(.month)
                && component(.day) == date.component(.day)
        case .isThisWeek:
            return self.compare(.isSameWeek(as: Date()))
        case .isNextWeek:
            let comparison = Date().adjust(.week, offset: 1)
            return compare(.isSameWeek(as: comparison))
        case .isLastWeek:
            let comparison = Date().adjust(.week, offset: -1)
            return compare(.isSameWeek(as: comparison))
        case .isSameWeek(let date):
            if component(.week) != date.component(.week) {
                return false
            }
            // Ensure time interval is under 1 week
            return abs(self.timeIntervalSince(date)) < Date.weekInSeconds
        case .isThisMonth:
            return self.compare(.isSameMonth(as: Date()))
        case .isNextMonth:
            let comparison = Date().adjust(.month, offset: 1)
            return compare(.isSameMonth(as: comparison))
        case .isLastMonth:
            let comparison = Date().adjust(.month, offset: -1)
            return compare(.isSameMonth(as: comparison))
        case .isSameMonth(let date):
            return component(.year) == date.component(.year) && component(.month) == date.component(.month)
        case .isThisYear:
            return self.compare(.isSameYear(as: Date()))
        case .isNextYear:
            let comparison = Date().adjust(.year, offset: 1)
            return compare(.isSameYear(as: comparison))
        case .isLastYear:
            let comparison = Date().adjust(.year, offset: -1)
            return compare(.isSameYear(as: comparison))
        case .isSameYear(let date):
            return component(.year) == date.component(.year)
        case .isInTheFuture:
            return self.compare(.isLater(than: Date()))
        case .isInThePast:
            return self.compare(.isEarlier(than: Date()))
        case .isEarlier(let date):
            return (self as NSDate).earlierDate(date) == self
        case .isLater(let date):
            return (self as NSDate).laterDate(date) == self
        case .isWeekday:
            return !compare(.isWeekend)
        case .isWeekend:
            let range = Calendar.current.maximumRange(of: Calendar.Component.weekday)!
            return (component(.weekday) == range.lowerBound || component(.weekday) == range.upperBound - range.lowerBound)
        }
    }
    
    func adjust(_ component: DateComponentType, offset: Int) -> Date {
        var dateComp = DateComponents()
        switch component {
        case .second:
            dateComp.second = offset
        case .minute:
            dateComp.minute = offset
        case .hour:
            dateComp.hour = offset
        case .day:
            dateComp.day = offset
        case .weekday:
            dateComp.weekday = offset
        case .nthWeekday:
            dateComp.weekdayOrdinal = offset
        case .week:
            dateComp.weekOfYear = offset
        case .month:
            dateComp.month = offset
        case .year:
            dateComp.year = offset
        }
        return Calendar.current.date(byAdding: dateComp, to: self)!
    }
    
    func component(_ component: DateComponentType) -> Int? {
        let components = Date.components(self)
        switch component {
        case .second:
            return components.second
        case .minute:
            return components.minute
        case .hour:
            return components.hour
        case .day:
            return components.day
        case .weekday:
            return components.weekday
        case .nthWeekday:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }
    
    func interval(_ component: DateComponentType, componentFlags: Set<Calendar.Component> = Date.componentFlags(), to: Date = Date()) -> Int? {
        let components = Calendar.current.dateComponents(componentFlags, from: self, to: to)
        switch component {
        case .second:
            return components.second
        case .minute:
            return components.minute
        case .hour:
            return components.hour
        case .day:
            return components.day
        case .weekday:
            return components.weekday
        case .nthWeekday:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }
    
    init?(from value: String, format: String, timeZone: TimeZone? = TimeZone.current) {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        
        if let date =  formatter.date(from: value) {
            self.init(timeIntervalSince1970: date.timeIntervalSince1970)
        } else {
            return nil
        }
    }
    
    func string(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, timeZone: TimeZone? = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = timeZone
        formatter.dateStyle = dateStyle
        formatter.dateStyle = timeStyle
        return formatter.string(from: self)
    }
    
    func string(format: String, timeZone: TimeZone? = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
