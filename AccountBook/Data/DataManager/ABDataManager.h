//
//  ABDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABDataManager;

///表格类型回调代理
@protocol ABDataManagerTableCallBackDelegate <NSObject>

@optional;

///更新整个表格
- (void)dataManagerReloadData:(ABDataManager *)manager;

///增加
- (void)dataManager:(ABDataManager *)manager addIndexPath:(NSIndexPath *)indexPath;

///删除
- (void)dataManager:(ABDataManager *)manager removeIndexPath:(NSIndexPath *)indexPath;

///更新
- (void)dataManager:(ABDataManager *)manager updateIndexPath:(NSIndexPath *)indexPath;

@end


///消息回调代理
@protocol ABDataManagerMessageCallBackDelegate <NSObject>

@optional

///消息描述
- (void)dataManager:(ABDataManager *)manager infoMessge:(NSString *)message;

///错误提醒
- (void)dataManager:(ABDataManager *)manager errorMessge:(NSString *)message;

///成功提醒
- (void)dataManager:(ABDataManager *)manager successMessge:(NSString *)message;

@end


@interface ABDataManager : NSObject

@property (nonatomic, readonly) MTMultiTargetCallBack *multiTargetCallBack;

@end
