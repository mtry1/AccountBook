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
    [[ABCenterDataManager sharedInstance] requestCategoryListDataWithCompleteHandler:^(NSArray<ABCategoryModel *> *array) {
        [self.listItem removeAllObjects];
        [self.listItem addObjectsFromArray:array];
        [self.delegate categoryDataMangerReloadData:self];
    }];
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
        [self.delegate categoryDataManger:self addIndex:self.numberOfItem - 1];
        
        [[ABCenterDataManager sharedInstance] requestCategoryAddModel:[model copy] completeHandler:^(BOOL success) {
            if(!success)
            {
                NSInteger index = [self.listItem indexOfObject:model];
                if(index != NSNotFound)
                {
                    [self.listItem removeObject:model];
                    [self.delegate categoryDataManger:self removeIndex:index];
                    [self.delegate categoryDataManger:self errorMessage:@"添加失败"];
                }
            }
        }];
    }
}

- (void)requestRemoveIndex:(NSInteger)index
{
    if(index < [self numberOfItem])
    {
        ABCategoryModel *model = [self dataAtIndex:index];
        [[ABCenterDataManager sharedInstance] requestCategoryRemoveCategoryId:model.categoryID completeHandler:^(BOOL success) {
            if(success)
            {
                [self.listItem removeObjectAtIndex:index];
                [self.delegate categoryDataManger:self removeIndex:index];
            }
            else
            {
                [self.delegate categoryDataManger:self errorMessage:@"删除失败"];
            }
        }];
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
        NSString *preName = model.name;
        model.name = text;
        [[ABCenterDataManager sharedInstance] requestCategoryUpdateModel:model.copy completeHandler:^(BOOL success) {
            if(success)
            {
                [self.delegate categoryDataManger:self updateIndex:index];
            }
            else
            {
                model.name = preName;
                [self.delegate categoryDataManger:self errorMessage:@"更新失败"];
            }
        }];
    }
}

- (NSString *)colorHexStringAtIndex:(NSInteger)index
{
    NSArray *colors = @[@"0x43A7CA", @"0xF75978", @"0xE9B043", @"0x5DC26D", @"0xB26DAD", @"0xD19459", @"0x6395c5", @"0x98BF58", @"0xD8686B"];
    index = index % colors.count;
    return colors[index];
}

@end
