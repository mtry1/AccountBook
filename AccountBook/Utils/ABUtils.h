//
//  ABUtils.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//


@interface ABUtils : NSObject

///获取最大字体，根据高度
+ (CGFloat)fontSizeForHeight:(CGFloat)height fontName:(NSString *)fontName;

///获取最大字体，根据系统字体的高度
+ (CGFloat)fontSizeForSystemFontHeight:(CGFloat)height;

///每次调用都会产生一个唯一标示
+ (NSString *)uuid;

///时间转换
+ (NSString *)dateString:(NSTimeInterval)timeInterval;

///本地化时间
+ (NSString *)localDateString:(NSDate *)date;

///计算普通字符串高
+ (CGFloat)calculateHeightForWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font;

///计算普通字符串宽
+ (CGFloat)calculateWidthForHeight:(CGFloat)height text:(NSString *)text font:(UIFont *)font;

@end
