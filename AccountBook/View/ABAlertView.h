//
//  ABAlertView.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/20.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABAlertView : UIAlertView

- (void)showUsingClickButtonBlock:(void (^)(UIAlertView *alertView, NSUInteger atIndex))block;
- (void)showUsingWillDismissBlock:(void (^)(UIAlertView *alertView, NSUInteger atIndex))block;
- (void)showUsingDidDismissBlock: (void (^)(UIAlertView *alertView, NSUInteger atIndex))block;

- (void)showUsingWillDismissBlock:(void (^)(UIAlertView *alertView, NSUInteger atIndex))willDismissBlock
                 clickButtonBlock:(void (^)(UIAlertView *alertView, NSUInteger atIndex))clickButtonBlock
                  didDismissBlock:(void (^)(UIAlertView *alertView, NSUInteger atIndex))didDissmissBlock;

@end
