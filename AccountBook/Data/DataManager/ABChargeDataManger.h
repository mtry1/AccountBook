//
//  ABChargeDataManger.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABDataManager.h"
#import "ABChargeModel.h"

@class ABChargeDataManger;

@protocol ABChargeDataMangerDelegate <NSObject>

///计算额度
- (void)chargeDataManger:(ABChargeDataManger *)chargeDataManger didCalculateAmount:(NSNumber *)amount startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end

@interface ABChargeDataManger : ABDataManager

@property (nonatomic, readonly) NSString *categoryID;

///请求列表数据
- (void)requestChargeDataWithCategoryID:(NSString *)categoryID;

///请求添加
- (void)requestAddModel:(ABChargeModel *)model;

///请求修改
- (void)requestUpdateModel:(ABChargeModel *)model atIndex:(NSInteger)index;

///请求删除
- (void)requestRemoveIndex:(NSInteger)index;

///请求计算额度
- (void)requestCalculateAmountWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (NSInteger)numberOfItem;

- (ABChargeModel *)dataAtIndex:(NSInteger)index;

@end
