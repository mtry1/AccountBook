//
//  UIButton+MTEdgeInsets.m
//  MTButtonEdgeInsetsDemo
//
//  Created by zhourongqing on 16/4/12.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import "UIButton+MTEdgeInsets.h"

@implementation UIButton (MTEdgeInsets)

///image left and label right
- (void)centerImageLeftAndLabelRightSpacing:(CGFloat)spacing
{
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
}

///label left and image right
- (void)centerLabelLeftAndImageRightSpacing:(CGFloat)spacing
{
    CGFloat imageWidth = CGRectGetWidth(self.imageView.frame);
    CGFloat labelWidth = CGRectGetWidth(self.titleLabel.frame);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -labelWidth - spacing/2);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - spacing/2, 0, imageWidth + spacing/2);
}

///image top and label bottom
- (void)centerImageTopAndLabelBottomSpacing:(CGFloat)spacing
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize labelSize = self.titleLabel.frame.size;
    CGFloat imageOffsetX = (imageSize.width + labelSize.width)/2 - imageSize.width/2;
    CGFloat imageOffsetY = (imageSize.height + labelSize.height)/2 - imageSize.height/2;
    CGFloat labelOffsetX = (imageSize.width + labelSize.width)/2 - labelSize.width/2;
    CGFloat labelOffsetY = (imageSize.height + labelSize.height)/2 - labelSize.height/2;
    self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY - spacing/2, imageOffsetX, imageOffsetY + spacing/2, -imageOffsetX);
    self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY + spacing/2, -labelOffsetX, -labelOffsetY - spacing/2, labelOffsetX);
}

///label top and image bottom
- (void)centerLabelTopAndImageBottomSpacing:(CGFloat)spacing;
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize labelSize = self.titleLabel.frame.size;
    CGFloat imageOffsetX = (imageSize.width + labelSize.width)/2 - imageSize.width/2;
    CGFloat imageOffsetY = (imageSize.height + labelSize.height)/2 - imageSize.height/2;
    CGFloat labelOffsetX = (imageSize.width + labelSize.width)/2 - labelSize.width/2;
    CGFloat labelOffsetY = (imageSize.height + labelSize.height)/2 - labelSize.height/2;
    self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY + spacing/2, imageOffsetX, -imageOffsetY - spacing/2, -imageOffsetX);
    self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY - spacing/2, -labelOffsetX, +labelOffsetY + spacing/2, labelOffsetX);
}

@end
