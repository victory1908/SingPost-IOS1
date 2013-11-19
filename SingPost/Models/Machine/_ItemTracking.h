// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ItemTracking.h instead.

#import <CoreData/CoreData.h>


extern const struct ItemTrackingAttributes {
	__unsafe_unretained NSString *addedOn;
	__unsafe_unretained NSString *destinationCountry;
	__unsafe_unretained NSString *group;
	__unsafe_unretained NSString *originalCountry;
	__unsafe_unretained NSString *trackingNumber;
} ItemTrackingAttributes;

extern const struct ItemTrackingRelationships {
	__unsafe_unretained NSString *deliveryStatuses;
} ItemTrackingRelationships;

extern const struct ItemTrackingFetchedProperties {
} ItemTrackingFetchedProperties;

@class DeliveryStatus;







@interface ItemTrackingID : NSManagedObjectID {}
@end

@interface _ItemTracking : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ItemTrackingID*)objectID;





@property (nonatomic, strong) NSDate* addedOn;



//- (BOOL)validateAddedOn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* destinationCountry;



//- (BOOL)validateDestinationCountry:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* group;



//- (BOOL)validateGroup:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* originalCountry;



//- (BOOL)validateOriginalCountry:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* trackingNumber;



//- (BOOL)validateTrackingNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *deliveryStatuses;

- (NSMutableOrderedSet*)deliveryStatusesSet;





@end

@interface _ItemTracking (CoreDataGeneratedAccessors)

- (void)addDeliveryStatuses:(NSOrderedSet*)value_;
- (void)removeDeliveryStatuses:(NSOrderedSet*)value_;
- (void)addDeliveryStatusesObject:(DeliveryStatus*)value_;
- (void)removeDeliveryStatusesObject:(DeliveryStatus*)value_;

@end

@interface _ItemTracking (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveAddedOn;
- (void)setPrimitiveAddedOn:(NSDate*)value;




- (NSString*)primitiveDestinationCountry;
- (void)setPrimitiveDestinationCountry:(NSString*)value;




- (NSString*)primitiveGroup;
- (void)setPrimitiveGroup:(NSString*)value;




- (NSString*)primitiveOriginalCountry;
- (void)setPrimitiveOriginalCountry:(NSString*)value;




- (NSString*)primitiveTrackingNumber;
- (void)setPrimitiveTrackingNumber:(NSString*)value;





- (NSMutableOrderedSet*)primitiveDeliveryStatuses;
- (void)setPrimitiveDeliveryStatuses:(NSMutableOrderedSet*)value;


@end
