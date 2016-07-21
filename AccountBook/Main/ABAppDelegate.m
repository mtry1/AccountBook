//
//  ABAppDelegate.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/12.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABAppDelegate.h"
#import "ABCategoryViewController.h"
#import "ABCoreDataHelper.h"

@implementation ABAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ABCategoryViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    [[ABCoreDataHelper share] setupCoreData];

    [MTProgressHUD setBackgroudColor:[UIColor blackColor]];
    [MTProgressHUD setForegroudColor:[UIColor whiteColor]];
    [MTProgressHUD setMaskType:MTProgressHUDMaskTypeClear];
    
    return YES;
}

@end
