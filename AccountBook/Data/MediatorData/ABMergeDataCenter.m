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
 第一步：合并Cloud和本地数据至本地
 第二步：上传本地数据至Cloud
 第三步：删除数据
 */

@interface ABMergeDataCenter ()
{
    BOOL _isFinishedUploadCategoryData;
    BOOL _isFinishedUploadChargeData;
    NSInteger _uploadErrorCount;
}

@end

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
            __block BOOL existUpdateLocalFailure = NO;
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, dispatch_get_main_queue(), ^{
                dispatch_group_enter(group);
                [self mergeCategoryDataCompletionHandler:^(NSArray<ABCategoryModel *> *mergeData, NSError *error) {
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
                        dispatch_group_leave(group);
                    }
                    else
                    {
                        finishedHandler(NO, NSLocalizedString(@"merge_failure", nil));
                    }
                }];
            });
            
            dispatch_group_async(group, dispatch_get_main_queue(), ^{
                dispatch_group_enter(group);
                [self mergeChargeDataCompletionHandler:^(NSArray<ABChargeModel *> *mergeData, NSError *error) {
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
                        dispatch_group_leave(group);
                    }
                    else
                    {
                        finishedHandler(NO, NSLocalizedString(@"merge_failure", nil));
                    }
                }];
            });
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                if(existUpdateLocalFailure)
                {
                    finishedHandler(NO, NSLocalizedString(@"merge_failure", nil));
                }
                else
                {
                    finishedHandler(YES, nil);
                    [self requestUploadData];
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

#pragma mark - merge

///合并分类数据至本地
- (void)mergeCategoryDataCompletionHandler:(void(^)(NSArray<ABCategoryModel *> *mergeData, NSError *error))completionHandler
{
    [ABCloudKit requestCategoryListDataCompletionHandler:^(NSArray<ABCategoryModel *> *results, NSError *error) {
        if(error)
        {
            completionHandler(nil, error);
        }
        else
        {
            [ABCategoryCoreDataManager selectCategoryListData:YES completeHandler:^(NSArray<ABCategoryModel *> *array) {
                completionHandler([self mergeLoaclData:array cloudData:results], nil);
            }];
        }
    }];
}

///合并消费数据至本地
- (void)mergeChargeDataCompletionHandler:(void(^)(NSArray<ABChargeModel *> *mergeData, NSError *error))completionHandler
{
    [ABCloudKit requestChargeListDataWithCompletionHandler:^(NSArray<ABChargeModel *> *results, NSError *error) {
        if(error)
        {
            completionHandler(nil, error);
        }
        else
        {
            [ABChargeCoreDataManager selectAllChargeListDataCompleteHandler:^(NSArray<ABChargeModel *> *array) {
                completionHandler([self mergeLoaclData:array cloudData:results], nil);
            }];
        }
    }];
}

- (NSArray *)mergeLoaclData:(NSArray *)localData cloudData:(NSArray *)cloudData
{
    NSMutableArray *mergeData = [NSMutableArray array];
    
    NSInteger localDataCount = localData.count, cloudDataCount = cloudData.count;
    NSInteger localCurCnt = 0, cloudCurCnt = 0;
    while (localCurCnt < localDataCount && cloudCurCnt < cloudDataCount)
    {
        NSObject<ABSyncProtocol> *localModel = localData[localCurCnt];
        NSObject<ABSyncProtocol> *cloudModel = cloudData[cloudCurCnt];
        
        if([self isEqualObj1:localModel obj2:cloudModel])
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

#pragma mark - Upload

- (void)requestUploadData
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        
    });
    dispatch_group_async(group, queue, ^{
        
    });
    dispatch_group_notify(group, queue, ^{
        
    });
    
}

- (void)requestUploadCategoryDataCompleteHandler:(void(^)(BOOL success, NSInteger errorCount))completeHandler
{
    
}

- (void)requestUploadChargeDataCompleteHandler:(void(^)(BOOL success, NSInteger errorCount))completeHandler
{
    
}

