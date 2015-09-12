//
//  UIImage+Category.m
//  BookReader
//
//  Created by zhourongqing on 15/6/13.
//  Copyright (c) 2015年 zhourongqing. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

+ (UIImage *)imageWithResourceName:(NSString *)name
{
    CGFloat scale = [UIScreen mainScreen].scale;
    if(scale > 1)
    {
        name = [NSString stringWithFormat:@"%@@%dx.png", name, (int)scale];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    if(!path)
    {
        path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    }
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self imageWithData:data scale:scale];
}

@end
