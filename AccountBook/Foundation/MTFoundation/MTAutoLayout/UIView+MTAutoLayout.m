//
//  UIView+MTAutoLayout.m
//  MTAutoLayoutDemo
//
//  Created by zhourongqing on 16/1/22.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import "UIView+MTAutoLayout.h"
#import <objc/runtime.h>

@implementation UIView (MTAutoLayout)

- (NSLayoutConstraint *)constraintHeight:(CGFloat)height
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:height];
}

- (NSLayoutConstraint *)constraintWidth:(CGFloat)width
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:width];
}

- (NSLayoutConstraint *)constraintCenterXEqualToView:(UIView *)view
{
    return [self constraintCenterXEqualToView:view offsetX:0];
}

- (NSLayoutConstraint *)constraintCenterXEqualToView:(UIView *)view offsetX:(CGFloat)offsetX
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:offsetX];
}

- (NSLayoutConstraint *)constraintCenterYEqualToView:(UIView *)view
{
    return [self constraintCenterYEqualToView:view offsetY:0];
}

- (NSLayoutConstraint *)constraintCenterYEqualToView:(UIView *)view offsetY:(CGFloat)offsetY
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:offsetY];
}

- (NSLayoutConstraint *)constraintHeightEqualToView:(UIView *)view
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
}

- (NSLayoutConstraint *)constraintWidthEqualToView:(UIView *)view
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
}

- (NSArray *)constraintsTop:(CGFloat)top fromView:(UIView *)view
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-(top)-[selfView]" options:0 metrics:@{@"top":@(top)} views:NSDictionaryOfVariableBindings(view, selfView)];
}

- (NSArray *)constraintsBottom:(CGFloat)bottom fromView:(UIView *)view
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:[selfView]-(bottom)-[view]" options:0 metrics:@{@"bottom":@(bottom)} views:NSDictionaryOfVariableBindings(selfView, view)];
}

- (NSArray *)constraintsLeft:(CGFloat)left fromView:(UIView *)view
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:[selfView]-(left)-[view]" options:0 metrics:@{@"left":@(left)} views:NSDictionaryOfVariableBindings(selfView, view)];
}

- (NSArray *)constraintsRight:(CGFloat)right fromView:(UIView *)view
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-(right)-[selfView]" options:0 metrics:@{@"right":@(right)} views:NSDictionaryOfVariableBindings(view, selfView)];
}

- (NSArray *)constraintsSizeEqualToView:(UIView *)view
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return @[
             [self constraintHeightEqualToView:view],
             [self constraintWidthEqualToView:view]
             ];
}

- (NSArray *)constraintsSize:(CGSize)size
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return @[
             [self constraintHeight:size.height],
             [self constraintWidth:size.width]
             ];
}

- (NSArray *)constraintsFillWidth
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[selfView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selfView)];
}

- (NSArray *)constraintsFillHeight
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[selfView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selfView)];
}

- (NSArray *)constraintsFill
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *resultConstraints = [[NSMutableArray alloc] initWithArray:[self constraintsFillWidth]];
    [resultConstraints addObjectsFromArray:[self constraintsFillHeight]];
    return [NSArray arrayWithArray:resultConstraints];
}

- (NSArray *)constraintsAssignLeft
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [self constraintsLeftInContainer:0];
}

- (NSArray *)constraintsAssignRight
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [self constraintsRightInContainer:0];
}

- (NSArray *)constraintsAssignTop
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [self constraintsTopInContainer:0];
}

- (NSArray *)constraintsAssignBottom
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [self constraintsBottomInContainer:0];
}

- (NSArray *)constraintsTopInContainer:(CGFloat)top
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[selfView]" options:0 metrics:@{@"top":@(top)} views:NSDictionaryOfVariableBindings(selfView)];
}

- (NSArray *)constraintsBottomInContainer:(CGFloat)bottom
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:[selfView]-(bottom)-|" options:0 metrics:@{@"bottom":@(bottom)} views:NSDictionaryOfVariableBindings(selfView)];
}

- (NSArray *)constraintsLeftInContainer:(CGFloat)left
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[selfView]" options:0 metrics:@{@"left":@(left)} views:NSDictionaryOfVariableBindings(selfView)];
}

- (NSArray *)constraintsRightInContainer:(CGFloat)right
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:[selfView]-(right)-|" options:0 metrics:@{@"right":@(right)} views:NSDictionaryOfVariableBindings(selfView)];
}

- (NSLayoutConstraint *)constraintTopEqualToView:(UIView *)view
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
}

- (NSLayoutConstraint *)constraintBottomEqualToView:(UIView *)view
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
}

- (NSLayoutConstraint *)constraintLeftEqualToView:(UIView *)view
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
}

- (NSLayoutConstraint *)constraintRightEqualToView:(UIView *)view
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
}

@end



NSString *const MTAutoLayoutConstraintsKey = @"MTAutoLayoutConstraintsKey";

@implementation UIView (MTCustomConstraints)

- (NSMutableArray *)customConstraints
{
    NSMutableArray *result = objc_getAssociatedObject(self, &MTAutoLayoutConstraintsKey);
    if(!result)
    {
        result = [NSMutableArray array];
        self.customConstraints = result;
    }
    return result;
}

- (void)setCustomConstraints:(NSMutableArray *)customConstraints
{
    objc_setAssociatedObject(self, &MTAutoLayoutConstraintsKey, customConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
