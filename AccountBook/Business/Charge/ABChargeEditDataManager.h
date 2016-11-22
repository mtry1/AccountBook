//
//  ABChargeEditDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/11.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABChargeEditModel.h"
#import "ABChargeDataManger.h"

extern NSString *const ABChargeEditStartDate;
extern NSString *const ABChargeEditEndDate;
extern NSString *const ABChargeEditTitle;
extern NSString *const ABChargeEditAmount;
extern NSString *const ABChargeEditNotes;

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
