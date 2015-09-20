//
//  ABChargeDataManger.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABDataManager.h"
#import "ABChargeModel.h"

@interface ABChargeDataManger : ABDataManager

///请求列表数据
- (void)requestChargeDataWithID:(NSString *)chargeID;

///请求添加
- (void)requestAddModel:(ABChargeModel *)model;

///请求删除
- (void)requestRemoveIndex:(NSInteger)index;

- (NSInteger)numberOfItem;

- (ABChargeModel *)modelAtIndex:(NSInteger)index;

@end
