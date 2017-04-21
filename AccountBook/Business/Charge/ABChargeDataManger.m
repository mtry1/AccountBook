//
//  ABChargeDataManger.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABChargeDataManger.h"
#import "ABCenterDataManager.h"

@interface ABChargeDataManger ()

@property (nonatomic, strong) NSMutableArray *listItem;

@end

@implementation ABChargeDataManger
{
    NSDate *_calculateStartDate;
    NSDate *_calculateEndDate;
}

@synthesize categoryID = _categoryID;

- (NSMutableArray *)listItem
{
    if(!_listItem)
    {
        _listItem = [NSMutableArray array];
    }
    return _listItem;
}

///请求列表数据
- (void)requestChargeDataWithCategoryID:(NSString *)categoryID
{
    _categoryID = categoryID;
    [[ABCenterDataManager sharedInstance] requestChargeListDateWithCategoryId:categoryID completeHandler:^(NSArray<ABChargeModel *> *array) {
        [self.listItem removeAllObjects];
        if([array isKindOfClass:[NSArray class]] && array.count)
        {
            [self.listItem addObjectsFromArray:array];
        }
        
        [self.delegate chargeDataMangerReloadData:self];
        
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
    }];
}

///请求添加
- (void)requestAddModel:(ABChargeModel *)model
{
    if([model isKindOfClass:[ABChargeModel class]])
    {
        model.categoryID = self.categoryID;
        model.chargeID = [ABUtils uuid];
        [[ABCenterDataManager sharedInstance] requestChargeAddModel:model completeHandler:^(BOOL success) {
            if(success)
            {
                NSInteger index;
                for(index = self.numberOfItem - 1; index >= 0; index--)
                {
                    ABChargeModel *tempModel = self.listItem[index];
                    if(tempModel.startTimeInterval <= model.startTimeInterval)
                    {
                        break;
                    }
                }
                
                [self.listItem insertObject:model atIndex:index + 1];
                [self.delegate chargeDataManger:self addIndex:index + 1];
                [self requestUpdateAmountWithModel:model];
            }
            else
            {
                [self.delegate chargeDataManger:self errorMessage:@"添加失败"];
            }
        }];
    }
}

///请求修改
- (void)requestUpdateModel:(ABChargeModel *)model atIndex:(NSInteger)index
{
    ABChargeModel *modelCopy = [[self dataAtIndex:index] copy];
    modelCopy.title = model.title;
    modelCopy.amount = model.amount;
    modelCopy.startTimeInterval = model.startTimeInterval;
    modelCopy.endTimeInterval = model.endTimeInterval;
    modelCopy.notes = model.notes;
    [[ABCenterDataManager sharedInstance] requestChargeUpdateModel:modelCopy completeHandler:^(BOOL success) {
        if(success)
        {
            //删除
            [self.listItem removeObjectAtIndex:index];
            [self.delegate chargeDataManger:self removeIndex:index];
            
            //添加
            NSInteger i;
            for(i = self.numberOfItem - 1; i >= 0; i--)
            {
                ABChargeModel *tempModel = self.listItem[i];
                if(tempModel.startTimeInterval <= model.startTimeInterval)
                {
                    break;
                }
            }
            [self.listItem insertObject:modelCopy atIndex:i + 1];
            [self.delegate chargeDataManger:self addIndex:i + 1];
            [self requestUpdateAmountWithModel:model];
        }
        else
        {
            [self.delegate chargeDataManger:self errorMessage:@"修改失败"];
        }
    }];
}

///请求删除
- (void)requestRemoveIndex:(NSInteger)index
{
    ABChargeModel *model = [self dataAtIndex:index];
    if(model)
    {
        [[ABCenterDataManager sharedInstance] requestChargeRemoveChargeId:model.chargeID completeHandler:^(BOOL success) {
            if(success)
            {
                [self.listItem removeObjectAtIndex:index];
                [self.delegate chargeDataManger:self removeIndex:index];
                [self requestUpdateAmountWithModel:model];
            }
            else
            {
                [self.delegate chargeDataManger:self errorMessage:@"删除失败"];
            }
        }];
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
    
    [self.delegate chargeDataManger:self didCalculateAmount:@(amount) startDate:startDate endDate:endDate];
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
