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

///查询分类列表数据
- (NSArray *)selectCategoryListData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABCategoryEntity class])
                                                         inManagedObjectContext:self.coreDataHelper.context];
    [request setEntity:entityDescription];
    
    NSString *selectString = [NSString stringWithFormat:@"isRemoved == \"%d\"", NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:selectString];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listItem = [self.coreDataHelper.context executeFetchRequest:request error:&error];
    
    NSMutableArray *result = [NSMutableArray array];
    for(ABCategoryEntity *entity in listItem)
    {
        ABCategoryModel *model = [[ABCategoryModel alloc] init];
        model.categoryID = entity.categoryId;
        model.name = entity.title;
        model.colorHexString = entity.colorHexString;
        [result addObject:model];
    }
    
    return result;
}

///查询分类数据，通过分类id
- (ABCategoryEntity *)selectCategoryEntityWithCategoryId:(NSString *)categoryId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ABCategoryEntity class]) inManagedObjectContext:self.coreDataHelper.context];
    [request setEntity:entityDescription];
    
    NSString *selectString = [NSString stringWithFormat:@"categoryId == \"%@\"", categoryId];
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

///请求增加分类
- (void)insertCategoryModel:(ABCategoryModel *)model
{
    ABCategoryEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ABCategoryEntity class]) inManagedObjectContext:self.coreDataHelper.context];
    entity.isRemoved = @(NO);
    entity.isExistCloud = @(NO);
    entity.categoryId = model.categoryID;
    entity.title = model.name;
    entity.colorHexString = model.colorHexString;
}

///请求删除分类
- (void)deleteCategoryCategoryId:(NSString *)categoryId
{
    ABCategoryEntity *entity = [self selectCategoryEntityWithCategoryId:categoryId];
    if(entity)
    {
        if(![entity.isExistCloud boolValue])
        {
            [self.coreDataHelper.context deleteObject:entity];
        }
        else
        {
            entity.isRemoved = @(YES);
        }
    }
}

///修改分类
- (void)updateCategoryModel:(ABCategoryModel *)model
{
    if(model.categoryID)
    {
        ABCategoryEntity *entity = [self selectCategoryEntityWithCategoryId:model.categoryID];
        if(entity)
        {
            entity.categoryId = model.categoryID;
            entity.title = model.name;
            entity.colorHexString = model.colorHexString;
        }
        else
        {
            [self insertCategoryModel:model];
        }
    }
}



///查询消费列表
- (NSArray *)selectChargeListDateWithCategoryId:(NSString *)categoryId
{
    return nil;
}

///增加消费记录
- (void)insertChargeModel:(ABChargeModel *)model
{
    
}

///删除消费记录
- (void)deleteChargeChargeId:(NSString *)chargeId
{
    
}

///修改消费记录
- (void)updateChargeModel:(ABChargeModel *)model
{
    
}

@end
