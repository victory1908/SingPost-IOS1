//
//  TrackedItem+CoreDataProperties.h
//  
//
//  Created by Le Khanh Vinh on 16/11/16.
//
//  This file was automatically generated and should not be edited.
//

#import "TrackedItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TrackedItem (CoreDataProperties)

+ (NSFetchRequest<TrackedItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *addedOn;
@property (nullable, nonatomic, copy) NSString *destinationCountry;
@property (nullable, nonatomic, copy) NSString *isActive;
@property (nullable, nonatomic, copy) NSNumber *isFound;
@property (nullable, nonatomic, copy) NSNumber *isRead;
@property (nullable, nonatomic, copy) NSDate *lastUpdatedOn;
@property (nullable, nonatomic, copy) NSString *originalCountry;
@property (nullable, nonatomic, copy) NSString *trackingNumber;
@property (nullable, nonatomic, retain) NSOrderedSet<DeliveryStatus *> *deliveryStatuses;

@end

@interface TrackedItem (CoreDataGeneratedAccessors)

- (void)insertObject:(DeliveryStatus *)value inDeliveryStatusesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDeliveryStatusesAtIndex:(NSUInteger)idx;
- (void)insertDeliveryStatuses:(NSArray<DeliveryStatus *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDeliveryStatusesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDeliveryStatusesAtIndex:(NSUInteger)idx withObject:(DeliveryStatus *)value;
- (void)replaceDeliveryStatusesAtIndexes:(NSIndexSet *)indexes withDeliveryStatuses:(NSArray<DeliveryStatus *> *)values;
- (void)addDeliveryStatusesObject:(DeliveryStatus *)value;
- (void)removeDeliveryStatusesObject:(DeliveryStatus *)value;
- (void)addDeliveryStatuses:(NSOrderedSet<DeliveryStatus *> *)values;
- (void)removeDeliveryStatuses:(NSOrderedSet<DeliveryStatus *> *)values;

@end

NS_ASSUME_NONNULL_END
