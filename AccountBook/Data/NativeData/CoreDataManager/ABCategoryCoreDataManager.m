//
//  ABCategoryCoreDataManager.m
//  AccountBook
//
//  Created by zhourongqing on 16/7/22.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import "ABCategoryCoreDataManager.h"
#import "ABCoreDataHelper.h"
#import "ABCategoryEntity.h"

@implementation ABCategoryCoreDataManager

#pragma mark - public

+ (void)selectCategoryListData:(BOOL)loadDeleted completeHandler:(void(^)(NSArray<ABCategoryModel *> *array))completeHandler
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABCategoryEntity class])
                                                         inManagedObjectContext:[ABCoreDataHelper sharedInstance].context];
    [request setEntity:entityDescription];
    NSSortDescriptor *sortDescripter = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:YES];
    [request setSortDescriptors:@[sortDescripter]];
    
    if(!loadDeleted)
    {
        NSString *selectString = [NSString stringWithFormat:@"isRemoved == 0"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:selectString];
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *listItem = [[ABCoreDataHelper sharedInstance].context executeFetchRequest:request error:&error];
    
    NSMutableArray *result = [NSMutableArray array];
    for(ABCategoryEntity *entity in listItem)
    {
        ABCategoryModel *model = [[ABCategoryModel alloc] init];
        model.categoryID = entity.categoryID;
        model.name = entity.title;
        model.colorHexString = entity.colorHexString;
        model.isRemoved = [entity.isRemoved boolValue];
        model.isExistCloud = [entity.isExistCloud boolValue];
        model.createTime = [entity.createTime doubleValue];
        model.modifyTime = [entity.modifyTime doubleValue];
        [result addObject:model];
    }
    
    if(completeHandler)
    {
        completeHandler(result);
    }
}

+ (void)insertCategoryModel:(ABCategoryModel *)model completeHandler:(void(^)(BOOL success))completeHandler
{
    ABCategoryEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ABCategoryEntity class])
                                                             inManagedObjectContext:[ABCoreDataHelper sharedInstance].context];
    entity.isRemoved = @(model.isRemoved);
    entity.isExistCloud = @(model.isExistCloud);
    entity.categoryID = model.categoryID;
    entity.title = model.name;
    entity.colorHexString = model.colorHexString;
    entity.createTime = @(model.createTime);
    entity.modifyTime = @(model.modifyTime);
    
    BOOL result = [[ABCoreDataHelper sharedInstance] saveContext];
    if(completeHandler)
    {
        completeHandler(result);
    }
}

+ (void)updateCategoryModel:(ABCategoryModel *)model completeHandler:(void(^)(BOOL success))completeHandler
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
            entity.modifyTime = @(model.modifyTime);
            entity.createTime = @(model.createTime);
            
            BOOL result = [[ABCoreDataHelper sharedInstance] saveContext];
            if(completeHandler)
            {
                completeHandler(result);
            }
        }
        else
        {
            [self insertCategoryModel:model completeHandler:^(BOOL success) {
                if(completeHandler)
                {
                    completeHandler(success);
                }
            }];
        }
    }
}

+ (void)deleteCategoryCategoryID:(NSString *)categoryID flag:(BOOL)flag completeHandler:(void(^)(BOOL success))completeHandler
{
    BOOL result = YES;
    ABCategoryEntity *entity = [self selectCategoryEntityWithCategoryID:categoryID];
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

#pragma mark - private

+ (ABCategoryEntity *)selectCategoryEntityWithCategoryID:(NSString *)categoryID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABCategoryEntity class]) inManagedObjectContext:[ABCoreDataHelper sharedInstance].context];
    [request setEntity:entityDescription];
    
    NSString *selectString = [NSString stringWithFormat:@"categoryID == \"%@\"", categoryID];
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
