//
//  UIButton+Category.h
//  AccountBook
//
//  Created by zhourongqing on 15/12/14.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)

///上标题下图片，垂直对齐
- (void)alignTitleAndImageWithSpace:(CGFloat)spacing;

///上图片下标题，垂直对齐
- (void)alignImageAndTitleWithSpace:(CGFloat)spacing;

@end
