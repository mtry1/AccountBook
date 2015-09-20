//
//  ABAlertView.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABAlertView.h"

typedef void (^LAAlertViewClickButtonBlock) (UIAlertView* alertView,NSUInteger atIndex);
typedef void (^LAAlertViewWillDissmissBlock)(UIAlertView* alertView,NSUInteger atIndex);
typedef void (^LAAlertViewDidDismissBlock)  (UIAlertView* alertView,NSUInteger atIndex);

@interface ABAlertView()<UIAlertViewDelegate>

@property (nonatomic,strong) LAAlertViewWillDissmissBlock willDismissBlock;
@property (nonatomic,strong) LAAlertViewClickButtonBlock  clickButtonBlock;
@property (nonatomic,strong) LAAlertViewDidDismissBlock   didDissmissBlock;
@property (nonatomic,weak) id<UIAlertViewDelegate> cacheDelegate;

@end

@implementation ABAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if(self)
    {
        va_list args;
        va_start(args,otherButtonTitles);
        if(otherButtonTitles)
        {
            [self addButtonWithTitle:otherButtonTitles];
            NSString *title = nil;
            while ((title = va_arg(args,NSString *)))
            {
                [self addButtonWithTitle:title];
            }
        }
        self.cacheDelegate = delegate;
    }
    return self;
}

- (void)setDelegate:(id)delegate
{
    super.delegate = self;
    self.cacheDelegate = delegate;
}

- (void)showUsingClickButtonBlock:(void (^)(UIAlertView *, NSUInteger))block
{
    self.clickButtonBlock = block;
    
    ///必须在主线程弹出（解决崩溃）
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show];
    });
}

- (void)showUsingWillDismissBlock:(void (^)(UIAlertView *, NSUInteger))block
{
    self.willDismissBlock = block;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show];
    });
}

- (void)showUsingDidDismissBlock:(void (^)(UIAlertView *, NSUInteger))block
{
    self.didDissmissBlock = block;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show];
    });
}

- (void)showUsingWillDismissBlock:(void (^)(UIAlertView *, NSUInteger))willDismissBlock
                 clickButtonBlock:(void (^)(UIAlertView *, NSUInteger))clickButtonBlock
                  didDismissBlock:(void (^)(UIAlertView *, NSUInteger))didDissmissBlock
{
    self.willDismissBlock = willDismissBlock;
    self.clickButtonBlock = clickButtonBlock;
    self.didDissmissBlock = didDissmissBlock;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show];
    });
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(self.willDismissBlock)
    {
        self.willDismissBlock(alertView,buttonIndex);
    }
    else
    {
        if([self.cacheDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
        {
            [self.cacheDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.clickButtonBlock)
    {
        self.clickButtonBlock(alertView,buttonIndex);
    }
    else
    {
        if([self.cacheDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        {
            [self.cacheDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
        }
    }
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(self.didDissmissBlock)
    {
        self.didDissmissBlock(alertView,buttonIndex);
    }
    else
    {
        if([self.cacheDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
        {
            [self.cacheDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
        }
    }
}

@end

