//
//  ABPasscodeHelper.m
//  AccountBook
//
//  Created by zhourongqing on 16/7/21.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABPasscodeHelper.h"
#import "DMPasscode.h"
#import "DMPasscodeInternalViewController.h"

static BOOL isShowDMPasscode;

@implementation ABPasscodeHelper

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                          object:nil
                                                           queue:[NSOperationQueue currentQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          [self applicationDidFinishLaunchingWithOptionsNotification];
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                          object:nil
                                                           queue:[NSOperationQueue currentQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          [self applicationDidEnterBackgroundNotification];
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification
                                                          object:nil
                                                           queue:[NSOperationQueue currentQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          [self applicationWillEnterForegroundNotification];
                                                      }];
    });
}

#pragma mark - private

+ (void)applicationDidFinishLaunchingWithOptionsNotification
{
    if([DMPasscode isPasscodeSet])
    {
        [[ABUtils currentShowViewController].navigationController.view addSubview:[self maskView]];
        [self showDMPasscode];
    }
}

+ (void)applicationDidEnterBackgroundNotification
{
    if([DMPasscode isPasscodeSet] && !isShowDMPasscode)
    {
        UIViewController *currentViewController = [ABUtils currentShowViewController];
        if([currentViewController isKindOfClass:[UIAlertController class]] ||
           [currentViewController isKindOfClass:[DMPasscodeInternalViewController class]])
        {
            [currentViewController dismissViewControllerAnimated:NO completion:^{
                [[ABUtils currentShowViewController].navigationController.view addSubview:[self maskView]];
            }];
        }
        else
        {
            [currentViewController.navigationController.view addSubview:[self maskView]];
        }
    }
}

+ (void)applicationWillEnterForegroundNotification
{
    if([DMPasscode isPasscodeSet] && !isShowDMPasscode)
    {
        [self showDMPasscode];
    }
}

+ (void)showDMPasscode
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DMPasscodeConfig *config = [[DMPasscodeConfig alloc] init];
        config.isShowCloseButton = NO;
        config.backgroundColor = [UIColor colorWithUInt:0xf4f4f4];
        [DMPasscode setConfig:config];
        
        isShowDMPasscode = YES;
        [DMPasscode showPasscodeInViewController:[ABUtils currentShowViewController]
                                        animated:NO
                                willCloseHandler:^
         {
             if([self maskView].superview)
             {
                 [[self maskView] removeFromSuperview];
             }
         }completion:^(BOOL success, NSError *error){
             if(success)
             {
                 isShowDMPasscode = NO;
             }
         }];
    });
}

+ (UIView *)maskView
{
    static UIView *maskView = nil;
    if(!maskView)
    {
        maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        maskView.backgroundColor = [UIColor whiteColor];
    }
    return maskView;
}

#pragma mark - public

+ (BOOL)isPasscodeSet
{
    return [DMPasscode isPasscodeSet];
}

+ (void)setupPasscodeCompleteHandler:(void(^)(BOOL success))completeHandler
{
    DMPasscodeConfig *config = [[DMPasscodeConfig alloc] init];
    config.isShowCloseButton = YES;
    config.backgroundColor = ABDefaultBackgroudColor;
    [DMPasscode setConfig:config];
    
    [DMPasscode setupPasscodeInViewController:[ABUtils currentShowViewController]
                                     animated:YES
                             willCloseHandler:nil
                                   completion:^(BOOL success, NSError *error){
                                       completeHandler(success);
     }];
}

+ (void)showPasscodeCompleteHandler:(void(^)(BOOL success))completeHandler
{
    DMPasscodeConfig *config = [[DMPasscodeConfig alloc] init];
    config.isShowCloseButton = YES;
    config.backgroundColor = ABDefaultBackgroudColor;
    [DMPasscode setConfig:config];
    
    [DMPasscode showPasscodeInViewController:[ABUtils currentShowViewController]
                                    animated:YES
                            willCloseHandler:nil
                                  completion:^(BOOL success, NSError *error){
                                      if(success)
                                      {
                                          [DMPasscode removePasscode];
                                      }
                                      completeHandler(success);
     }];
}

@end