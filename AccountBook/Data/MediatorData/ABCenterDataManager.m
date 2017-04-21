//
//  ABCenterDataManager.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/15.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABCenterDataManager.h"
#import "ABCategoryCoreDataManager.h"
#import "ABChargeCoreDataManager.h"

@implementation ABCenterDataManager

+ (instancetype)sharedInstance
{
    static id shareObject;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareObject = [[[self class] alloc] init];
    });
    return shareObject;
}

#pragma mark - 分类

- (void)requestCategoryListDataWithCompleteHandler:(void(^)(NSArray<ABCategoryModel *> *array))completeHandler
{
    [ABCategoryCoreDataManager selectCategoryListData:NO completeHandler:completeHandler];
}

- (void)requestCategoryAddModel:(ABCategoryModel *)model completeHandler:(void(^)(BOOL success))completeHandler
{
    model.isRemoved = NO;
    model.isExistCloud = NO;
    model.createTime = [[NSDate date] timeIntervalSince1970];
    model.modifyTime = [[NSDate date] timeIntervalSince1970];
    [ABCategoryCoreDataManager insertCategoryModel:model completeHandler:completeHandler];
}

- (void)requestCategoryRemoveCategoryId:(NSString *)categoryId completeHandler:(void(^)(BOOL success))completeHandler
{
    [ABCategoryCoreDataManager deleteCategoryCategoryID:categoryId flag:NO completeHandler:^(BOOL success) {
        [ABChargeCoreDataManager deleteChargeListDataWithCategoryID:categoryId completeHandler:completeHandler];
    }];
}

- (void)requestCategoryUpdateModel:(ABCategoryModel *)model completeHandler:(void(^)(BOOL success))completeHandler
{
    model.modifyTime = [[NSDate date] timeIntervalSince1970];
    [ABCategoryCoreDataManager updateCategoryModel:model completeHandler:completeHandler];
}

#pragma mark - 消费

- (void)requestChargeListDateWithCategoryId:(NSString *)categoryId completeHandler:(void(^)(NSArray<ABChargeModel *> *array))completeHandler
{
    [ABChargeCoreDataManager selectChargeListDateWithCategoryID:categoryId completeHandler:completeHandler];
}

- (void)requestChargeAddModel:(ABChargeModel *)model completeHandler:(void(^)(BOOL success))completeHandler
{
    model.isRemoved = NO;
    model.isExistCloud = NO;
    model.modifyTime = [[NSDate date] timeIntervalSince1970];
    [ABChargeCoreDataManager insertChargeModel:model completeHandler:completeHandler];
}

- (void)requestChargeRemoveChargeId:(NSString *)chargeId completeHandler:(void(^)(BOOL success))completeHandler
{
    [ABChargeCoreDataManager deleteChargeChargeID:chargeId flag:NO completeHandler:completeHandler];
}

- (void)requestChargeUpdateModel:(ABChargeModel *)model completeHandler:(void(^)(BOOL success))completeHandler
{
    model.modifyTime = [[NSDate date] timeIntervalSince1970];
    [ABChargeCoreDataManager updateChargeModel:model completeHandler:completeHandler];
}

@end
