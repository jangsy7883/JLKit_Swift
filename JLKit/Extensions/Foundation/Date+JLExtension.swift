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
    
    public static func componentFlags() -> Set<Calendar.Component> {
        return [.year, .month, .day, .weekOfYear, .hour, .minute, .second, .weekday, .weekdayOrdinal, .weekOfYear]
    }
    
    public func component(_ component: DateComponentType) -> Int? {
        let components = Calendar.current.dateComponents(Date.componentFlags(), from: self)
        switch component {
        case .second:           return components.second
        case .minute:           return components.minute
        case .hour:             return components.hour
        case .day:              return components.day
        case .weekday:          return components.weekday
        case .weekdayOrdinal:   return components.weekdayOrdinal
        case .week:             return components.weekOfYear
        case .month:            return components.month
        case .year:             return components.year
        }
    }
     
    public func interval(_ component: DateComponentType, componentFlags: Set<Calendar.Component> = Date.componentFlags(), to: Date = Date()) -> Int? {
        let components = Calendar.current.dateComponents(componentFlags, from: self, to: to)
        switch component {
        case .second:           return components.second
        case .minute:           return components.minute
        case .hour:             return components.hour
        case .day:              return components.day
        case .weekday:          return components.weekday
        case .weekdayOrdinal:   return components.weekdayOrdinal
        case .week:             return components.weekOfYear
        case .month:            return components.month
        case .year:             return components.year
        }
    }
     
}