- (void)requestUploadCategoryData:(NSArray *)categoryData
{
    if(categoryData.count == 0)
    {
        _isFinishedUploadCategoryData = YES;
        if(_isFinishedUploadChargeData)
        {
            [self requestDeleteDiscardData];
        }
    }
    else
    {
        __block NSInteger uploadCnt = 0;
        _isFinishedUploadCategoryData = NO;
        
        for(ABCategoryModel *model in categoryData)
        {
            if(model.isRemoved)
            {
                uploadCnt ++;
                if(uploadCnt == categoryData.count)
                {
                    _isFinishedUploadCategoryData = YES;
                    if(_isFinishedUploadChargeData)
                    {
                        [self requestDeleteDiscardData];
                        
                        if(_uploadErrorCount)
                        {
                            [MTProgressHUD showInfoWithMessage:[NSString stringWithFormat:@"有 %ld 条数据上传Cloud失败", _uploadErrorCount]];
                        }
                    }
                }
            }
            else
            {
                model.isExistCloud = YES;
                [ABCloudKit requestInsertCategoryData:model completionHandler:^(NSError *error) {
                    
                    if(error)
                    {
                        _uploadErrorCount ++;
                        model.isExistCloud = NO;
                        model.modifyTime = [[NSDate date] timeIntervalSince1970];
                    }
                    else
                    {
                        model.isExistCloud = YES;
                        
                    }
                    
                    [ABCategoryCoreDataManager updateCategoryModel:model completeHandler:nil];
                    
                    uploadCnt ++;
                    if(uploadCnt == categoryData.count)
                    {
                        _isFinishedUploadCategoryData = YES;
                        if(_isFinishedUploadChargeData)
                        {
                            [self requestDeleteDiscardData];
                            
                            if(_uploadErrorCount)
                            {
                                [MTProgressHUD showInfoWithMessage:[NSString stringWithFormat:@"有 %ld 条数据上传Cloud失败", _uploadErrorCount]];
                            }
                        }
                    }
                }];
            }
        }
    }
}

- (void)requestUploadChargeData:(NSArray *)chargeData
{
    if(chargeData.count == 0)
    {
        _isFinishedUploadChargeData = YES;
        if(_isFinishedUploadCategoryData)
        {
            [self requestDeleteDiscardData];
        }
    }
    else
    {
        __block NSInteger uploadCnt = 0;
        _isFinishedUploadChargeData = NO;
        
        for(ABChargeModel *model in chargeData)
        {
            if(model.isRemoved)
            {
                uploadCnt ++;
                
                [ABCloudKit requestDeleteChargeDataWithChargeID:model.chargeID completionHandler:^(BOOL isSuccess) {
                    
                    if(isSuccess)
                    {
                        [ABChargeCoreDataManager deleteChargeChargeID:model.chargeID flag:YES completeHandler:nil];
                    }
                    
                    if(uploadCnt == chargeData.count)
                    {
                        _isFinishedUploadChargeData = YES;
                        if(_isFinishedUploadCategoryData)
                        {
                            [self requestDeleteDiscardData];
                            
                            if(_uploadErrorCount)
                            {
                                [MTProgressHUD showInfoWithMessage:[NSString stringWithFormat:@"有 %ld 条数据上传Cloud失败", _uploadErrorCount]];
                            }
                        }
                    }
                }];
            }
            else
            {
                model.isExistCloud = YES;
                [ABCloudKit requestInsertChargeData:model completionHandler:^(NSError *error) {
                    
                    if(error)
                    {
                        _uploadErrorCount ++;
                        model.isExistCloud = NO;
                        model.modifyTime = [[NSDate date] timeIntervalSince1970];
                    }
                    else
                    {
                        model.isExistCloud = YES;
                    }
                    
                    [ABChargeCoreDataManager updateChargeModel:model completeHandler:nil];
                    
                    uploadCnt ++;
                    if(uploadCnt == chargeData.count)
                    {
                        _isFinishedUploadChargeData = YES;
                        if(_isFinishedUploadCategoryData)
                        {
                            [self requestDeleteDiscardData];
                            
                            if(_uploadErrorCount)
                            {
                                [MTProgressHUD showInfoWithMessage:[NSString stringWithFormat:@"有 %ld 条数据上传Cloud失败", _uploadErrorCount]];
                            }
                        }
                    }
                }];
            }
        }
    }
}

#pragma mark - Delete

- (void)requestDeleteDiscardData
{
    [ABCategoryCoreDataManager selectCategoryListData:YES completeHandler:^(NSArray<ABCategoryModel *> *array) {
        NSArray *mergeCategoryData = array;
        for(ABCategoryModel *model in mergeCategoryData)
        {
            if(model.isRemoved)
            {
                [ABChargeCoreDataManager deleteChargeListDataWithCategoryID:model.categoryID completeHandler:nil];
                [ABCloudKit requestDeleteChargeListDataWithCategoryID:model.categoryID completionHandler:^(BOOL isAllDeleted) {
                    if(isAllDeleted)
                    {
                        [ABCategoryCoreDataManager deleteCategoryCategoryID:model.categoryID flag:YES completeHandler:nil];
                    }
                }];
            }
        }
    }];
}

#pragma mark - Helper

- (BOOL)isEqualObj1:(NSObject<ABSyncProtocol> *)obj1 obj2:(NSObject<ABSyncProtocol> *)obj2
{
    if([obj1 isKindOfClass:[ABCategoryModel class]] && [obj2 isKindOfClass:[ABCategoryModel class]])
    {
        return [[(ABCategoryModel *)obj1 categoryID] isEqualToString:[(ABCategoryModel *)obj2 categoryID]];
    }
    else if([obj1 isKindOfClass:[ABChargeModel class]] && [obj2 isKindOfClass:[ABChargeModel class]])
    {
        return [[(ABChargeModel *)obj1 chargeID] isEqualToString:[(ABChargeModel *)obj2 chargeID]];
    }
    return NO;
}

@end