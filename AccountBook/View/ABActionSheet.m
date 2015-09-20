//
//  ABActionSheet.m
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import "ABActionSheet.h"

typedef void (^LAActionSheetWillDissmissBlock)(UIActionSheet *actionSheet, NSUInteger buttonIndex);
typedef void (^LAActionSheetClickButtonBlock) (UIActionSheet *actionSheet, NSUInteger buttonIndex);
typedef void (^LAActionSheetDidDismissBlock)  (UIActionSheet *actionSheet, NSUInteger buttonIndex);

@interface ABActionSheet()<UIActionSheetDelegate>

@property (nonatomic,strong) LAActionSheetWillDissmissBlock willDismissBlock;
@property (nonatomic,strong) LAActionSheetClickButtonBlock  clickButtonBlock;
@property (nonatomic,strong) LAActionSheetDidDismissBlock   didDissmissBlock;
@property (nonatomic,weak) id<UIActionSheetDelegate> cacheDelegate;

@end

@implementation ABActionSheet

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
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
        
        if(destructiveButtonTitle)
        {
            self.destructiveButtonIndex = [self addButtonWithTitle:destructiveButtonTitle];
        }
        
        if(cancelButtonTitle)
        {
            self.cancelButtonIndex = [self addButtonWithTitle:cancelButtonTitle];
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



- (void)showInView:(UIView *)view clickButtonBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))block
{
    self.clickButtonBlock = block;
    [self showInView:view];
}

- (void)showInView:(UIView *)view willDismissBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))block
{
    self.willDismissBlock = block;
    [self showInView:view];
}

- (void)showInView:(UIView *)view didDismissBlock: (void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))block
{
    self.didDissmissBlock = block;
    [self showInView:view];
}


- (void)showInView:(UIView *)view
  willDismissBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))willDismissBlock
  clickButtonBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))clickButtonBlock
   didDismissBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))didDissmissBlock
{
    self.willDismissBlock = willDismissBlock;
    self.clickButtonBlock = clickButtonBlock;
    self.didDissmissBlock = didDissmissBlock;
    [self showInView:view];
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(self.willDismissBlock)
    {
        self.willDismissBlock(actionSheet,buttonIndex);
    }
    else
    {
        if([self.cacheDelegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)])
        {
            [self.cacheDelegate actionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.clickButtonBlock)
    {
        self.clickButtonBlock(actionSheet,buttonIndex);
    }
    else
    {
        if([self.cacheDelegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
        {
            [self.cacheDelegate actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(self.didDissmissBlock)
    {
        self.didDissmissBlock(actionSheet,buttonIndex);
    }
    else
    {
        if([self.cacheDelegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)])
        {
            [self.cacheDelegate actionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
        }
    }
}

@end
