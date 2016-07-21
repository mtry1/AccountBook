//
//  MTMultiTargetCallBack.h
//  MTMultiTargetCallBackDemo
//
//  Created by zhourongqing on 16/1/27.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTMultiTargetCallBack : NSObject

@property (nonatomic, copy, readonly) NSArray *targets;

- (void)addTarget:(id)target;
- (void)removeTarget:(id)target;
- (void)removeAllTargets;
- (BOOL)containsTarget:(id)target;

//第一个参数为可以为nil，之后的参数支持nil,id,int,unsigned int,long,unsigned long,long long,unsigned long long,double,BOOL
- (void)callBackSelector:(SEL)selector params:(id)param, ...;
- (void)callBackSelector:(SEL)selector;
- (void)callBackIfExistSelector:(SEL)selector params:(id)param, ...;
- (void)callBackIfExistSelector:(SEL)selector;

@end
