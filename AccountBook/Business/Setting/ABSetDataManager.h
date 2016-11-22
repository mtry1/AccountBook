//
//  ABSetDataManager.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/25.
//  Copyright © 2015年 mtry. All rights reserved.
//

extern NSString *const ABSetTitleLock;
extern NSString *const ABSetTitleiCloud;
extern NSString *const ABSetTitleEndTimeRed;
extern NSString *const ABSetTitleGoAppraise;

@interface ABSetDataManager : NSObject

- (NSInteger)numberOfSection;

- (NSInteger)numberOfRowAtSection:(NSInteger)section;

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)boolForTitle:(NSString *)title;

- (void)requestUpdateSwitchStatus:(BOOL)status title:(NSString *)title;

@end
