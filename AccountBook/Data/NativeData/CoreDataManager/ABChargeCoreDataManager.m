//
//  ABChargeCoreDataManager.m
//  AccountBook
//
//  Created by zhourongqing on 16/7/22.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import "ABChargeCoreDataManager.h"
#import "ABCoreDataHelper.h"
#import "ABChargeEntity.h"

@implementation ABChargeCoreDataManager

#pragma mark - public

+ (void)selectAllChargeListDataCompleteHandler:(void(^)(NSArray<ABChargeModel *> *array))completeHandler
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABChargeEntity class])
                                                         inManagedObjectContext:[ABCoreDataHelper sharedInstance].context];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTimeInterval" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listItem = [[ABCoreDataHelper sharedInstance].context executeFetchRequest:request error:&error];
    
    NSMutableArray *result = [NSMutableArray array];
    for(ABChargeEntity *entity in listItem)
    {
        ABChargeModel *model = [[ABChargeModel alloc] init];
        model.categoryID = entity.categoryID;
        model.chargeID = entity.chargeID;
        model.title = entity.title;
        model.amount = [entity.amount floatValue];
        model.startTimeInterval = [entity.startTimeInterval doubleValue];
        model.endTimeInterval = [entity.endTimeInterval doubleValue];
        model.notes = entity.notes;
        model.isRemoved = [entity.isRemoved boolValue];
        model.isExistCloud = [entity.isExistCloud boolValue];
        model.modifyTime = [entity.modifyTime doubleValue];
        [result addObject:model];
    }
    
    if(completeHandler)
    {
        completeHandler(result);
    }
}

+ (void)selectChargeListDateWithCategoryID:(NSString *)categoryID completeHandler:(void(^)(NSArray<ABChargeModel *> *array))completeHandler
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABChargeEntity class])
                                                         inManagedObjectContext:[ABCoreDataHelper sharedInstance].context];
    [request setEntity:entityDescription];
    
    NSString *selectString = [NSString stringWithFormat:@"categoryID == \"%@\" && isRemoved == 0", categoryID];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:selectString];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTimeInterval" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listItem = [[ABCoreDataHelper sharedInstance].context executeFetchRequest:request error:&error];
    
    NSMutableArray *result = [NSMutableArray array];
    for(ABChargeEntity *entity in listItem)
    {
        ABChargeModel *model = [[ABChargeModel alloc] init];
        model.categoryID = entity.categoryID;
        model.chargeID = entity.chargeID;
        model.title = entity.title;
        model.amount = [entity.amount floatValue];
        model.startTimeInterval = [entity.startTimeInterval doubleValue];
        model.endTimeInterval = [entity.endTimeInterval doubleValue];
        model.notes = entity.notes;
        model.isRemoved = [entity.isRemoved boolValue];
        model.isExistCloud = [entity.isExistCloud boolValue];
        model.modifyTime = [entity.modifyTime doubleValue];
        [result addObject:model];
    }
    
    if(completeHandler)
    {
        completeHandler(result);
    }
}

+ (void)deleteChargeChargeID:(NSString *)chargeID flag:(BOOL)flag completeHandler:(void(^)(BOOL success))completeHandler
{
    BOOL result = YES;
    ABChargeEntity *entity = [self selectChargeEntityWithChargeID:chargeID];
    if(entity)
    {
        if(!flag)
        {
            entity.modifyTime = @([[NSDate date] timeIntervalSince1970]);
            entity.isRemoved = @(YES);
        }
        else
        {
            [[ABCoreDataHelper sharedInstance].context deleteObject:entity];
        }
        result = [[ABCoreDataHelper sharedInstance] saveContext];
    }
    if(completeHandler)
    {
        completeHandler(result);
    }
}

+ (void)deleteChargeListDataWithCategoryID:(NSString *)categoryID completeHandler:(void(^)(BOOL success))completeHandler
{
    [self selectChargeListDateWithCategoryID:categoryID completeHandler:^(NSArray<ABChargeModel *> *array) {
        for(ABChargeModel *model in array)
        {
            ABChargeEntity *entity = [self selectChargeEntityWithChargeID:model.chargeID];
            if(entity)
            {
                entity.modifyTime = @([[NSDate date] timeIntervalSince1970]);
                entity.isRemoved = @(YES);
            }
        }
        
        BOOL result = [[ABCoreDataHelper sharedInstance] saveContext];
        if(completeHandler)
        {
            completeHandler(result);
        }
    }];
}

+ (void)insertChargeModel:(ABChargeModel *)model completeHandler:(void(^)(BOOL success))completeHandler
{
    ABChargeEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ABChargeEntity class])
                                                           inManagedObjectContext:[ABCoreDataHelper sharedInstance].context];
    entity.categoryID = model.categoryID;
    entity.chargeID = model.chargeID;
    entity.title = model.title;
    entity.amount = @(model.amount);
    entity.startTimeInterval = @(model.startTimeInterval);
    entity.endTimeInterval = @(model.endTimeInterval);
    entity.notes = model.notes;
    entity.isRemoved = @(model.isRemoved);
    entity.isExistCloud = @(model.isExistCloud);
    entity.modifyTime = @(model.modifyTime);
    
    BOOL result = [[ABCoreDataHelper sharedInstance] saveContext];
    if(completeHandler)
    {
        completeHandler(result);
    }
}

+ (void)updateChargeModel:(ABChargeModel *)model completeHandler:(void(^)(BOOL success))completeHandler
{
    ABChargeEntity *entity = [self selectChargeEntityWithChargeID:model.chargeID];
    if(entity)
    {
        entity.title = model.title;
        entity.amount = @(model.amount);
        entity.startTimeInterval = @(model.startTimeInterval);
        entity.endTimeInterval = @(model.endTimeInterval);
        entity.notes = model.notes;
        entity.isRemoved = @(model.isRemoved);
        entity.isExistCloud = @(model.isExistCloud);
        entity.modifyTime = @(model.modifyTime);
        
        BOOL result = [[ABCoreDataHelper sharedInstance] saveContext];
        if(completeHandler)
        {
            completeHandler(result);
        }
    }
    else
    {
        [self insertChargeModel:model completeHandler:^(BOOL success) {
            if(completeHandler)
            {
                completeHandler(success);
            }
        }];
    }
}

#pragma mark - private

+ (ABChargeEntity *)selectChargeEntityWithChargeID:(NSString *)chargeID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABChargeEntity class])
                                                         inManagedObjectContext:[ABCoreDataHelper sharedInstance].context];
    [request setEntity:entityDescription];
    
    NSString *selectString = [NSString stringWithFormat:@"chargeID == \"%@\"", chargeID];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:selectString];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listItem = [[ABCoreDataHelper sharedInstance].context executeFetchRequest:request error:&error];
    if(listItem.count)
    {
        return [listItem lastObject];
    }
    return nil;
}

@end
