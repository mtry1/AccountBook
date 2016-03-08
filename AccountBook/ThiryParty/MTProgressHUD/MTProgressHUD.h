//
//  MTProgressHUD.h
//  MTProgressHUDDemo
//
//  Created by zhourongqing on 16/1/27.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MTProgressHUDWillShowNotification;
extern NSString *const MTProgressHUDDidShowNotification;
extern NSString *const MTProgressHUDWillCloseNotification;
extern NSString *const MTProgressHUDDidCloseNotification;

typedef NS_ENUM(NSInteger, MTProgressHUDMaskType)
{
    MTProgressHUDMaskTypeNone = 1,
    MTProgressHUDMaskTypeClear,
    MTProgressHUDMaskTypeBlack,
};

@interface MTProgressHUD : UIView

+ (void)setBackgroudColor:(UIColor *)color;
+ (void)setForegroudColor:(UIColor *)color;
+ (void)setFont:(UIFont *)font;
+ (void)setInfoImage:(UIImage *)image;                //image size 24*24(point)
+ (void)setErrorImage:(UIImage *)image;               //image size 24*24(point)
+ (void)setSuccessImage:(UIImage *)image;             //image size 24*24(point)
+ (void)setMaskType:(MTProgressHUDMaskType)maskType;

+ (void)showInfoWithMessage:(NSString *)message;
+ (void)showInfoWithMessage:(NSString *)message inView:(UIView *)inView;

+ (void)showErrorWithMessge:(NSString *)message;
+ (void)showErrorWithMessge:(NSString *)message inView:(UIView *)inView;

+ (void)showSuccessWithMessage:(NSString *)message;
+ (void)showSuccessWithMessage:(NSString *)message inView:(UIView *)inView;

+ (void)showLoadingWithMessage:(NSString *)message;
+ (void)showLoadingWithMessage:(NSString *)message inView:(UIView *)inView;

+ (void)showCustomWithMessage:(NSString *)message image:(UIImage *)image;                         //image size 24*24(point)
+ (void)showCustomWithMessage:(NSString *)message image:(UIImage *)image inView:(UIView *)inView; //image size 24*24(point)

+ (void)close;
+ (void)closeInView:(UIView *)inView;

@end
