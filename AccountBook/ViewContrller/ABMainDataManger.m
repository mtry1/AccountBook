//
//  ABMainDataManger.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/19.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABMainDataManger.h"

@interface ABMainDataManger()

@property (nonatomic, strong) NSMutableArray *listItem;

@end

@implementation ABMainDataManger

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
    
    ABCategoryModel *model;
    model = [[ABCategoryModel alloc] init];
    model.name = @"0其它";
    model.colorHexString = @"0xa784d4";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"1借出";
    model.colorHexString = @"0xff708b";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"2借入";
    model.colorHexString = @"0x57c3df";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"3淘宝";
    model.colorHexString = @"0xefbc53";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"4打球";
    model.colorHexString = @"0xa784d4";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"5礼物";
    model.colorHexString = @"0x6cca80";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"6吃饭";
    model.colorHexString = @"0xff708b";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"7零食";
    model.colorHexString = @"0x57c3df";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"8购物";
    model.colorHexString = @"0xefbc53";
    [self.listItem addObject:model];
    
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

- (void)removeIndex:(NSInteger)index
{
    if(index < [self numberOfItem])
    {
        [self.listItem removeObjectAtIndex:index];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self callBackAction:@selector(dataManager:removeIndexPath:) object1:self object2:indexPath];
    }
}

- (void)moveItemAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex
{
    id object = self.listItem[index];
    [self.listItem removeObjectAtIndex:index];
    [self.listItem insertObject:object atIndex:toIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:toIndex inSection:0];
    [self callBackAction:@selector(mainDataManger:moveItemAtIndexPath:toIndexPath:) object1:self object2:indexPath object3:toIndexPath];
}

@end
