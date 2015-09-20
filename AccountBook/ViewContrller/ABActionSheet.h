//
//  ABActionSheet.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABActionSheet : UIActionSheet

- (void)showInView:(UIView *)view clickButtonBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))block;
- (void)showInView:(UIView *)view willDismissBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))block;
- (void)showInView:(UIView *)view didDismissBlock: (void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))block;

- (void)showInView:(UIView *)view
  willDismissBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))willDismissBlock
  clickButtonBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))clickButtonBlock
   didDismissBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))didDissmissBlock;


@end
