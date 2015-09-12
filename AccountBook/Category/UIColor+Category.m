//
//  UIColor+Category.m
//  BookReader
//
//  Created by zhourongqing on 15/6/13.
//  Copyright (c) 2015年 zhourongqing. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

///将指定的整数转为颜色值
+ (UIColor *)colorWithUInt:(NSUInteger)rgb
{
    return [self colorWithUInt:rgb alpha:1];
}

///指定整数和颜色的透明度
+ (UIColor *)colorWithUInt:(NSUInteger)rgb alpha:(CGFloat)alpha
{
    float r = (rgb >> 16)       / 255.0;
    float g = (rgb >> 8 & 0xff) / 255.0;
    float b = (rgb & 0xff)      / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

@end
