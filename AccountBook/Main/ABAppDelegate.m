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

@interface ABAppDelegate ()

@end

@implementation ABAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ABNavigationController *mainViewController = [[ABNavigationController alloc] initWithRootViewController:[[ABCategoryViewController alloc] init]];
    self.window.rootViewController = mainViewController;
    [self.window makeKeyAndVisible];
    
    [self initSVProgressHUD];
    
    [[ABCoreDataHelper share] setupCoreData];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[ABCoreDataHelper share] saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[ABCoreDataHelper share] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}


- (void)initSVProgressHUD
{
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

@end
