//
//  ABChargeModel.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABSyncProtocol.h"

@interface ABChargeModel : NSObject<ABSyncProtocol, NSCopying>

///分类ID
@property (nonatomic, strong) NSString *categoryID;
///消费ID
@property (nonatomic, strong) NSString *chargeID;
///消费名称
@property (nonatomic, strong) NSString *title;
///消费金额
@property (nonatomic) CGFloat amount;
///开始日期
@property (nonatomic) NSTimeInterval startTimeInterval;
///结束日期
@property (nonatomic) NSTimeInterval endTimeInterval;
///备注
@property (nonatomic, strong) NSString *notes;
///是否已经超过指定时间
@property (nonatomic, readonly) BOOL isTimeOut;

@end
