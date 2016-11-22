//
//  ABCloudKit.m
//  CloudKitDemo
//
//  Created by zhourongqing on 15/11/17.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABCloudKit.h"
#import <CloudKit/CloudKit.h>

@implementation ABCloudKit

+ (void)requestIsOpenCloudCompletionHandler:(void(^)(BOOL success, NSString *errorMessage))completionHandler
{
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if(completionHandler)
        {
            NSString *errorMessge;
            BOOL success;
            if(accountStatus == CKAccountStatusAvailable)
            {
                success = YES;
            }
            else
            {
                success = NO;
                errorMessge = @"设置->iCloud->iCloud Drive";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(success, errorMessge);
            });
        }
    }];
}

#pragma mark - 分类

+ (void)requestInsertCategoryData:(ABCategoryModel *)model completionHandler:(void(^)(NSError *error))completionHandler
{
    [self requestCategoryDataWithCategoryID:model.categoryID completionHandler:^(CKRecord *record, NSError *error) {
        
        CKRecord *newRecord;
        if(record)
        {
            newRecord = record;
        }
        else
        {
            CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:model.categoryID];
            newRecord = [[CKRecord alloc] initWithRecordType:@"CategoryRecord" recordID:recordID];
        }
        
        newRecord[@"categoryID"] = model.categoryID;
        newRecord[@"title"] = model.name;
        newRecord[@"colorHexString"] = model.colorHexString;
        newRecord[@"isExistCloud"] = @(model.isExistCloud);
        newRecord[@"isRemoved"] = @(model.isRemoved);
        newRecord[@"modifyTime"] = @(model.modifyTime);
        newRecord[@"createTime"] = @(model.createTime);
        
        CKDatabase *privateContainer = [[CKContainer defaultContainer] privateCloudDatabase];
        [privateContainer saveRecord:newRecord completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(completionHandler) completionHandler(error);
            });
        }];
    }];
}

+ (void)requestCategoryDataWithCategoryID:(NSString *)categoryID completionHandler:(void(^)(CKRecord *record, NSError *error))completionHandler
{
    CKDatabase *privateDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryID = %@", categoryID];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"CategoryRecord" predicate:predicate];
    [privateDatabase performQuery:query
                     inZoneWithID:nil
                completionHandler:^(NSArray *results, NSError *error) {
                    if(completionHandler)
                    {
                        if([results isKindOfClass:[NSArray class]])
                        {
                            completionHandler([results firstObject], nil);
                        }
                        else
                        {
                            completionHandler(nil, error);
                        }
                    }
                }];
}

+ (void)requestDeleteCategoryDataWithCategoryID:(NSString *)categoryID completionHandler:(void(^)(BOOL isSuccess))completionHandler
{
    CKDatabase *privateDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:categoryID];
    [privateDatabase deleteRecordWithID:recordID completionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        if(error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(NO);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(YES);
            });
        }
    }];
}

+ (void)requestCategoryListDataCompletionHandler:(void(^)(NSArray<ABCategoryModel *> *results, NSError *error))completionHandler
{
    CKDatabase *privateDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"CategoryRecord" predicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
    query.sortDescriptors = @[sortDescriptor];
    
    [privateDatabase performQuery:query
                     inZoneWithID:nil
                completionHandler:^(NSArray *results, NSError *error) {
                    
                    if(completionHandler)
                    {
                        if(error)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completionHandler(nil, error);
                            });
                        }
                        else
                        {
                            NSMutableArray *listItem = [NSMutableArray array];
                            for(CKRecord *record in results)
                            {
                                ABCategoryModel *model = [[ABCategoryModel alloc] init];
                                model.categoryID = record[@"categoryID"];
                                model.name = record[@"title"];
                                model.colorHexString = record[@"colorHexString"];
                                model.isExistCloud = [record[@"isExistCloud"] boolValue];
                                model.isRemoved = [record[@"isRemoved"] boolValue];
                                model.modifyTime = [record[@"modifyTime"] doubleValue];
                                model.createTime = [record[@"createTime"] doubleValue];
                                [listItem addObject:model];
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completionHandler(listItem, nil);
                            });
                        }
                    }
                }];
}

#pragma mark - 消费

