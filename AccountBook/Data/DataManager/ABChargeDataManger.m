//
//  ABChargeDataManger.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABChargeDataManger.h"

@interface ABChargeDataManger ()

@property (nonatomic, strong) NSMutableArray *listItem;

@end

@implementation ABChargeDataManger

- (NSMutableArray *)listItem
{
    if(!_listItem)
    {
        _listItem = [NSMutableArray array];
    }
    return _listItem;
}

///请求列表数据
- (void)requestChargeDataWithID:(NSString *)chargeID
{
    ABChargeModel *model;
    model = [[ABChargeModel alloc] init];
    model.title = @"周杰伦";
    model.money = @"500000元";
}

///请求添加
- (void)requestAddModel:(ABChargeModel *)model
{
    if([model isKindOfClass:[ABChargeModel class]])
    {
        [self.listItem addObject:model];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.numberOfItem inSection:0];
        [self callBackAction:@selector(dataManager:addIndexPath:) object1:self object2:indexPath];
    }
}

///请求删除
- (void)requestRemoveIndex:(NSInteger)index
{
    if(index < self.numberOfItem)
    {
        [self.listItem removeObjectAtIndex:index];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self callBackAction:@selector(dataManager:removeIndexPath:) object1:self object2:indexPath];
    }
}

- (NSInteger)numberOfItem
{
    return self.listItem.count;
}

- (ABChargeModel *)modelAtIndex:(NSInteger)index
{
    if(index < self.numberOfItem)
    {
        return self.listItem[index];
    }
    return nil;
}

@end
