//
//  ABCenterDataManager.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/15.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABCenterDataManager.h"
#import "MTMultiTargetCallBack.h"
#import "ABCategoryCoreDataManager.h"
#import "ABChargeCoreDataManager.h"

@interface ABCenterDataManager ()

@property (nonatomic, strong) MTMultiTargetCallBack *targetsCallBack;

@end

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

- (MTMultiTargetCallBack *)targetsCallBack
{
    if(!_targetsCallBack)
    {
        _targetsCallBack = [[MTMultiTargetCallBack alloc] init];
    }
    return _targetsCallBack;
}

- (void)addDelegate:(id<ABCenterDataManagerDelegate>)delegate
{
    [self.targetsCallBack addTarget:delegate];
}

#pragma mark - 分类

- (void)requestCategoryListData
{
    [ABCategoryCoreDataManager selectCategoryListData:NO completeHandler:^(NSArray<ABCategoryModel *> *array) {
        [self.targetsCallBack callBackIfExistSelector:@selector(centerDataManager:successRequestCategoryListData:) params:self, array];
    }];
}

- (void)requestCategoryAddModel:(ABCategoryModel *)model
{
    model.isRemoved = NO;
    model.isExistCloud = NO;
    model.createTime = [[NSDate date] timeIntervalSince1970];
    model.modifyTime = [[NSDate date] timeIntervalSince1970];
    
    [ABCategoryCoreDataManager insertCategoryModel:model completeHandler:nil];
}

- (void)requestCategoryRemoveCategoryId:(NSString *)categoryId
{
    [ABCategoryCoreDataManager deleteCategoryCategoryID:categoryId flag:NO completeHandler:nil];
}

- (void)requestCategoryUpdateModel:(ABCategoryModel *)model
{
    model.modifyTime = [[NSDate date] timeIntervalSince1970];
    [ABCategoryCoreDataManager updateCategoryModel:model completeHandler:nil];
}

#pragma mark - 消费

- (void)requestChargeListDateWithCategoryId:(NSString *)categoryId
{
    [ABChargeCoreDataManager selectChargeListDateWithCategoryID:categoryId completeHandler:^(NSArray<ABChargeModel *> *array) {
        [self.targetsCallBack callBackIfExistSelector:@selector(centerDataManager:successRequestChargeListData:) params:self, array];
    }];
}

- (void)requestChargeAddModel:(ABChargeModel *)model
{
    model.isRemoved = NO;
    model.isExistCloud = NO;
    model.modifyTime = [[NSDate date] timeIntervalSince1970];
    
    [ABChargeCoreDataManager insertChargeModel:model completeHandler:nil];
}

- (void)requestChargeRemoveChargeId:(NSString *)chargeId
{
    [ABChargeCoreDataManager deleteChargeChargeID:chargeId flag:NO completeHandler:nil];
}

- (void)requestChargeUpdateModel:(ABChargeModel *)model
{
    model.modifyTime = [[NSDate date] timeIntervalSince1970];
    [ABChargeCoreDataManager updateChargeModel:model completeHandler:nil];
}

@end
