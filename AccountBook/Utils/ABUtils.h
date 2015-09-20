//
//  ABUtils.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

extern void (* ABSendMessage0Param)(id,SEL);
extern void (* ABSendMessage1Param)(id,SEL,id);
extern void (* ABSendMessage2Param)(id,SEL,id,id);
extern void (* ABSendMessage3Param)(id,SEL,id,id,id);
extern void (* ABSendMessage4Param)(id,SEL,id,id,id,id);

@interface ABUtils : NSObject

///获取最大字体，根据高度
+ (CGFloat)fontSizeForHeight:(CGFloat)height fontName:(NSString *)fontName;

///获取最大字体，根据系统字体的高度
+ (CGFloat)fontSizeForSystemFontHeight:(CGFloat)height;

///每次调用都会产生一个唯一标示
+ (NSString *)uuid;

@end
