//
//  ABCenterCoreDataManager.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/16.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABCenterCoreDataManager.h"
#import "ABCoreDataHelper.h"
#import "ABChargeEntity.h"
#import "ABCategoryEntity.h"

@interface ABCenterCoreDataManager ()

@property (nonatomic, readonly) ABCoreDataHelper *coreDataHelper;

@end

@implementation ABCenterCoreDataManager

@synthesize coreDataHelper = _coreDataHelper;

- (ABCoreDataHelper *)coreDataHelper
{
    if(!_coreDataHelper)
    {
        _coreDataHelper = [ABCoreDataHelper share];
    }
    return _coreDataHelper;
}

#pragma mark 查询分类列表数据
- (NSArray *)selectCategoryListData:(BOOL)isSelectRemoved
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABCategoryEntity class])
                                                         inManagedObjectContext:self.coreDataHelper.context];
    [request setEntity:entityDescription];
    
    if(!isSelectRemoved)
    {
        NSString *selectString = [NSString stringWithFormat:@"isRemoved == 0"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:selectString];
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *listItem = [self.coreDataHelper.context executeFetchRequest:request error:&error];
    
    NSMutableArray *result = [NSMutableArray array];
    for(ABCategoryEntity *entity in listItem)
    {
        ABCategoryModel *model = [[ABCategoryModel alloc] init];
        model.categoryID = entity.categoryID;
        model.name = entity.title;
        model.colorHexString = entity.colorHexString;
        model.isRemoved = [entity.isRemoved boolValue];
        model.isExistCloud = [entity.isExistCloud boolValue];
        model.modifyTime = [entity.modifyTime doubleValue];
        [result addObject:model];
    }
    
    return result;
}

#pragma mark 查询分类数据，通过分类id
- (ABCategoryEntity *)selectCategoryEntityWithCategoryID:(NSString *)categoryID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABCategoryEntity class]) inManagedObjectContext:self.coreDataHelper.context];
    [request setEntity:entityDescription];
    
    NSString *selectString = [NSString stringWithFormat:@"categoryID == \"%@\"", categoryID];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:selectString];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listItem = [self.coreDataHelper.context executeFetchRequest:request error:&error];
    if(listItem.count)
    {
        return [listItem lastObject];
    }
    return nil;
}

#pragma mark 请求增加分类
- (void)insertCategoryModel:(ABCategoryModel *)model
{
    ABCategoryEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ABCategoryEntity class]) inManagedObjectContext:self.coreDataHelper.context];
    entity.isRemoved = @(model.isRemoved);
    entity.isExistCloud = @(model.isExistCloud);
    entity.categoryID = model.categoryID;
    entity.title = model.name;
    entity.colorHexString = model.colorHexString;
    entity.modifyTime = @([[NSDate date] timeIntervalSince1970]);
    
    [self.coreDataHelper saveContext];
}

#pragma mark 请求删除分类
- (void)deleteCategoryCategoryID:(NSString *)categoryID
{
    ABCategoryEntity *entity = [self selectCategoryEntityWithCategoryID:categoryID];
    if(entity)
    {
        if([entity.isExistCloud boolValue])
        {
            entity.modifyTime = @([[NSDate date] timeIntervalSince1970]);
            entity.isRemoved = @(YES);
        }
        else
        {
            [self.coreDataHelper.context deleteObject:entity];
        }
    }
    
    [self.coreDataHelper saveContext];
}

#pragma mark 修改分类
- (void)updateCategoryModel:(ABCategoryModel *)model
{
    if(model.categoryID)
    {
        ABCategoryEntity *entity = [self selectCategoryEntityWithCategoryID:model.categoryID];
        if(entity)
        {
            entity.title = model.name;
            entity.colorHexString = model.colorHexString;
            entity.isRemoved = @(model.isRemoved);
            entity.isExistCloud = @(model.isExistCloud);
            entity.modifyTime = @([[NSDate date] timeIntervalSince1970]);
            
            [self.coreDataHelper saveContext];
        }
        else
        {
            [self insertCategoryModel:model];
        }
    }
}

#pragma mark 查询全部消费纪录
- (NSArray *)selectChargeListData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABChargeEntity class])
                                                         inManagedObjectContext:self.coreDataHelper.context];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *listItem = [self.coreDataHelper.context executeFetchRequest:request error:&error];
    
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
    return result;
}

#pragma mark 查询消费列表
- (NSArray *)selectChargeListDateWithCategoryID:(NSString *)categoryId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABChargeEntity class])
                                                         inManagedObjectContext:self.coreDataHelper.context];
    [request setEntity:entityDescription];
    
    NSString *selectString = [NSString stringWithFormat:@"categoryID == \"%@\" && isRemoved == 0", categoryId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:selectString];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTimeInterval" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listItem = [self.coreDataHelper.context executeFetchRequest:request error:&error];
    
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
    return result;
}

#pragma mark 增加消费记录
- (void)insertChargeModel:(ABChargeModel *)model
{
    ABChargeEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ABChargeEntity class]) inManagedObjectContext:self.coreDataHelper.context];
    entity.categoryID = model.categoryID;
    entity.chargeID = model.chargeID;
    entity.title = model.title;
    entity.amount = @(model.amount);
    entity.startTimeInterval = @(model.startTimeInterval);
    entity.endTimeInterval = @(model.endTimeInterval);
    entity.notes = model.notes;
    entity.isRemoved = @(model.isRemoved);
    entity.isExistCloud = @(model.isExistCloud);
    entity.modifyTime = @([[NSDate date] timeIntervalSince1970]);
    
    [self.coreDataHelper saveContext];
}

#pragma mark 删除消费记录
- (void)deleteChargeChargeID:(NSString *)chargeID
{
    ABChargeEntity *entity = [self selectChargeEntityWithChargeID:chargeID];
    if(entity)
    {
        if([entity.isExistCloud boolValue])
        {
            entity.modifyTime = @([[NSDate date] timeIntervalSince1970]);
            entity.isRemoved = @(YES);
        }
        else
        {
            [self.coreDataHelper.context deleteObject:entity];
        }
    }
    
    [self.coreDataHelper saveContext];
}

#pragma mark 修改消费记录
- (void)updateChargeModel:(ABChargeModel *)model
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
        entity.modifyTime = @([[NSDate date] timeIntervalSince1970]);
        
        [self.coreDataHelper saveContext];
    }
    else
    {
        [self insertChargeModel:model];
    }
}

#pragma mark 查询消费
- (ABChargeEntity *)selectChargeEntityWithChargeID:(NSString *)chargeID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABChargeEntity class]) inManagedObjectContext:self.coreDataHelper.context];
    [request setEntity:entityDescription];
    
    NSString *selectString = [NSString stringWithFormat:@"chargeID == \"%@\"", chargeID];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:selectString];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listItem = [self.coreDataHelper.context executeFetchRequest:request error:&error];
    if(listItem.count)
    {
        return [listItem lastObject];
    }
    return nil;
}

@end
