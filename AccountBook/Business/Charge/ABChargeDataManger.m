//
//  ABChargeDataManger.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABChargeDataManger.h"
#import "ABCenterDataManager.h"

@interface ABChargeDataManger ()<ABCenterDataManagerDelegate>

@property (nonatomic, strong) NSMutableArray *listItem;

@end

@implementation ABChargeDataManger
{
    NSDate *_calculateStartDate;
    NSDate *_calculateEndDate;
}

@synthesize categoryID = _categoryID;

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [[ABCenterDataManager sharedInstance] addDelegate:self];
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

///请求列表数据
- (void)requestChargeDataWithCategoryID:(NSString *)categoryID
{
    _categoryID = categoryID;
    [[ABCenterDataManager sharedInstance] requestChargeListDateWithCategoryId:categoryID];
}

///请求添加
- (void)requestAddModel:(ABChargeModel *)model
{
    if([model isKindOfClass:[ABChargeModel class]])
    {
        model.categoryID = self.categoryID;
        model.chargeID = [ABUtils uuid];
        
        [[ABCenterDataManager sharedInstance] requestChargeAddModel:model];
        
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
        [self.delegate chargeDataManger:self addIndexPath:indexPath];
        
        [self requestUpdateAmountWithModel:model];
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
    
    [[ABCenterDataManager sharedInstance] requestChargeUpdateModel:modelCopy];
    
    //删除
    [self.listItem removeObjectAtIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.delegate chargeDataManger:self removeIndexPath:indexPath];
    
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
    indexPath = [NSIndexPath indexPathForRow:i + 1 inSection:0];
    [self.delegate chargeDataManger:self addIndexPath:indexPath];
    
    [self requestUpdateAmountWithModel:model];
}

///请求删除
- (void)requestRemoveIndex:(NSInteger)index
{
    if(0 <= index && index < self.numberOfItem)
    {
        ABChargeModel *model = [self dataAtIndex:index];
        
        [[ABCenterDataManager sharedInstance] requestChargeRemoveChargeId:model.chargeID];
        
        [self.listItem removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.delegate chargeDataManger:self removeIndexPath:indexPath];
        
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

#pragma mark - ABCenterDataManagerDelegate

- (void)centerDataManager:(ABCenterDataManager *)manager successRequestChargeListData:(NSArray *)data
{
    [self.listItem removeAllObjects];
    if([data isKindOfClass:[NSArray class]] && data.count)
    {
        [self.listItem addObjectsFromArray:data];
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
}

@end
