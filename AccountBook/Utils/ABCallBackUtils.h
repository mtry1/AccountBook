//
//  ABCallBackUtils.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/29.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void (* ABSendMessage0Param)(id,SEL);
extern void (* ABSendMessage1Param)(id,SEL,id);
extern void (* ABSendMessage2Param)(id,SEL,id,id);
extern void (* ABSendMessage3Param)(id,SEL,id,id,id);
extern void (* ABSendMessage4Param)(id,SEL,id,id,id,id);

@interface ABCallBackUtils : NSObject

///添加回调代理
- (void)addDelegate:(id)delegate;

///0个参数回调
- (void)callBackAction:(SEL)action;

///1个参数回调
- (void)callBackAction:(SEL)action object1:(id)object1;

///2个参数回调
- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2;

///3个参数回调
- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2 object3:(id)object3;

///4个参数回调
- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2 object3:(id)object3 object4:(id)object4;

@end
