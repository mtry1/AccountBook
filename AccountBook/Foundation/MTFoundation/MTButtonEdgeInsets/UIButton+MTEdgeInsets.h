//
//  UIButton+MTEdgeInsets.h
//  MTButtonEdgeInsetsDemo
//
//  Created by zhourongqing on 16/4/12.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MTEdgeInsets)

///image left and label right
- (void)centerImageLeftAndLabelRightSpacing:(CGFloat)spacing;

///label left and image right
- (void)centerLabelLeftAndImageRightSpacing:(CGFloat)spacing;

///image top and label bottom
- (void)centerImageTopAndLabelBottomSpacing:(CGFloat)spacing;

///label top and image bottom
- (void)centerLabelTopAndImageBottomSpacing:(CGFloat)spacing;

@end
