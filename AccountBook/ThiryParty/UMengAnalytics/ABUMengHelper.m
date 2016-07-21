//
//  ABUMengHelper.m
//  AccountBook
//
//  Created by zhourongqing on 16/7/21.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABUMengHelper.h"
#import "MobClick.h"

@implementation ABUMengHelper

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                          object:nil
                                                           queue:[NSOperationQueue currentQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          [self configUMengAnalytics];
                                                      }];
    });
}

+ (void)configUMengAnalytics
{
    [MobClick startWithAppkey:@"564d8b9667e58eeb6a00283c" reportPolicy:BATCH channelId:nil];
    [MobClick setEncryptEnabled:YES];
    [MobClick setAppVersion:XcodeAppVersion];
}

@end
