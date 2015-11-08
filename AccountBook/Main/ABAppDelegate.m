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
#import "DMPasscode.h"

@interface ABAppDelegate ()

@end

@implementation ABAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *rootViewController;
    if([DMPasscode isPasscodeSet])
    {
         rootViewController = [[ABViewController alloc] init];
    }
    else
    {
         rootViewController = [[ABNavigationController alloc] initWithRootViewController:[[ABCategoryViewController alloc] init]];
    }
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    [self showDMPasscode];
    
    [self initSVProgressHUD];
    
    [[ABCoreDataHelper share] setupCoreData];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self showDMPasscode];
}

- (void)showDMPasscode
{
    if([DMPasscode isPasscodeSet])
    {
        static BOOL isShowing;
        
        if(isShowing)
        {
            return;
        }
        
        DMPasscodeConfig *config = [[DMPasscodeConfig alloc] init];
        config.isShowCloseButton = NO;
        [DMPasscode setConfig:config];
        
        isShowing = YES;
        [DMPasscode showPasscodeInViewController:self.window.rootViewController
                                        animated:NO
                                      completion:^(BOOL success, NSError *error)
         {
             if(success)
             {
                 isShowing = NO;
                 if(![self.window.rootViewController isKindOfClass:[ABNavigationController class]])
                 {
                     self.window.rootViewController = [[ABNavigationController alloc] initWithRootViewController:[[ABCategoryViewController alloc] init]];
                     
                     self.window.rootViewController.view.alpha = 0;
                     [UIView animateWithDuration:0.2 animations:^{
                         self.window.rootViewController.view.alpha = 1;
                     }];
                 }
             }
         }];
    }
}

- (void)initSVProgressHUD
{
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

@end
