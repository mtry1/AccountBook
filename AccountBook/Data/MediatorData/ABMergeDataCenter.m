//
//  ABMergeDataCenter.m
//  AccountBook
//
//  Created by zhourongqing on 16/7/21.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import "ABMergeDataCenter.h"
#import "ABCategoryCoreDataManager.h"
#import "ABChargeCoreDataManager.h"
#import "ABCloudKit.h"

/*
 合并流程
 第一步：同步本地的数据
 第二步：调整本地废弃数据
 第三步：同步Cloud的数据
 */

@implementation ABMergeDataCenter

+ (instancetype)sharedInstance
{
    static id shareObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [ABMergeDataCenter new];
    });
    return shareObject;
}

///同步iCould数据
- (void)mergeCloudDataFinishedHandler:(void(^)(BOOL success, NSString *errorMessage))finishedHandler
{
    [ABCloudKit requestIsOpenCloudCompletionHandler:^(BOOL success, NSString *errorMessage) {
        if(success)
        {
            __block BOOL mergeFailure = NO;
            __block BOOL existUpdateLocalFailure = NO;
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, dispatch_get_main_queue(), ^{
                dispatch_group_enter(group);
                [self syncLoaclCategoryDataCompletionHandler:^(NSArray<ABCategoryModel *> *mergeData, NSError *error) {
                    if(!error)
                    {
                        for(ABCategoryModel *model in mergeData)
                        {
                            dispatch_group_enter(group);
                            [ABCategoryCoreDataManager updateCategoryModel:model completeHandler:^(BOOL success) {
                                if(!success)
                                {
                                    existUpdateLocalFailure = YES;
                                }
                                dispatch_group_leave(group);
                            }];
                        }
                    }
                    else
                    {
                        mergeFailure = YES;
                    }
                    dispatch_group_leave(group);
                }];
            });
            
            dispatch_group_async(group, dispatch_get_main_queue(), ^{
                dispatch_group_enter(group);
                [self syncLoaclChargeDataCompletionHandler:^(NSArray<ABChargeModel *> *mergeData, NSError *error) {
                    if(!error)
                    {
                        for(ABChargeModel *model in mergeData)
                        {
                            dispatch_group_enter(group);
                            [ABChargeCoreDataManager updateChargeModel:model completeHandler:^(BOOL success) {
                                if(!success)
                                {
                                    existUpdateLocalFailure = YES;
                                }
                                dispatch_group_leave(group);
                            }];
                        }
                    }
                    else
                    {
                        mergeFailure = YES;
                    }
                    dispatch_group_leave(group);
                }];
            });
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                if(existUpdateLocalFailure || mergeFailure)
                {
                    finishedHandler(NO, NSLocalizedString(@"merge_failure", nil));
                }
                else
                {
                    finishedHandler(YES, nil);
                    [self discardData];
                }
            });
        }
        else
        {
            finishedHandler(NO, nil);
            UIAlertController *alertContoller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"login_iCloud", nil) message:NSLocalizedString(@"iCloud_is_open", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alertContoller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:nil]];
            [[ABUtils currentShowViewController] presentViewController:alertContoller animated:YES completion:nil];
        }
    }];
}

#pragma mark - SyncLoaclData

///同步分类数据至本地
- (void)syncLoaclCategoryDataCompletionHandler:(void(^)(NSArray<ABCategoryModel *> *mergeData, NSError *error))completionHandler
{
    [ABCloudKit requestCategoryListDataCompletionHandler:^(NSArray<ABCategoryModel *> *results, NSError *error) {
        if(error)
        {
            completionHandler(nil, error);
        }
        else
        {
            [ABCategoryCoreDataManager selectCategoryListData:YES completeHandler:^(NSArray<ABCategoryModel *> *array) {
                completionHandler([self syncLoaclData:array cloudData:results], nil);
            }];
        }
    }];
}

///同步消费数据至本地
- (void)syncLoaclChargeDataCompletionHandler:(void(^)(NSArray<ABChargeModel *> *mergeData, NSError *error))completionHandler
{
    [ABCloudKit requestChargeListDataWithCompletionHandler:^(NSArray<ABChargeModel *> *results, NSError *error) {
        if(error)
        {
            completionHandler(nil, error);
        }
        else
        {
            [ABChargeCoreDataManager selectAllChargeListDataCompleteHandler:^(NSArray<ABChargeModel *> *array) {
                completionHandler([self syncLoaclData:array cloudData:results], nil);
            }];
        }
    }];
}

- (NSArray *)syncLoaclData:(NSArray<NSObject<ABSyncProtocol> *> *)localData cloudData:(NSArray<NSObject<ABSyncProtocol> *> *)cloudData
{
    NSMutableArray *mergeData = [NSMutableArray array];
    
    NSInteger localDataCount = localData.count, cloudDataCount = cloudData.count;
    NSInteger localCurCnt = 0, cloudCurCnt = 0;
    while (localCurCnt < localDataCount && cloudCurCnt < cloudDataCount)
    {
        NSObject<ABSyncProtocol> *localModel = localData[localCurCnt];
        NSObject<ABSyncProtocol> *cloudModel = cloudData[cloudCurCnt];
        if([localModel.ID isEqualToString:cloudModel.ID])
        {
            if(localModel.modifyTime < cloudModel.modifyTime)
            {
                [mergeData addObject:cloudModel];
            }
            else
            {
                [mergeData addObject:localModel];
            }
            
            localCurCnt ++;
            cloudCurCnt ++;
        }
        else
        {
            if(localModel.createTime < cloudModel.createTime)
            {
                if(localModel.isExistCloud)
                {
                    localModel.isRemoved = YES;
                }
                
                [mergeData addObject:localModel];
                localCurCnt ++;
            }
            else
            {
                [mergeData addObject:cloudModel];
                cloudCurCnt ++;
            }
        }
    }
    while(localCurCnt < localDataCount)
    {
        NSObject<ABSyncProtocol> *localModel = localData[localCurCnt];
        if(localModel.isExistCloud)
        {
            localModel.isRemoved = YES;
        }
        
        [mergeData addObject:localModel];
        localCurCnt ++;
    }
    while(cloudCurCnt < cloudDataCount)
    {
        [mergeData addObject:cloudData[cloudCurCnt]];
        cloudCurCnt ++;
    }

    return mergeData;
}

