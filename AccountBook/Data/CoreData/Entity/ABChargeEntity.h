//
//  ABChargeEntity.h
//  
//
//  Created by zhourongqing on 15/10/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABChargeEntity : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *isExistCloud;
@property (nullable, nonatomic, retain) NSNumber *isRemoved;
@property (nullable, nonatomic, retain) NSString *categoryID;
@property (nullable, nonatomic, retain) NSString *chargeID;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSNumber *startTimeInterval;
@property (nullable, nonatomic, retain) NSNumber *endTimeInterval;
@property (nullable, nonatomic, retain) NSString *notes;

@end

NS_ASSUME_NONNULL_END
