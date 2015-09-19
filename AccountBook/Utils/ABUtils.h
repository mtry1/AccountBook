//
//  ABUtils.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ABUtils : NSObject

///获取最大字体，根据高度
+ (CGFloat)fontSizeForHeight:(CGFloat)height fontName:(NSString *)fontName;

///获取最大字体，根据系统字体的高度
+ (CGFloat)fontSizeForSystemFontHeight:(CGFloat)height;

@end
