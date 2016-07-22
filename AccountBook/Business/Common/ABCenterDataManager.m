//
//  ABCenterDataManager.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/15.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABCenterDataManager.h"
#import "ABCenterCoreDataManager.h"
#import "ABCoreDataHelper.h"
#import "MTMultiTargetCallBack.h"

@interface ABCenterDataManager ()

@property (nonatomic, strong) ABCenterCoreDataManager *centerCoreDataManager;
@property (nonatomic, strong) MTMultiTargetCallBack *targetsCallBack;

@end

@implementation ABCenterDataManager

+ (ABCenterDataManager *)share
{
    static id shareObject;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareObject = [[[self class] alloc] init];
    });
    return shareObject;
}

- (ABCenterCoreDataManager *)centerCoreDataManager
{
    if(!_centerCoreDataManager)
    {
        _centerCoreDataManager = [[ABCenterCoreDataManager alloc] init];
    }
    return _centerCoreDataManager;
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

///请求分类列表数据
- (void)requestCategoryListData
{
    NSArray *array = [self.centerCoreDataManager selectCategoryListData:NO];
    [self.targetsCallBack callBackIfExistSelector:@selector(centerDataManager:successRequestCategoryListData:) params:self, array];
}

///请求增加分类
- (void)requestCategoryAddModel:(ABCategoryModel *)model
{
    model.isRemoved = NO;
    model.isExistCloud = NO;
    model.createTime = [[NSDate date] timeIntervalSince1970];
    model.modifyTime = [[NSDate date] timeIntervalSince1970];
    
    [self.centerCoreDataManager insertCategoryModel:model];
}

///请求删除分类
- (void)requestCategoryRemoveCategoryId:(NSString *)categoryId
{
    [self.centerCoreDataManager deleteCategoryCategoryID:categoryId flag:NO];
}

///请求修改分类
- (void)requestCategoryUpdateModel:(ABCategoryModel *)model
{
    model.modifyTime = [[NSDate date] timeIntervalSince1970];
    [self.centerCoreDataManager updateCategoryModel:model];
}

///请求消费列表
- (void)requestChargeListDateWithCategoryId:(NSString *)categoryId
{
    NSArray *array = [self.centerCoreDataManager selectChargeListDateWithCategoryID:categoryId];
    if(array)
    {
        [self.targetsCallBack callBackIfExistSelector:@selector(centerDataManager:successRequestChargeListData:) params:self, array];
    }
}

///请求增加消费记录
- (void)requestChargeAddModel:(ABChargeModel *)model
{
    model.isRemoved = NO;
    model.isExistCloud = NO;
    model.modifyTime = [[NSDate date] timeIntervalSince1970];
    [self.centerCoreDataManager insertChargeModel:model];
}

///请求删除消费记录
- (void)requestChargeRemoveChargeId:(NSString *)chargeId
{
    [self.centerCoreDataManager deleteChargeChargeID:chargeId flag:NO];
}

///请求修改消费记录
- (void)requestChargeUpdateModel:(ABChargeModel *)model
{
    model.modifyTime = [[NSDate date] timeIntervalSince1970];
    [self.centerCoreDataManager updateChargeModel:model];
}

@end
