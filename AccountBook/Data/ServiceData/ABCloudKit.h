//
//  ABCloudKit.h
//  CloudKitDemo
//
//  Created by zhourongqing on 15/11/17.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCategoryModel.h"
#import "ABChargeModel.h"

@interface ABCloudKit : NSObject

///请求判断是否开启iCloud帐号
+ (void)requestIsOpenCloudCompletionHandler:(void(^)(BOOL success, NSString *errorMessage))completionHandler;

///请求插入分类数据
+ (void)requestInsertCategoryData:(ABCategoryModel *)model completionHandler:(void(^)(NSError *error))completionHandler;

///请求删除分类数据
+ (void)requestDeleteCategoryDataWithCategoryID:(NSString *)categoryID completionHandler:(void(^)(BOOL isSuccess))completionHandler;

///请求分类数据列表
+ (void)requestCategoryListDataCompletionHandler:(void(^)(NSArray<ABCategoryModel *> *results, NSError *error))completionHandler;

///请求插入消费数据
+ (void)requestInsertChargeData:(ABChargeModel *)model completionHandler:(void(^)(NSError *error))completionHandler;

///请求消费纪录列表
+ (void)requestChargeListDataWithCompletionHandler:(void (^)(NSArray<ABChargeModel *> *results, NSError *error))completionHandler;

///删除消费数据
+ (void)requestDeleteChargeDataWithChargeID:(NSString *)chargeID completionHandler:(void(^)(BOOL isSuccess))completionHandler;

@end
