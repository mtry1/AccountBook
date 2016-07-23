//
//  ABCoreDataHelper.m
//  AccountBook
//
//  Created by zhourongqing on 15/10/16.
//  Copyright © 2015年 mtry. All rights reserved.
//

#import "ABCoreDataHelper.h"

NSString *const ABCoreDataHelperFolder = @"CoreData";
NSString *const ABCoreDataHelperFileName = @"CoreData.splite";

@implementation ABCoreDataHelper

@synthesize context = _context;
@synthesize coordinator = _coordinator;
@synthesize model = _model;
@synthesize store = _store;

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                          object:nil
                                                           queue:[NSOperationQueue currentQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          [[ABCoreDataHelper sharedInstance] setupCoreData];
                                                      }];
    });
}

+ (instancetype)sharedInstance
{
    static id shareObject;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareObject = [[[self class] alloc] init];
    });
    return shareObject;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [_context setPersistentStoreCoordinator:_coordinator];
    }
    return self;
}

- (NSURL *)applicationStoresDirectory
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *storesDirectory = [[NSURL fileURLWithPath:documentsDirectory] URLByAppendingPathComponent:ABCoreDataHelperFolder];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[storesDirectory path]])
    {
        NSError *error = nil;
        if(![fileManager createDirectoryAtURL:storesDirectory withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"create directory error: %@", error);
        }
    }
    
    return storesDirectory;
}

- (void)setupCoreData
{
    if(!_store)
    {
        NSURL *storeURL = [[self applicationStoresDirectory] URLByAppendingPathComponent:ABCoreDataHelperFileName];
        
        NSError *error = nil;
        _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                            configuration:nil
                                                      URL:storeURL
                                                  options:nil
                                                    error:&error];
        
        if(error)
        {
            NSLog(@"add store error: %@", error);
        }
    }
}

- (BOOL)saveContext
{
    if([_context hasChanges])
    {
        NSError *error = nil;
        if(![_context save:&error])
        {
            NSLog(@"save error: %@", error);
            return NO;
        }
    }
    return YES;
}

@end
