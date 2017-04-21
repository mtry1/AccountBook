//
//  ABCenterDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/15.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABChargeModel.h"
#import "ABCategoryModel.h"

@interface ABCenterDataManager : NSObject

+ (instancetype)sharedInstance;

///请求分类列表数据
- (void)requestCategoryListDataWithCompleteHandler:(void(^)(NSArray<ABCategoryModel *> *array))completeHandler;

///请求增加分类
- (void)requestCategoryAddModel:(ABCategoryModel *)model completeHandler:(void(^)(BOOL success))completeHandler;

///请求删除分类
- (void)requestCategoryRemoveCategoryId:(NSString *)categoryId completeHandler:(void(^)(BOOL success))completeHandler;

///请求修改分类
- (void)requestCategoryUpdateModel:(ABCategoryModel *)model completeHandler:(void(^)(BOOL success))completeHandler;

///请求消费列表
- (void)requestChargeListDateWithCategoryId:(NSString *)categoryId completeHandler:(void(^)(NSArray<ABChargeModel *> *array))completeHandler;

///请求增加消费记录
- (void)requestChargeAddModel:(ABChargeModel *)model completeHandler:(void(^)(BOOL success))completeHandler;

///请求删除消费记录
- (void)requestChargeRemoveChargeId:(NSString *)chargeId completeHandler:(void(^)(BOOL success))completeHandler;

///请求修改消费记录
- (void)requestChargeUpdateModel:(ABChargeModel *)model completeHandler:(void(^)(BOOL success))completeHandler;

@end
