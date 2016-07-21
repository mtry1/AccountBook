//
//  ABSetDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/25.
//  Copyright © 2015年 mtry. All rights reserved.
//

///安全锁
#define ABSetTitleLock NSLocalizedString(@"safe_lock", nil)
///合并iCloud
#define ABSetTitleiCloud NSLocalizedString(@"merge_iCloud_data", nil)
///超过结束时间红色
#define ABSetTitleEndTimeRed NSLocalizedString(@"overtime_red", nil)
///去评价
#define ABSetTitleGoAppraise NSLocalizedString(@"go_appraise", nil)

@interface ABSetDataManager : NSObject

- (NSInteger)numberOfSection;

- (NSInteger)numberOfRowAtSection:(NSInteger)section;

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)boolForTitle:(NSString *)title;

- (void)requestUpdateSwitchStatus:(BOOL)status title:(NSString *)title;

@end
