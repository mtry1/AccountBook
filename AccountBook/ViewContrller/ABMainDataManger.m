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
    model.name = @"借出";
    model.colorHexString = @"0xff708b";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"借入";
    model.colorHexString = @"0x57c3df";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"淘宝";
    model.colorHexString = @"0xefbc53";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"打球";
    model.colorHexString = @"0xa784d4";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"礼物";
    model.colorHexString = @"0x6cca80";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"吃饭";
    model.colorHexString = @"0xff708b";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"零食";
    model.colorHexString = @"0x57c3df";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"购物";
    model.colorHexString = @"0xefbc53";
    [self.listItem addObject:model];
    
    model = [[ABCategoryModel alloc] init];
    model.name = @"更多";
    model.colorHexString = @"0xa784d4";
    [self.listItem addObject:model];
    
    if([self.delegate respondsToSelector:@selector(dataManagerReloadData:)])
    {
        [self.delegate dataManagerReloadData:self];
    }
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

@end
