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
#import "ABCloudKit.h"

@interface ABCenterDataManager ()

@property (nonatomic, readonly) ABCenterCoreDataManager *centerCoreDataManager;

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

///请求分类列表数据
- (void)requestCategoryListData
{
    NSArray *array = [self.centerCoreDataManager selectCategoryListData];
    if(array)
    {
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
    [self.centerCoreDataManager deleteCategoryCategoryID:categoryId];
}

///请求修改分类
- (void)requestCategoryUpdateModel:(ABCategoryModel *)model
{
    [self.centerCoreDataManager updateCategoryModel:model];
}

///请求消费列表
- (void)requestChargeListDateWithCategoryId:(NSString *)categoryId
{
    NSArray *array = [self.centerCoreDataManager selectChargeListDateWithCategoryID:categoryId];
    if(array)
    {
        [self.callBackUtils callBackAction:@selector(centerDataManager:successRequestChargeListData:) object1:self object2:array];
    }
}

///请求增加消费记录
- (void)requestChargeAddModel:(ABChargeModel *)model
{
    [self.centerCoreDataManager insertChargeModel:model];
}

///请求删除消费记录
- (void)requestChargeRemoveChargeId:(NSString *)chargeId
{
    [self.centerCoreDataManager deleteChargeChargeID:chargeId];
}

///请求修改消费记录
- (void)requestChargeUpdateModel:(ABChargeModel *)model
{
    [self.centerCoreDataManager updateChargeModel:model];
}

///同步iCould数据
- (void)synchronizeCouldData
{
    [ABCloudKit requestIsOpenCloudCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        
        if(accountStatus == CKAccountStatusNoAccount)
        {
            ABAlertView *alertView = [[ABAlertView alloc] initWithTitle:@"请登录iCloud帐号"
                                                                message:@"请确保 设置->iCloud->iCloud Drive 开启"
                                                               delegate:nil
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            [ABCloudKit requestCategoryListDataCompletionHandler:^(NSArray<ABCategoryModel *> *results, NSError *error) {
                
                if(error)
                {
                    [SVProgressHUD showErrorWithStatus:@"合并失败，请稍后再试"];
                }
                else
                {
                    NSArray *localCategoryList = [self.centerCoreDataManager selectCategoryListData];
                }
            }];
        }
    }];
}

@end
