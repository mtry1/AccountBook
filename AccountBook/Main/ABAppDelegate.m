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
#import "DMPasscodeInternalViewController.h"

@interface ABAppDelegate ()

@property (nonatomic, readonly) UIView *backgroudView;

@end

@implementation ABAppDelegate

@synthesize backgroudView = _backgroudView;

- (UIView *)backgroudView
{
    if(!_backgroudView)
    {
        _backgroudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroudView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroudView;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[ABNavigationController alloc] initWithRootViewController:[[ABCategoryViewController alloc] init]];
    
    [[ABCoreDataHelper share] setupCoreData];
    
    [self initSVProgressHUD];
    
    [self showDMPasscode];
    
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
        
        [[ABUtils currentShowViewController].navigationController.view addSubview:self.backgroudView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            DMPasscodeConfig *config = [[DMPasscodeConfig alloc] init];
            config.isShowCloseButton = NO;
            [DMPasscode setConfig:config];
            
            isShowing = YES;
            [DMPasscode showPasscodeInViewController:[ABUtils currentShowViewController]
                                            animated:NO
                                    willCloseHandler:^
             {
                 if(self.backgroudView.superview)
                 {
                     [self.backgroudView removeFromSuperview];
                 }
             }completion:^(BOOL success, NSError *error){
                 
                 if(success)
                 {
                     isShowing = NO;
                 }
             }];
        });
    }
}

- (void)initSVProgressHUD
{
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

@end
