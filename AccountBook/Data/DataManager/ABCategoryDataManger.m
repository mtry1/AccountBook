//
//  ABCategoryDataManger.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABCategoryDataManger.h"

@interface ABCategoryDataManger()

@property (nonatomic, strong) NSMutableArray *listItem;

@end

@implementation ABCategoryDataManger

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
    [self.listItem removeAllObjects];
    
    [self.listItem addObject:[self modelForText:@"借出"]];
    [self.listItem addObject:[self modelForText:@"借入"]];
    [self.listItem addObject:[self modelForText:@"淘宝"]];
    [self.listItem addObject:[self modelForText:@"夜宵"]];
    [self.listItem addObject:[self modelForText:@"礼物"]];
    [self.listItem addObject:[self modelForText:@"吃饭"]];
    [self.listItem addObject:[self modelForText:@"零食"]];
    [self.listItem addObject:[self modelForText:@"衣服"]];
    [self.listItem addObject:[self modelForText:@"其它"]];
    
    [self callBackAction:@selector(dataManagerReloadData:) object1:self];
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
        [self.listItem addObject:[self modelForText:text]];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.numberOfItem - 1 inSection:0];
        [self callBackAction:@selector(dataManager:addIndexPath:) object1:self object2:indexPath];
    }
}

- (void)requestRemoveIndex:(NSInteger)index
{
    if(index < [self numberOfItem])
    {
        [self.listItem removeObjectAtIndex:index];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self callBackAction:@selector(dataManager:removeIndexPath:) object1:self object2:indexPath];
    }
}

- (void)requestMoveItemAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex
{
    id object = self.listItem[index];
    [self.listItem removeObjectAtIndex:index];
    [self.listItem insertObject:object atIndex:toIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:toIndex inSection:0];
    [self callBackAction:@selector(categoryDataManger:moveItemAtIndexPath:toIndexPath:) object1:self object2:indexPath object3:toIndexPath];
}

- (ABCategoryModel *)modelForText:(NSString *)text
{
    ABCategoryModel *model = [[ABCategoryModel alloc] init];
    model.categoryID = [ABUtils uuid];
    model.name = text;
    model.colorHexString = [[self class] colorHexStringAtIndex:self.listItem.count];
    return model;
}

+ (NSString *)colorHexStringAtIndex:(NSInteger)index
{
    NSArray *colors = @[@"0xff708b", @"0x57c3df", @"0xefbc53", @"0xa784d4", @"0x6cca80"];
    index = index % colors.count;
    return colors[index];
}

@end
