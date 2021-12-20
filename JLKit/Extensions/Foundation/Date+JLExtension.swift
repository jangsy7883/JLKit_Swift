//
//  Date+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 2. 26..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

public enum DateComponentType {
    case second, minute, hour, day, weekday, weekdayOrdinal, week, month, year
}

extension Date {
    private static let minuteInSeconds: Double = 60
    private static let hourInSeconds: Double = 3600
    private static let dayInSeconds: Double = 86400
    private static let weekInSeconds: Double = 604800
    private static let yearInSeconds: Double = 31556926
    
    /*
    public enum DateComparisonType {
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
     */
    
    public static func componentFlags() -> Set<Calendar.Component> {
        return [.year, .month, .day, .weekOfYear, .hour, .minute, .second, .weekday, .weekdayOrdinal, .weekOfYear]
    }
    
    public func adjust(_ component: DateComponentType, offset: Int) -> Date {
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
        case .weekdayOrdinal:
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
    
    public func component(_ component: DateComponentType) -> Int? {
        let components = Calendar.current.dateComponents(Date.componentFlags(), from: self)
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
        case .weekdayOrdinal:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }
    
    public func interval(_ component: DateComponentType, componentFlags: Set<Calendar.Component> = Date.componentFlags(), to: Date = Date()) -> Int? {
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
        case .weekdayOrdinal:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }
}

