//
//  NSDate+JLKit.m
//  JLKit
//
//  Created by Jangsy7883 on 2015. 10. 4..
//  Copyright © 2015년 Dalkomm. All rights reserved.
//

#import "NSDate+JLKit.h"

@implementation NSDate (Additions)

+ (NSDateFormatter*)sharedDateFormatter {
    static dispatch_once_t once;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&once, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
    });
    return dateFormatter;
}

- (NSCalendarUnit)componentFlags {
    return (
            NSCalendarUnitYear
            | NSCalendarUnitMonth
            | NSCalendarUnitDay
            | NSCalendarUnitHour
            | NSCalendarUnitMinute
            | NSCalendarUnitSecond
            | NSCalendarUnitNanosecond
            | NSCalendarUnitWeekday
            | NSCalendarUnitWeekdayOrdinal
            | NSCalendarUnitQuarter
            | NSCalendarUnitWeekOfMonth
            | NSCalendarUnitWeekOfYear
            );
}

#pragma mark - Unit

- (NSInteger)valueForComponent:(NSCalendarUnit)unit {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unit fromDate:self];
    components.calendar = [NSCalendar currentCalendar];
    
    return [components valueForComponent:unit];
}

- (NSDate*)dateByAddingCount:(NSInteger)count forComponent:(NSCalendarUnit)unit {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:[self componentFlags] fromDate:self];
    components.calendar = [NSCalendar currentCalendar];
    
    NSInteger value =  [components valueForComponent:unit];
    
    [components setValue:value+count forComponent:unit];
    
    return components.date;
}

#pragma mark - Equal

- (BOOL)isEqualDayToDate:(NSDate *)date {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:[self componentFlags] fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:[self componentFlags] fromDate:date];
    return ((components1.year == components2.year)
            && (components1.month == components2.month)
            && (components1.day == components2.day));
}

#pragma mark - GETTERS

- (NSInteger)year {
    return [self valueForComponent:NSCalendarUnitYear];
}

- (NSInteger)month {
    return [self valueForComponent:NSCalendarUnitMonth];
}

- (NSInteger)day {
    return [self valueForComponent:NSCalendarUnitDay];
}

- (NSInteger)hour {
    return [self valueForComponent:NSCalendarUnitHour];
}

- (NSInteger)minute {
    return [self valueForComponent:NSCalendarUnitMinute];
}

- (NSInteger)second {
    return [self valueForComponent:NSCalendarUnitSecond];
}

- (NSInteger)weekDay {
    return [self valueForComponent:NSCalendarUnitWeekday];
}

@end
