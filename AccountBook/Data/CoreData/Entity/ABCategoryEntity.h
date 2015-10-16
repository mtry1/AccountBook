//
//  ABCategoryEntity.h
//  
//
//  Created by zhourongqing on 15/10/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABCategoryEntity : NSManagedObject

@property (nullable, nonatomic, retain) NSString *categoryId;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *colorHexString;
@property (nullable, nonatomic, retain) NSNumber *isExistCloud;
@property (nullable, nonatomic, retain) NSNumber *isRemoved;

@end

NS_ASSUME_NONNULL_END
