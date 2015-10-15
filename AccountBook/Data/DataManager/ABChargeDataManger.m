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
{
    NSDate *_calculateStartDate;
    NSDate *_calculateEndDate;
}

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
    for(NSInteger i = 0; i < 10; i++)
    {
        model = [[ABChargeModel alloc] init];
        model.title = @"周杰伦";
        model.amount = 10000;
        model.startTimeInterval = 1440770901.491756 + i * 100000;
        model.endTimeInterval = 1443280892.843838 + i * 200000;
        model.notes = @"抖动阿萨德发到空间发大发啊速度啊速度加夫里到空间发大发啊速度";
        [self.listItem addObject:model];
    }
    
    [self.callBackUtils callBackAction:@selector(dataManagerReloadData:) object1:self];
    
    if(self.numberOfItem)
    {
        ABChargeModel *firstModel = [self.listItem firstObject];
        [self requestCalculateAmountWithStartDate:[NSDate dateWithTimeIntervalSince1970:firstModel.startTimeInterval]
                                          endDate:[NSDate date]];
    }
    else
    {
        [self requestCalculateAmountWithStartDate:[NSDate date] endDate:[NSDate date]];
    }
}

///请求添加
- (void)requestAddModel:(ABChargeModel *)model
{
    if([model isKindOfClass:[ABChargeModel class]])
    {
        NSInteger i;
        for(i = self.numberOfItem - 1; i >= 0; i--)
        {
            ABChargeModel *tempModel = self.listItem[i];
            if(tempModel.startTimeInterval <= model.startTimeInterval)
            {
                break;
            }
        }
        
        [self.listItem insertObject:model atIndex:i + 1];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + 1 inSection:0];
        [self.callBackUtils callBackAction:@selector(dataManager:addIndexPath:) object1:self object2:indexPath];
        
        [self requestUpdateAmountWithModel:model];
    }
}

///请求修改
- (void)requestUpdateModel:(ABChargeModel *)model atIndex:(NSInteger)index
{
    [self requestRemoveIndex:index];
    [self requestAddModel:model];
}

///请求删除
- (void)requestRemoveIndex:(NSInteger)index
{
    if(0 <= index && index < self.numberOfItem)
    {
        ABChargeModel *model = [self dataAtIndex:index];
        
        [self.listItem removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.callBackUtils callBackAction:@selector(dataManager:removeIndexPath:) object1:self object2:indexPath];
        
        [self requestUpdateAmountWithModel:model];
    }
}

///请求修改额度
- (void)requestUpdateAmountWithModel:(ABChargeModel *)model
{
    NSString *dateString = [ABUtils dateString:model.startTimeInterval];
    NSString *startDateString = [ABUtils dateString:[_calculateStartDate timeIntervalSince1970]];
    NSString *endDateString = [ABUtils dateString:[_calculateEndDate timeIntervalSince1970]];
    if([startDateString compare:dateString] != NSOrderedDescending && [dateString compare:endDateString] != NSOrderedDescending)
    {
        [self requestCalculateAmountWithStartDate:_calculateStartDate endDate:_calculateEndDate];
    }
}

///请求计算额度
- (void)requestCalculateAmountWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    _calculateStartDate = startDate;
    _calculateEndDate = endDate;
    
    NSString *startDateString = [ABUtils dateString:[startDate timeIntervalSince1970]];
    NSString *endDateString = [ABUtils dateString:[endDate timeIntervalSince1970]];
    
    NSInteger amount = 0;
    for(ABChargeModel *model in self.listItem)
    {
        if(model.startTimeInterval)
        {
            NSString *dateString = [ABUtils dateString:model.startTimeInterval];
            if([startDateString compare:dateString] != NSOrderedDescending && [dateString compare:endDateString] != NSOrderedDescending)
            {
                amount += model.amount;
            }
        }
    }
    
    [self.callBackUtils callBackAction:@selector(chargeDataManger:didCalculateAmount:startDate:endDate:)
                               object1:self
                               object2:@(amount)
                               object3:startDate
                               object4:endDate];
}

- (NSInteger)numberOfItem
{
    return self.listItem.count;
}

- (ABChargeModel *)dataAtIndex:(NSInteger)index
{
    if(0 <= index && index < self.numberOfItem)
    {
        return self.listItem[index];
    }
    return nil;
}

@end
