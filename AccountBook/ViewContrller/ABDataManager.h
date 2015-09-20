//
//  ABDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABDataManager;

@protocol ABDataManagerTableCallBackDelegate <NSObject>

@optional;

///增加
- (void)dataManager:(ABDataManager *)manager addIndexPath:(NSIndexPath *)indexPath;

///删除
- (void)dataManager:(ABDataManager *)manager removeIndexPath:(NSIndexPath *)indexPath;

///更新
- (void)dataManager:(ABDataManager *)manager updateIndexPath:(NSIndexPath *)indexPath;

///更新整个表格
- (void)dataManagerReloadData:(ABDataManager *)manager;

@end

@interface ABDataManager : NSObject

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
