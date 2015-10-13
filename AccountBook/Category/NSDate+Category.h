//
//  NSDate+Category.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/13.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

///相差多少年
- (NSDate *)dateSinceDateWithDifferYear:(NSInteger)differYear;

@end
