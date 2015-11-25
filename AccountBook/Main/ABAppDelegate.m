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
#import "MobClick.h"

@interface ABAppDelegate ()

@property (nonatomic, readonly) UIView *backgroudView;

@end

@implementation ABAppDelegate
{
    BOOL _isShowDMPasscode;
}

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
    
    //CoreData安装
    [[ABCoreDataHelper share] setupCoreData];
    
    //弹窗初始化
    [self initSVProgressHUD];
    
    //安全锁
    if([DMPasscode isPasscodeSet])
    {
        [[ABUtils currentShowViewController].navigationController.view addSubview:self.backgroudView];
        [self showDMPasscode];
    }
    
    //友盟统计
    [MobClick startWithAppkey:@"564d8b9667e58eeb6a00283c" reportPolicy:BATCH channelId:nil];
    [MobClick setEncryptEnabled:YES];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if([DMPasscode isPasscodeSet] && !_isShowDMPasscode)
    {
        [[ABUtils currentShowViewController].navigationController.view addSubview:self.backgroudView];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if([DMPasscode isPasscodeSet] && !_isShowDMPasscode)
    {
        [self showDMPasscode];
    }
}

- (void)showDMPasscode
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        DMPasscodeConfig *config = [[DMPasscodeConfig alloc] init];
        config.isShowCloseButton = NO;
        config.backgroundColor = [UIColor colorWithUInt:0xf4f4f4];
        [DMPasscode setConfig:config];
        
        _isShowDMPasscode = YES;
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
                 _isShowDMPasscode = NO;
             }
         }];
    });
}

- (void)initSVProgressHUD
{
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

@end
