//
//  ABStatisticsView.h
//  CocoaPodsDemo
//
//  Created by zhourongqing on 15/10/14.
//  Copyright © 2015年 duoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABStatisticsView;

@protocol ABStatisticsViewDelegate <NSObject>

- (void)statisticsView:(ABStatisticsView *)statisticsView didSelectStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end

@interface ABStatisticsView : UIView

@property (nonatomic, weak) id<ABStatisticsViewDelegate>delegate;

///默认今天
@property (nonatomic, strong) NSDate *startDate;

///默认今天
@property (nonatomic, strong) NSDate *endDate;

- (void)updateStatisticsAmount:(CGFloat)amount;

@end
