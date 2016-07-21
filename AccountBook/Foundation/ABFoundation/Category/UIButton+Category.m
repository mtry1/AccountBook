//
//  UIButton+Category.m
//  AccountBook
//
//  Created by zhourongqing on 15/12/14.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)

- (void)alignTitleAndImageWithSpace:(CGFloat)spacing
{
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(- (imageSize.height + spacing), - imageSize.width, 0.0, 0.0);
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, - (titleSize.height + spacing), - titleSize.width);
}

- (void)alignImageAndTitleWithSpace:(CGFloat)spacing
{
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

@end