#pragma mark - DiscardData

- (void)discardData
{
    [ABCategoryCoreDataManager selectCategoryListData:YES completeHandler:^(NSArray<ABCategoryModel *> *categoryArray) {
        [ABChargeCoreDataManager selectAllChargeListDataCompleteHandler:^(NSArray<ABChargeModel *> *chargeArray) {
            
            dispatch_group_t group = dispatch_group_create();
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            for(ABChargeModel *chargeModel in chargeArray)
            {
                BOOL finded = NO;
                for(ABCategoryModel *categoryModel in categoryArray)
                {
                    if([chargeModel.categoryID isEqualToString:categoryModel.categoryID])
                    {
                        finded = YES;
                        break;
                    }
                }
                if(!finded)
                {
                    dispatch_group_async(group, queue, ^{
                        dispatch_group_enter(group);
                        [ABChargeCoreDataManager deleteChargeChargeID:chargeModel.ID flag:NO completeHandler:^(BOOL success) {
                            dispatch_group_leave(group);
                        }];
                    });
                    
                }
            }
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                [self syncCouldData];
            });
        }];
    }];
}

#pragma mark - SyncCouldData

- (void)syncCouldData
{
    __block NSInteger syncErrorCount = 0;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [self syncCouldCategoryDataCompleteHandler:^(NSInteger errorCount) {
            syncErrorCount += errorCount;
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [self syncCouldChargeDataCompleteHandler:^(NSInteger errorCount) {
            syncErrorCount += errorCount;
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if(syncErrorCount)
        {
            [MTProgressHUD showInfoWithMessage:[NSString stringWithFormat:@"有 %ld 条数据上传Cloud失败", syncErrorCount]];
        }
    });
}

- (void)syncCouldCategoryDataCompleteHandler:(void(^)(NSInteger errorCount))completeHandler
{
    [ABCategoryCoreDataManager selectCategoryListData:YES completeHandler:^(NSArray<ABCategoryModel *> *array) {
        __block NSInteger errorCount = 0;
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_async(group, queue, ^{
            for(ABCategoryModel *model in array)
            {
                dispatch_group_enter(group);
                if(model.isRemoved)
                {
                    [ABCloudKit requestDeleteCategoryDataWithCategoryID:model.categoryID completionHandler:^(BOOL isSuccess) {
                        if(isSuccess)
                        {
                            [ABCategoryCoreDataManager deleteCategoryCategoryID:model.categoryID flag:YES completeHandler:nil];
                        }
                        dispatch_group_leave(group);
                    }];
                }
                else
                {
                    model.isExistCloud = YES;
                    [ABCloudKit requestInsertCategoryData:model completionHandler:^(NSError *error) {
                        if(error)
                        {
                            errorCount ++;
                            model.isExistCloud = NO;
                            model.modifyTime = [[NSDate date] timeIntervalSince1970];
                        }
                        [ABCategoryCoreDataManager updateCategoryModel:model completeHandler:nil];
                        dispatch_group_leave(group);
                    }];
                }
            }
        });
        dispatch_group_notify(group, queue, ^{
            completeHandler(errorCount);
        });
    }];
}

- (void)syncCouldChargeDataCompleteHandler:(void(^)(NSInteger errorCount))completeHandler
{
    [ABChargeCoreDataManager selectAllChargeListDataCompleteHandler:^(NSArray<ABChargeModel *> *array) {
        __block NSInteger errorCount = 0;
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_async(group, queue, ^{
            for(ABChargeModel *model in array)
            {
                dispatch_group_enter(group);
                if(model.isRemoved)
                {
                    [ABCloudKit requestDeleteChargeDataWithChargeID:model.chargeID completionHandler:^(BOOL isSuccess) {
                        if(isSuccess)
                        {
                            [ABChargeCoreDataManager deleteChargeChargeID:model.chargeID flag:YES completeHandler:nil];
                        }
                        dispatch_group_leave(group);
                    }];
                }
                else
                {
                    model.isExistCloud = YES;
                    [ABCloudKit requestInsertChargeData:model completionHandler:^(NSError *error) {
                        if(error)
                        {
                            errorCount ++;
                            model.isExistCloud = NO;
                            model.modifyTime = [[NSDate date] timeIntervalSince1970];
                        }
                        [ABChargeCoreDataManager updateChargeModel:model completeHandler:nil];
                        dispatch_group_leave(group);
                    }];
                }
            }
        });
        dispatch_group_notify(group, queue, ^{
            completeHandler(errorCount);
        });
    }];
}

@end