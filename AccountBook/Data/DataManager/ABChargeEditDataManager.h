//
//  ABChargeEditDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/11.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABDataManager.h"
#import "ABChargeEditModel.h"
#import "ABChargeDataManger.h"

///开始日期
extern NSString *const ABChargeEditStartDate;
///结束日期
extern NSString *const ABChargeEditEndDate;
///名称
extern NSString *const ABChargeEditTitle;
///额度
extern NSString *const ABChargeEditAmount;
///备注
extern NSString *const ABChargeEditNotes;

@interface ABChargeEditDataManager : ABDataManager

///是否是修改
@property (nonatomic, readonly) BOOL isModify;

- (instancetype)initWithChargeDataManger:(ABChargeDataManger *)chargeDataManager index:(NSInteger)index;

- (NSInteger)numberSection;

- (NSInteger)numberOfRowAtSection:(NSInteger)section;

- (ABChargeEditModel *)dataAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)finishEdited;

@end
