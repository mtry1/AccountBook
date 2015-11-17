//
//  ABCenterDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/15.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABDataManager.h"
#import "ABChargeModel.h"
#import "ABCategoryModel.h"

@class ABCenterDataManager;

@protocol ABCenterDataManagerDelegate <ABDataManagerMessageCallBackDelegate>

@optional

///分类数据请求请求成功
- (void)centerDataManager:(ABCenterDataManager *)manager successRequestCategoryListData:(NSArray *)data;

///消费列表数据请求成功
- (void)centerDataManager:(ABCenterDataManager *)manager successRequestChargeListData:(NSArray *)data;

@end

@interface ABCenterDataManager : ABDataManager

+ (ABCenterDataManager *)share;

///请求分类列表数据
- (void)requestCategoryListData;

///请求增加分类
- (void)requestCategoryAddModel:(ABCategoryModel *)model;

///请求删除分类
- (void)requestCategoryRemoveCategoryId:(NSString *)categoryId;

///请求修改分类
- (void)requestCategoryUpdateModel:(ABCategoryModel *)model;

///请求消费列表
- (void)requestChargeListDateWithCategoryId:(NSString *)categoryId;

///请求增加消费记录
- (void)requestChargeAddModel:(ABChargeModel *)model;

///请求删除消费记录
- (void)requestChargeRemoveChargeId:(NSString *)chargeId;

///请求修改消费记录
- (void)requestChargeUpdateModel:(ABChargeModel *)model;

///同步iCould数据
- (void)synchronizeCouldData;

@end
