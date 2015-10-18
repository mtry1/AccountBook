//
//  ABCategoryDataManger.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABCategoryDataManger.h"

@interface ABCategoryDataManger()<ABCenterDataManagerDelegate>

@property (nonatomic, strong) NSMutableArray *listItem;

@end

@implementation ABCategoryDataManger

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [[ABCenterDataManager share].callBackUtils addDelegate:self];
    }
    return self;
}

- (NSMutableArray *)listItem
{
    if(!_listItem)
    {
        _listItem = [NSMutableArray array];
    }
    return _listItem;
}

- (void)requestInitData;
{
    [[ABCenterDataManager share] requestCategoryListData];
}

- (NSInteger)numberOfItem
{
    return self.listItem.count;
}

- (ABCategoryModel *)dataAtIndex:(NSInteger)index
{
    if(index < [self numberOfItem])
    {
        return self.listItem[index];
    }
    return nil;
}

- (void)requestAddObjectWithText:(NSString *)text
{
    if(text.length)
    {
        ABCategoryModel *model = [self modelForText:text];
        [[ABCenterDataManager share] requestCategoryAddModel:[model copy]];
        
        [self.listItem addObject:model];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.numberOfItem - 1 inSection:0];
        [self.callBackUtils callBackAction:@selector(dataManager:addIndexPath:) object1:self object2:indexPath];
    }
}

- (void)requestRemoveIndex:(NSInteger)index
{
    if(index < [self numberOfItem])
    {
        ABCategoryModel *model = [self dataAtIndex:index];
        [[ABCenterDataManager share] requestCategoryRemoveCategoryId:model.categoryID];
        
        [self.listItem removeObjectAtIndex:index];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.callBackUtils callBackAction:@selector(dataManager:removeIndexPath:) object1:self object2:indexPath];
    }
}

- (void)requestMoveItemAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex
{
    id object = self.listItem[index];
    [self.listItem removeObjectAtIndex:index];
    [self.listItem insertObject:object atIndex:toIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:toIndex inSection:0];
    [self.callBackUtils callBackAction:@selector(categoryDataManger:moveItemAtIndexPath:toIndexPath:) object1:self object2:indexPath object3:toIndexPath];
}

- (ABCategoryModel *)modelForText:(NSString *)text
{
    ABCategoryModel *model = [[ABCategoryModel alloc] init];
    model.categoryID = [ABUtils uuid];
    model.name = text;
    model.colorHexString = [self colorHexStringAtIndex:self.listItem.count];
    model.isRemoved = NO;
    model.isExistCloud = NO;
    return model;
}

- (NSString *)colorHexStringAtIndex:(NSInteger)index
{
    NSArray *colors = @[@"0xff708b", @"0x57c3df", @"0xefbc53", @"0xa784d4", @"0x6cca80"];
    index = index % colors.count;
    return colors[index];
}

#pragma mark - ABCenterDataManagerDelegate

- (void)centerDataManager:(ABCenterDataManager *)manager successRequestCategoryListData:(NSArray *)data
{
    if(data.count)
    {
        [self.listItem removeAllObjects];
        [self.listItem addObjectsFromArray:data];
        
        [self.callBackUtils callBackAction:@selector(dataManagerReloadData:) object1:self];
    }
}

@end