+ (void)requestInsertChargeData:(ABChargeModel *)model completionHandler:(void(^)(NSError *error))completionHandler
{
    [self requestChargeDataWithChargeID:model.chargeID completionHandler:^(CKRecord *record, NSError *error) {
        
        CKRecord *newRecord;
        if(record)
        {
            newRecord = record;
        }
        else
        {
            CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:model.chargeID];
            newRecord = [[CKRecord alloc] initWithRecordType:@"ChargeRecord" recordID:recordID];
        }
        
        newRecord[@"chargeID"] = model.chargeID;
        newRecord[@"categoryID"] = model.categoryID;
        newRecord[@"title"] = model.title;
        newRecord[@"amount"] = @(model.amount);
        newRecord[@"isExistCloud"] = @(model.isExistCloud);
        newRecord[@"isRemoved"] = @(model.isRemoved);
        newRecord[@"startTimeInterval"] = @(model.startTimeInterval);
        newRecord[@"modifyTime"] = @(model.modifyTime);
        
        if(model.endTimeInterval)
        {
            newRecord[@"endTimeInterval"] = @(model.endTimeInterval);
        }
        if(model.notes)
        {
            newRecord[@"notes"] = model.notes;
        }
        
        CKDatabase *privateContainer = [[CKContainer defaultContainer] privateCloudDatabase];
        [privateContainer saveRecord:newRecord completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            
            if(completionHandler)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(error);
                });
            }
        }];
    }];
}

+ (void)requestChargeDataWithChargeID:(NSString *)chargeID completionHandler:(void(^)(CKRecord *record, NSError *error))completionHandler
{
    CKDatabase *privateDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:chargeID];
    [privateDatabase fetchRecordWithID:recordID
                     completionHandler:^(CKRecord *record, NSError *error) {
                         if(completionHandler)
                         {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 completionHandler(record, error);
                             });
                         }
                     }];
}

+ (void)requestChargeListDataWithCategoryID:(NSString *)categoryID CompletionHandler:(void (^)(NSArray<ABChargeModel *> *results, NSError *error))completionHandler
{
    CKDatabase *privateDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
    NSPredicate *predicate;
    if(categoryID)
    {
        predicate = [NSPredicate predicateWithFormat:@"categoryID = %@", categoryID];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    }
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"ChargeRecord" predicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTimeInterval" ascending:YES];
    query.sortDescriptors = @[sortDescriptor];
    
    [privateDatabase performQuery:query
                     inZoneWithID:nil
                completionHandler:^(NSArray *results, NSError *error) {
                    
                    if(completionHandler)
                    {
                        if(error)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completionHandler(nil, error);
                            });
                        }
                        else
                        {
                            NSMutableArray *listItem = [NSMutableArray array];
                            for(CKRecord *record in results)
                            {
                                ABChargeModel *model = [[ABChargeModel alloc] init];
                                model.chargeID = record[@"chargeID"];
                                model.categoryID = record[@"categoryID"];
                                model.title = record[@"title"];
                                model.amount = [record[@"amount"] floatValue];
                                model.isExistCloud = [record[@"isExistCloud"] boolValue];
                                model.isRemoved = [record[@"isRemoved"] boolValue];
                                model.startTimeInterval = [record[@"startTimeInterval"] doubleValue];
                                model.modifyTime = [record[@"modifyTime"] doubleValue];
                                
                                if(record[@"endTimeInterval"])
                                {
                                    model.endTimeInterval = [record[@"endTimeInterval"] doubleValue];
                                }
                                if(record[@"notes"])
                                {
                                    model.notes = record[@"notes"];
                                }
                                
                                [listItem addObject:model];
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completionHandler(listItem, nil);
                            });
                        }
                    }
                }];
}

+ (void)requestChargeListDataWithCompletionHandler:(void (^)(NSArray<ABChargeModel *> *results, NSError *error))completionHandler
{
    [self requestChargeListDataWithCategoryID:nil CompletionHandler:completionHandler];
}

///删除消费数据
+ (void)requestDeleteChargeDataWithChargeID:(NSString *)chargeID completionHandler:(void(^)(BOOL isSuccess))completionHandler
{
    CKDatabase *privateDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:chargeID];
    [privateDatabase deleteRecordWithID:recordID completionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        
        if(error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(NO);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(YES);
            });
        }
    }];
}

@end
