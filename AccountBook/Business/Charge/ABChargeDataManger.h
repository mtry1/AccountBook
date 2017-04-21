//
//  ABChargeDataManger.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABChargeModel.h"

@class ABChargeDataManger;

@protocol ABChargeDataMangerDelegate <NSObject>

- (void)chargeDataMangerReloadData:(ABChargeDataManger *)manager;
- (void)chargeDataManger:(ABChargeDataManger *)manager removeIndex:(NSInteger)index;
- (void)chargeDataManger:(ABChargeDataManger *)manager updateIndex:(NSInteger)index;
- (void)chargeDataManger:(ABChargeDataManger *)manager addIndex:(NSInteger)index;
- (void)chargeDataManger:(ABChargeDataManger *)manager errorMessage:(NSString *)message;

///计算额度
- (void)chargeDataManger:(ABChargeDataManger *)chargeDataManger didCalculateAmount:(NSNumber *)amount startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end

@interface ABChargeDataManger : NSObject

@property (nonatomic, weak) id<ABChargeDataMangerDelegate>delegate;

@property (nonatomic, readonly) NSString *categoryID;

- (void)requestChargeDataWithCategoryID:(NSString *)categoryID;
- (void)requestAddModel:(ABChargeModel *)model;
- (void)requestUpdateModel:(ABChargeModel *)model atIndex:(NSInteger)index;
- (void)requestRemoveIndex:(NSInteger)index;
- (void)requestCalculateAmountWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (NSInteger)numberOfItem;
- (ABChargeModel *)dataAtIndex:(NSInteger)index;

@end
