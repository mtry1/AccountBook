//
//  ABDefine.h
//  AccountBook
//
//  Created by zhourongqing on 15/9/12.
//  Copyright (c) 2015年 mtry. All rights reserved.
//

#ifndef AccountBook_ABDefine_h
#define AccountBook_ABDefine_h

///超过结束时间红色字体
#define ABUserDefaultKeyOutEndTimeRed @"ABUserDefaultKeyOutEndTimeRed"

///是否iPad
#define ABIsiPad [[UIDevice currentDevice] userInterfaceIdiom]

#ifdef DEBUG
#define LogPoint(p) NSLog(@"%s [Line %d]:%f,%f";__PRETTY_FUNCTION__, __LINE__,p.x, p.y)
#define LogSize(p) NSLog(@"%s [Line %d]:%f,%f", __PRETTY_FUNCTION__, __LINE__,p.width, p.height)
#define LogRect(p) NSLog(@"%s [Line %d]:%f,%f,%f,%f",__PRETTY_FUNCTION__, __LINE__,p.origin.x, p.origin.y, p.size.width, p.size.height)
#define Log(fmt, ...) NSLog((@"%s [Line %d]: " fmt),__PRETTY_FUNCTION__, __LINE__,##__VA_ARGS__)
#define LogObj(o) NSLog(@"%s [Line %d]:%@",__PRETTY_FUNCTION__, __LINE__,[o debugDescription])
#else
#define LogPoint(p)
#define LogSize(p)
#define LogRect(p)
#define Log(fmt, ...)
#define LogObj(o)
#define NSLog(...)
#endif

#endif
