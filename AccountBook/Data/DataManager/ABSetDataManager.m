//
//  ABSetDataManager.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/25.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABSetDataManager.h"

NSString *const ABSetTitleLock = @"安全锁";
NSString *const ABSetTitleiCloud = @"合并iCloud";
NSString *const ABSetTitleEndTimeRed = @"关闭超过结束时间红色显示";

@interface ABSetDataManager ()

@property (nonatomic, strong) NSArray *listItem;

@end

@implementation ABSetDataManager

- (NSArray *)listItem
{
    if(!_listItem)
    {
        _listItem = @[
                      @[ABSetTitleLock,
                        ABSetTitleEndTimeRed],
                      @[ABSetTitleiCloud],
                      ];
    }
    return _listItem;
}

- (NSInteger)numberOfSection
{
    return self.listItem.count;
}

- (NSInteger)numberOfRowAtSection:(NSInteger)section;
{
    if(section < self.numberOfSection)
    {
        NSArray *array = self.listItem[section];
        if([array isKindOfClass:[NSArray class]])
        {
            return array.count;
        }
    }
    return 0;
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.numberOfSection)
    {
        NSArray *array = self.listItem[indexPath.section];
        if(indexPath.row < array.count)
        {
            return array[indexPath.row];
        }
    }
    return nil;
}

- (BOOL)boolForTitle:(NSString *)title
{
    if([title isEqualToString:ABSetTitleLock])
    {
        if(![[NSUserDefaults standardUserDefaults] objectForKey:ABUserDefaultKeySafeLock])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:ABUserDefaultKeySafeLock];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        return [[[NSUserDefaults standardUserDefaults] objectForKey:ABUserDefaultKeySafeLock] boolValue];
    }
    else if([title isEqualToString:ABSetTitleEndTimeRed])
    {
        if(![[NSUserDefaults standardUserDefaults] objectForKey:ABSetTitleEndTimeRed])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:ABSetTitleEndTimeRed];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        return [[[NSUserDefaults standardUserDefaults] objectForKey:ABSetTitleEndTimeRed] boolValue];
    }
    return NO;
}

- (void)requestUpdateSwitchStatus:(BOOL)status title:(NSString *)title
{
    if([title isEqualToString:ABSetTitleLock])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(status) forKey:ABUserDefaultKeySafeLock];
    }
    else if([title isEqualToString:ABSetTitleEndTimeRed])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(status) forKey:ABSetTitleEndTimeRed];
    }
    
    NSIndexPath *indexPath = [self indexPathForTitle:title];
    if(indexPath)
    {
        [self.callBackUtils callBackAction:@selector(dataManager:updateIndexPath:) object1:self object2:indexPath];
    }
}

- (NSIndexPath *)indexPathForTitle:(NSString *)title
{
    for(NSInteger section = 0; section < self.numberOfSection; section++)
    {
        NSArray *array = self.listItem[section];
        for(NSInteger row = 0; row < array.count; row++)
        {
            if([title isEqualToString:array[row]])
            {
                return [NSIndexPath indexPathForRow:row inSection:section];
            }
        }
    }
    return nil;
}

@end