//
//  ABDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCallBackUtils.h"

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

@property (nonatomic, readonly) ABCallBackUtils *callBackUtils;

@end
