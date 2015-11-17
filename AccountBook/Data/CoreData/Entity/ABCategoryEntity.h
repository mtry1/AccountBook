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

@property (nullable, nonatomic, retain) NSString *categoryID;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *colorHexString;
@property (nullable, nonatomic, retain) NSNumber *isExistCloud;
@property (nullable, nonatomic, retain) NSNumber *isRemoved;
@property (nullable, nonatomic, retain) NSNumber *modifyTime;

@end

NS_ASSUME_NONNULL_END
