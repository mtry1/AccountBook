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

@interface ABCenterDataManager ()

@property (nonatomic, readonly) ABCenterCoreDataManager *centerCoreDataManager;

@property (nonatomic, strong) NSMutableArray *categoryDataArray;

@property (nonatomic, strong) NSMutableDictionary *chargeDataDict;

@end

@implementation ABCenterDataManager

@synthesize centerCoreDataManager = _centerCoreDataManager;

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

- (NSMutableArray *)categoryDataArray
{
    if(!_categoryDataArray)
    {
        _categoryDataArray = [NSMutableArray array];
    }
    return _categoryDataArray;
}

- (NSMutableDictionary *)chargeDataDict
{
    if(!_chargeDataDict)
    {
        _chargeDataDict = [NSMutableDictionary dictionary];
    }
    return _chargeDataDict;
}

///请求分类列表数据
- (void)requestCategoryListData
{
    NSArray *array = [self.centerCoreDataManager selectCategoryListData];
    if(array)
    {
        [self.categoryDataArray removeAllObjects];
        [self.categoryDataArray addObjectsFromArray:array];
        
        [self.callBackUtils callBackAction:@selector(centerDataManager:successRequestCategoryListData:) object1:self object2:array];
    }
}

///请求增加分类
- (void)requestCategoryAddModel:(ABCategoryModel *)model
{
    [self.centerCoreDataManager insertCategoryModel:model];
}

///请求删除分类
- (void)requestCategoryRemoveCategoryId:(NSString *)categoryId
{
    [self.centerCoreDataManager deleteCategoryCategoryId:categoryId];
}

///请求修改分类
- (void)requestCategoryUpdateModel:(ABCategoryModel *)model
{
    
}

///请求消费列表
- (void)requestChargeListDateWithCategoryId:(NSString *)categoryId
{
    
}

///请求增加消费记录
- (void)requestChargeAddModel:(ABChargeModel *)model
{
    
}

///请求删除消费记录
- (void)requestChargeRemoveChargeId:(NSString *)chargeId
{
    
}

///请求修改消费记录
- (void)requestChargeUpdateModel:(ABChargeModel *)model
{
    
}

///同步本地数据
- (void)synchronizeLocalData
{
    [[ABCoreDataHelper share] saveContext];
}

///同步iCould数据
- (void)synchronizeCouldData
{
    
}

@end
