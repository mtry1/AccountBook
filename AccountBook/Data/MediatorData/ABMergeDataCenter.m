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
- (void)mergeCouldDataSuccessedHandler:(void(^)(void))successedHandler
                          errorHandler:(void(^)(CKAccountStatus accountStatus, NSError *error))errorHandler
{
    [ABCloudKit requestIsOpenCloudCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        
        if(accountStatus == CKAccountStatusAvailable)
        {
            _uploadErrorCount = 0;
            
            __block BOOL isCategoryFinished = NO;
            __block BOOL isChargeFinidshed = NO;
            
            [self mergeCategoryDataCompletionHandler:^(NSArray<ABCategoryModel *> *mergeData, NSError *error) {
                
                if(!error)
                {
                    for(ABCategoryModel *model in mergeData)
                    {
                        [ABCategoryCoreDataManager updateCategoryModel:model completeHandler:nil];
                    }
                    
#warning 同步完成需要刷新界面
                    
                    isCategoryFinished = YES;
                    if(isChargeFinidshed)
                    {
                        if(successedHandler)
                        {
                            successedHandler();
                        }
                    }
                    
                    [self requestUploadCategoryData:mergeData];
                }
                else
                {
                    if(errorHandler)
                    {
                        errorHandler(accountStatus, error);
                    }
                }
            }];
            
            [self mergeChargeDataCompletionHandler:^(NSArray<ABChargeModel *> *mergeData, NSError *error) {
                
                if(!error)
                {
                    for(ABChargeModel *model in mergeData)
                    {
                        [ABChargeCoreDataManager updateChargeModel:model completeHandler:nil];
                    }
                    
                    isChargeFinidshed = YES;
                    if(isCategoryFinished && successedHandler)
                    {
                        successedHandler();
                    }
                    
                    [self requestUploadChargeData:mergeData];
                }
                else
                {
                    if(errorHandler)
                    {
                        errorHandler(accountStatus, error);
                    }
                }
            }];
        }
        else
        {
            if(errorHandler)
            {
                errorHandler(accountStatus, error);
            }
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
            [ABCategoryCoreDataManager selectCategoryListData:YES completeHandler:^(NSArray<ABCategoryModel *> *array) {
                NSMutableArray *mergeData = [NSMutableArray array];
                
                NSArray *localData = array;
                NSArray *cloudData = results;
                NSInteger localDataCount = localData.count;
                NSInteger cloudDataCount = cloudData.count;
                NSInteger localCurCnt = 0, cloudCurCnt = 0;
                while (localCurCnt < localDataCount && cloudCurCnt < cloudDataCount)
                {
                    ABCategoryModel *localModel = localData[localCurCnt];
                    ABCategoryModel *cloudModel = cloudData[cloudCurCnt];
                    
                    if([localModel.categoryID isEqualToString:cloudModel.categoryID])
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
                    ABCategoryModel *localModel = localData[localCurCnt];
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
                
                completionHandler(mergeData, nil);
            }];
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
            [ABChargeCoreDataManager selectAllChargeListDataCompleteHandler:^(NSArray<ABChargeModel *> *array) {
                NSMutableArray *mergeData = [NSMutableArray array];
                NSArray *localData = array;
                NSArray *cloudData = results;
                NSInteger localDataCount = localData.count;
                NSInteger cloudDataCount = cloudData.count;
                NSInteger localCurCnt = 0, cloudCurCnt = 0;
                while(localCurCnt < localDataCount && cloudCurCnt < cloudDataCount)
                {
                    ABChargeModel *localModel = localData[localCurCnt];
                    ABChargeModel *cloudModel = cloudData[cloudCurCnt];
                    
                    if([localModel.chargeID isEqualToString:cloudModel.chargeID])
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
                        if(localModel.startTimeInterval < cloudModel.startTimeInterval)
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
                    ABChargeModel *localModel = localData[localCurCnt];
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
                
                completionHandler(mergeData, nil);
            }];
        }
    }];
}

///请求上传分类数据
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

///请求上传消费数据
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

///请求删除多余数据
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
@end
