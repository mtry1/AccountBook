//
//  ABUtils.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABUtils.h"

@implementation ABUtils

///获取最大字体，根据高度
+ (CGFloat)fontSizeForHeight:(CGFloat)height fontName:(NSString *)fontName;
{
    CGFloat height_1 = [UIFont fontWithName:fontName size:1].lineHeight;
    CGFloat height_2 = [UIFont fontWithName:fontName size:2].lineHeight;
    return (height - height_1) / (height_2 - height_1) + 1;
}

///获取最大字体，根据系统字体的高度
+ (CGFloat)fontSizeForSystemFontHeight:(CGFloat)height
{
    UIFont *systemFont = [UIFont systemFontOfSize:height];
    return [self fontSizeForHeight:height fontName:systemFont.fontName];
}

///每次调用都会产生一个唯一标示
+ (NSString *)uuid
{
    NSString *string = nil;
    
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    
    CFStringRef uuidStr = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    
    string = [(__bridge NSString *)uuidStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    CFRelease(uuidRef);
    CFRelease(uuidStr);
    
    return string;
}

///时间转换
+ (NSString *)dateString:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    NSInteger y = [dateComponent year];
    NSInteger m = [dateComponent month];
    NSInteger d = [dateComponent day];
    
    return [NSString stringWithFormat:@"%04ld-%02ld-%02ld", y, m, d];
}

///本地化时间
+ (NSString *)localDateString:(NSDate *)date
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return [formatter stringFromDate:date];
}

///计算普通字符串高
+ (CGFloat)calculateHeightForWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font
{
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    return [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:NULL].size.width;
}

///计算普通字符串宽
+ (CGFloat)calculateWidthForHeight:(CGFloat)height text:(NSString *)text font:(UIFont *)font
{
    CGSize size = CGSizeMake(CGFLOAT_MAX, height);
    return [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:NULL].size.width;
}

@end
