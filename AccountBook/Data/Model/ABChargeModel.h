//
//  ABChargeModel.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABModel.h"

@interface ABChargeModel : ABModel

///消费ID
@property (nonatomic, strong) NSString *chargeID;

///消费名称
@property (nonatomic, strong) NSString *title;

///消费金额
@property (nonatomic, strong) NSString *money;

///开始日期
@property (nonatomic, strong) NSDate *startData;

///结束日期
@property (nonatomic, strong) NSDate *endData;

///备注
@property (nonatomic, strong) NSString *remark;

@end
