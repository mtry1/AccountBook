//
//  UIView+MTAutoLayout.h
//  MTAutoLayoutDemo
//
//  Created by zhourongqing on 16/1/22.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MTAutoLayout)

- (NSLayoutConstraint *)constraintHeight:(CGFloat)height;
- (NSLayoutConstraint *)constraintHeightEqualToView:(UIView *)view;

- (NSLayoutConstraint *)constraintWidth:(CGFloat)width;
- (NSLayoutConstraint *)constraintWidthEqualToView:(UIView *)view;

- (NSLayoutConstraint *)constraintCenterXEqualToView:(UIView *)view;
- (NSLayoutConstraint *)constraintCenterXEqualToView:(UIView *)view offsetX:(CGFloat)offsetX;
- (NSLayoutConstraint *)constraintCenterYEqualToView:(UIView *)view;
- (NSLayoutConstraint *)constraintCenterYEqualToView:(UIView *)view offsetY:(CGFloat)offsetY;

- (NSArray *)constraintsTop:(CGFloat)top fromView:(UIView *)view;
- (NSArray *)constraintsBottom:(CGFloat)bottom fromView:(UIView *)view;
- (NSArray *)constraintsLeft:(CGFloat)left fromView:(UIView *)view;
- (NSArray *)constraintsRight:(CGFloat)right fromView:(UIView *)view;

- (NSArray *)constraintsTopInContainer:(CGFloat)top;
- (NSArray *)constraintsBottomInContainer:(CGFloat)bottom;
- (NSArray *)constraintsLeftInContainer:(CGFloat)left;
- (NSArray *)constraintsRightInContainer:(CGFloat)right;

- (NSLayoutConstraint *)constraintTopEqualToView:(UIView *)view;
- (NSLayoutConstraint *)constraintBottomEqualToView:(UIView *)view;
- (NSLayoutConstraint *)constraintLeftEqualToView:(UIView *)view;
- (NSLayoutConstraint *)constraintRightEqualToView:(UIView *)view;

- (NSArray *)constraintsSize:(CGSize)size;
- (NSArray *)constraintsSizeEqualToView:(UIView *)view;

- (NSArray *)constraintsFillWidth;
- (NSArray *)constraintsFillHeight;
- (NSArray *)constraintsFill;

- (NSArray *)constraintsAssignLeft;
- (NSArray *)constraintsAssignRight;
- (NSArray *)constraintsAssignTop;
- (NSArray *)constraintsAssignBottom;

@end

@interface UIView (MTCustomConstraints)

@property (nonatomic, readonly) NSMutableArray *customConstraints;

@end