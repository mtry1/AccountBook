//
//  NSDate+Category.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/13.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

///与现在相差多少年
- (NSDate *)dateSinceDateWithDifferYear:(NSInteger)differYear
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute |kCFCalendarUnitSecond fromDate:self];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:%02ld", dateComponents.year + differYear, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute, dateComponents.second];
    NSDate *differDate = [format dateFromString:string];
    
    return differDate;
}

@end
