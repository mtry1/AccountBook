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
    NSArray *array = [self.centerCoreDataManager selectCategoryListData:NO];
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
- (void)mergeCouldDataFinishedHandler:(void(^)(void))finishedHandler
{
    [ABCloudKit requestIsOpenCloudCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        
        if(accountStatus == CKAccountStatusNoAccount)
        {
            if(finishedHandler)
            {
                finishedHandler();
            }
            
            ABAlertView *alertView = [[ABAlertView alloc] initWithTitle:@"请登录iCloud帐号"
                                                                message:@"请确保 设置->iCloud->iCloud Drive 开启"
                                                               delegate:nil
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            __block BOOL isCategoryFinished = NO;
            __block BOOL isChargeFinidshed = NO;
            
            [self mergeCategoryDataCompletionHandler:^(NSArray<ABCategoryModel *> *mergeData, NSError *error) {
                
                if(!error)
                {
                    if(mergeData.count == 0)
                    {
                        isCategoryFinished = YES;
                        if(isChargeFinidshed && finishedHandler)
                        {
                            finishedHandler();
                        }
                    }
                    else
                    {
                        __block NSInteger finishedCount = 0;
                        for(ABCategoryModel *model in mergeData)
                        {
                            model.isExistCloud = YES;
                            
                            [self.centerCoreDataManager updateCategoryModel:model];
                            
                            [ABCloudKit requestInsertCategoryData:model completionHandler:^(NSError *error) {
                                
                                finishedCount ++;
                                if(finishedCount == mergeData.count)
                                {
                                    isCategoryFinished = YES;
                                    if(isChargeFinidshed && finishedHandler)
                                    {
                                        finishedHandler();
                                        
                                        [self requestCategoryListData];
                                    }
                                }
                                
                                if(error)
                                {
                                    NSLog(@"%@", error);
                                }
                            }];
                        }
                    }
                }
                else
                {
                    NSLog(@"%@", error);
                }
            }];
            
            [self mergeChargeDataCompletionHandler:^(NSArray<ABChargeModel *> *mergeData, NSError *error) {
                
                if(!error)
                {
                    if(mergeData.count == 0)
                    {
                        isChargeFinidshed = YES;
                        if(isCategoryFinished && finishedHandler)
                        {
                            finishedHandler();
                        }
                    }
                    else
                    {
                        __block NSInteger finishedCount = 0;
                        for(ABChargeModel *model in mergeData)
                        {
                            model.isExistCloud = YES;
                            
                            [self.centerCoreDataManager updateChargeModel:model];
                            
                            [ABCloudKit requestInsertChargeData:model completionHandler:^(NSError *error) {
                                
                                finishedCount ++;
                                if(finishedCount == mergeData.count)
                                {
                                    isChargeFinidshed = YES;
                                    if(isCategoryFinished && finishedHandler)
                                    {
                                        finishedHandler();
                                    }
                                }
                                
                                if(error)
                                {
                                    NSLog(@"%@", error);
                                }
                            }];
                        }
                    }
                }
                else
                {
                    NSLog(@"%@", error);
                }
            }];
        }
    }];
}

///合并分类数据
- (void)mergeCategoryDataCompletionHandler:(void(^)(NSArray<ABCategoryModel *> *mergeData, NSError *error))completionHandler
{
    [ABCloudKit requestCategoryListDataCompletionHandler:^(NSArray<ABCategoryModel *> *results, NSError *error) {
        
        if(error)
        {
            completionHandler(nil, error);
        }
        else
        {
            NSMutableArray *mergeData = [NSMutableArray array];
            NSArray *localData = [self.centerCoreDataManager selectCategoryListData:YES];
            for(ABCategoryModel *cloudModel in results)
            {
                ABCategoryModel *newModel = nil;
                for(ABCategoryModel *localModel in localData)
                {
                    if([cloudModel.categoryID isEqualToString:localModel.categoryID])
                    {
                        if(cloudModel.modifyTime > localModel.modifyTime)
                        {
                            newModel = [cloudModel copy];
                        }
                        else
                        {
                            newModel = [localModel copy];
                        }
                        break;
                    }
                }
                
                if(!newModel)
                {
                    newModel = [cloudModel copy];
                }
                [mergeData addObject:newModel];
            }
            
            for(ABCategoryModel *localModel in localData)
            {
                BOOL isFinded = NO;
                for(ABCategoryModel *mergeModel in mergeData)
                {
                    if([localModel.categoryID isEqualToString:mergeModel.categoryID])
                    {
                        isFinded = YES;
                        break;
                    }
                }
                if(!isFinded)
                {
                    [mergeData addObject:[localModel copy]];
                }
            }
            completionHandler(mergeData, nil);
        }
    }];
}

///合并消费数据
- (void)mergeChargeDataCompletionHandler:(void(^)(NSArray<ABChargeModel *> *mergeData, NSError *error))completionHandler
{
    [ABCloudKit requestChargeListDataWithCompletionHandler:^(NSArray<ABChargeModel *> *results, NSError *error) {
        
        if(error)
        {
            completionHandler(nil, error);
        }
        else
        {
            NSMutableArray *mergeData = [NSMutableArray array];
            NSArray *localData = [self.centerCoreDataManager selectChargeListData];
            for(ABChargeModel *cloudModel in results)
            {
                ABChargeModel *newModel = nil;
                for(ABChargeModel *localModel in localData)
                {
                    if([cloudModel.chargeID isEqualToString:localModel.chargeID])
                    {
                        if(cloudModel.modifyTime > localModel.modifyTime)
                        {
                            newModel = [cloudModel copy];
                        }
                        else
                        {
                            newModel = [localModel copy];
                        }
                        break;
                    }
                }
                
                if(!newModel)
                {
                    newModel = [cloudModel copy];
                }
                [mergeData addObject:newModel];
            }
            
            for(ABChargeModel *localModel in localData)
            {
                BOOL isFinded = NO;
                for(ABChargeModel *mergeModel in mergeData)
                {
                    if([localModel.chargeID isEqualToString:mergeModel.chargeID])
                    {
                        isFinded = YES;
                        break;
                    }
                }
                if(!isFinded)
                {
                    [mergeData addObject:[localModel copy]];
                }
            }
            
            completionHandler(mergeData, nil);
        }
    }];
}

@end
