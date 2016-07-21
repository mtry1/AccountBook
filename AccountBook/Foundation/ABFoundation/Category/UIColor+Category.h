//
//  UIColor+Category.h
//  BookReader
//
//  Created by zhourongqing on 15/6/13.
//  Copyright (c) 2015年 zhourongqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

///将指定的整数转为颜色值
+ (UIColor *)colorWithUInt:(NSUInteger)rgb;

///指定整数和颜色的透明度
+ (UIColor *)colorWithUInt:(NSUInteger)rgb alpha:(CGFloat)alpha;

///十六进制字符串转颜色
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
