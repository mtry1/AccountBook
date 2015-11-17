//
//  ABCloudKit.m
//  CloudKitDemo
//
//  Created by zhourongqing on 15/11/17.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABCloudKit.h"

@implementation ABCloudKit

+ (void)requestIsOpenCloudCompletionHandler:(void(^)(CKAccountStatus accountStatus, NSError *error))completionHandler
{
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if(completionHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(accountStatus, error);
            });
        }
    }];
}

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
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if([results isKindOfClass:[NSArray class]])
                            {
                                completionHandler([results firstObject], nil);
                            }
                            else
                            {
                                completionHandler(nil, error);
                            }
                        });
                    }
                }];
}

+ (void)requestCategoryListDataCompletionHandler:(void(^)(NSArray<ABCategoryModel *> *results, NSError *error))completionHandler
{
    CKDatabase *privateDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"CategoryRecord" predicate:predicate];
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
                               [listItem addObject:model];
                           }
                           dispatch_async(dispatch_get_main_queue(), ^{
                               completionHandler(listItem, nil);
                           });
                       }
                   }
               }];
}

+ (void)requestInsertChargeData:(ABChargeModel *)model completionHandler:(void(^)(NSError *error))completionHandler
{
    [self requestChargeDataWithchargeID:model.chargeID completionHandler:^(CKRecord *record, NSError *error) {
        
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

+ (void)requestChargeDataWithchargeID:(NSString *)chargeID completionHandler:(void(^)(CKRecord *record, NSError *error))completionHandler
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

+ (void)requestChargeListDataWithCategoryID:(NSString *)categoryID completionHandler:(void (^)(NSArray<ABChargeModel *> *results, NSError *))completionHandler
{
    CKDatabase *privateDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryID = %@", categoryID];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"ChargeRecord" predicate:predicate];
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

@end
