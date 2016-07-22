//
//  ABSetDataManager.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/25.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABSetDataManager.h"
#import "ABPasscodeHelper.h"

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
                      @[ABSetTitleGoAppraise],
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
        return [ABPasscodeHelper isPasscodeSet];
    }
    else if([title isEqualToString:ABSetTitleEndTimeRed])
    {
        if(![[NSUserDefaults standardUserDefaults] objectForKey:ABUserDefaultKeyOutEndTimeRed])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:ABUserDefaultKeyOutEndTimeRed];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        return [[[NSUserDefaults standardUserDefaults] objectForKey:ABUserDefaultKeyOutEndTimeRed] boolValue];
    }
    return NO;
}

- (void)requestUpdateSwitchStatus:(BOOL)status title:(NSString *)title
{
    if([title isEqualToString:ABSetTitleEndTimeRed])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(status) forKey:ABUserDefaultKeyOutEndTimeRed];
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
