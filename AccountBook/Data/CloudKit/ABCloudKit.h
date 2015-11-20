//
//  ABCloudKit.h
//  CloudKitDemo
//
//  Created by zhourongqing on 15/11/17.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "ABCategoryModel.h"
#import "ABChargeModel.h"

@interface ABCloudKit : NSObject

///请求判断是否开启iCloud帐号
+ (void)requestIsOpenCloudCompletionHandler:(void(^)(CKAccountStatus accountStatus, NSError *error))completionHandler;

///请求插入分类数据
+ (void)requestInsertCategoryData:(ABCategoryModel *)model completionHandler:(void(^)(NSError *error))completionHandler;

///请求分类数据列表
+ (void)requestCategoryListDataCompletionHandler:(void(^)(NSArray<ABCategoryModel *> *results, NSError *error))completionHandler;

///请求插入消费数据
+ (void)requestInsertChargeData:(ABChargeModel *)model completionHandler:(void(^)(NSError *error))completionHandler;

///请求消费纪录列表
+ (void)requestChargeListDataWithCompletionHandler:(void (^)(NSArray<ABChargeModel *> *results, NSError *error))completionHandler;

///请求删除消费纪录列表
+ (void)requestDeleteChargeListDataWithCategoryID:(NSString *)categoryID completionHandler:(void(^)(BOOL isAllDeleted))completionHandler;

@end
