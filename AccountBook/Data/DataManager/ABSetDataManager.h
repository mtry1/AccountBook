//
//  ABSetDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/25.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABDataManager.h"

///安全锁
extern NSString *const ABSetTitleLock;
///合并iCloud
extern NSString *const ABSetTitleiCloud;
///超过结束时间红色
extern NSString *const ABSetTitleEndTimeRed;

@interface ABSetDataManager : ABDataManager

- (NSInteger)numberOfSection;

- (NSInteger)numberOfRowAtSection:(NSInteger)section;

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)boolForTitle:(NSString *)title;

- (void)requestUpdateSwitchStatus:(BOOL)status title:(NSString *)title;

@end
