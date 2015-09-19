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

@end
