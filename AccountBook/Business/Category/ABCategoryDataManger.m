//
//  ABCategoryDataManger.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABCategoryDataManger.h"
#import "ABCenterDataManager.h"
#import "NSString+Category.h"

@interface ABCategoryDataManger()<ABCenterDataManagerDelegate>

@property (nonatomic, strong) NSMutableArray *listItem;

@end

@implementation ABCategoryDataManger

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [[ABCenterDataManager share] addDelegate:self];
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
        ABCategoryModel *model = [[ABCategoryModel alloc] init];
        model.categoryID = [ABUtils uuid];
        model.name = text;
        model.colorHexString = [self colorHexStringAtIndex:self.listItem.count];
        [self.listItem addObject:model];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.numberOfItem - 1 inSection:0];
        [self.delegate categoryDataManger:self addIndexPath:indexPath];
        
        [[ABCenterDataManager share] requestCategoryAddModel:[model copy]];
    }
}

- (void)requestRemoveIndex:(NSInteger)index
{
    if(index < [self numberOfItem])
    {
        ABCategoryModel *model = [self dataAtIndex:index];
        [self.listItem removeObjectAtIndex:index];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.delegate categoryDataManger:self removeIndexPath:indexPath];
        
        [[ABCenterDataManager share] requestCategoryRemoveCategoryId:model.categoryID];
    }
}

- (void)requestRename:(NSString *)text atIndex:(NSInteger)index
{
    text = [text trim];
    if(text.length == 0)
    {
        text = @" ";
    }
    
    ABCategoryModel *model = [self dataAtIndex:index];
    if(model)
    {
        model.name = text;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.delegate categoryDataManger:self updateIndexPath:indexPath];
        
        [[ABCenterDataManager share] requestCategoryUpdateModel:model.copy];
    }
}

- (NSString *)colorHexStringAtIndex:(NSInteger)index
{
    NSArray *colors = @[@"0x43A7CA", @"0xF75978", @"0xE9B043", @"0x5DC26D", @"0xB26DAD", @"0xD19459", @"0x6395c5", @"0x98BF58", @"0xD8686B"];
    index = index % colors.count;
    return colors[index];
}

#pragma mark - ABCenterDataManagerDelegate

- (void)centerDataManager:(ABCenterDataManager *)manager successRequestCategoryListData:(NSArray *)data
{
    [self.listItem removeAllObjects];
    [self.listItem addObjectsFromArray:data];
    [self.delegate categoryDataMangerReloadData:self];
}

@end
