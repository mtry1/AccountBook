//
//  ABChargeEditDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/11.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABChargeEditModel.h"
#import "ABChargeDataManger.h"

///开始日期
#define ABChargeEditStartDate NSLocalizedString(@"sta_date", nil)
///结束日期
#define ABChargeEditEndDate NSLocalizedString(@"end_date", nil)
///名称
#define ABChargeEditTitle NSLocalizedString(@"name", nil)
///额度
#define ABChargeEditAmount NSLocalizedString(@"amount", nil)
///备注
#define ABChargeEditNotes NSLocalizedString(@"notes", nil)

@class ABChargeEditDataManager;

@protocol ABChargeEditDataManagerDelegate <NSObject>

- (void)chargeEditDataManager:(ABChargeEditDataManager *)manager infoMessge:(NSString *)message;

@end

@interface ABChargeEditDataManager : NSObject

@property (nonatomic, weak) id<ABChargeEditDataManagerDelegate>delegate;

///是否是修改
@property (nonatomic, readonly) BOOL isModify;

- (instancetype)initWithChargeDataManger:(ABChargeDataManger *)chargeDataManager index:(NSInteger)index;

- (NSInteger)numberSection;

- (NSInteger)numberOfRowAtSection:(NSInteger)section;

- (ABChargeEditModel *)dataAtIndexPath:(NSIndexPath *)indexPath;

- (ABChargeEditModel *)dataForTitle:(NSString *)title;

- (BOOL)finishEdited;

@end
