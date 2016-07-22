//
//  ABCoreDataHelper.h
//  AccountBook
//
//  Created by zhourongqing on 15/10/16.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ABCoreDataHelper : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) NSManagedObjectContext *context;

@property (nonatomic, readonly) NSManagedObjectModel *model;

@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;

@property (nonatomic, readonly) NSPersistentStore *store;

- (void)setupCoreData;

- (BOOL)saveContext;

@end
