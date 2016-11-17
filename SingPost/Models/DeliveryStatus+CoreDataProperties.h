//
//  DeliveryStatus+CoreDataProperties.h
//  
//
//  Created by Le Khanh Vinh on 16/11/16.
//
//

#import "DeliveryStatus+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DeliveryStatus (CoreDataProperties)

+ (NSFetchRequest<DeliveryStatus *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *location;
@property (nullable, nonatomic, copy) NSString *statusDescription;
@property (nullable, nonatomic, retain) TrackedItem *trackItem;

@end

NS_ASSUME_NONNULL_END
