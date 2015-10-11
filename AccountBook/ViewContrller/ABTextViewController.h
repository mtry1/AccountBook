//
//  ABTextViewController.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/11.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABViewController.h"

@class ABTextViewController;

@protocol ABTextViewControllerDelegate <NSObject>

- (void)textViewController:(ABTextViewController *)controller didFinishedText:(NSString *)text;

@end

@interface ABTextViewController : ABViewController

@property (nonatomic, weak) id<ABTextViewControllerDelegate>delegate;

@property (nonatomic, readonly) UITextView *textView;

@end
