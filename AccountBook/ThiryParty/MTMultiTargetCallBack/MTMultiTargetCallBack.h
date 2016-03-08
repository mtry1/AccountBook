//
//  MTMultiTargetCallBack.h
//  MTMultiTargetCallBackDemo
//
//  Created by zhourongqing on 16/1/27.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTMultiTargetCallBack : NSObject

///add target callback
- (void)addTarget:(id)target;

///0 parameter callback
- (void)callBackAction:(SEL)action;

///1 parameter callback
- (void)callBackAction:(SEL)action object1:(id)object1;

///2 parameter callback
- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2;

///3 parameter callback
- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2 object3:(id)object3;

///4 parameter callback
- (void)callBackAction:(SEL)action object1:(id)object1 object2:(id)object2 object3:(id)object3 object4:(id)object4;

@end
