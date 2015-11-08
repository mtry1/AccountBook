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
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[ABNavigationController alloc] initWithRootViewController:[[ABCategoryViewController alloc] init]];
    
    [self showDMPasscode:YES];
    
    [self initSVProgressHUD];
    
    [[ABCoreDataHelper share] setupCoreData];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self showDMPasscode:NO];
}

- (void)showDMPasscode:(BOOL)isNeedBackgroudView
{
    if([DMPasscode isPasscodeSet])
    {
        UIView *backgroudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        if(isNeedBackgroudView)
        {
            backgroudView.backgroundColor = [UIColor whiteColor];
            
            ABNavigationController *navigation = (ABNavigationController *)self.window.rootViewController;
            [navigation.topViewController.navigationController.view addSubview:backgroudView];
        }
        
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
                                willCloseHandler:^
        {
            if(isNeedBackgroudView)
            {
                [backgroudView removeFromSuperview];
            }
        }completion:^(BOOL success, NSError *error){
            
             if(success)
             {
                 isShowing = NO;
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
