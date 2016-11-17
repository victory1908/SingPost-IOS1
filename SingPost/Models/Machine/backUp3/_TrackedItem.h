// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TrackedItem.h instead.

#import <CoreData/CoreData.h>


extern const struct TrackedItemAttributes {
	__unsafe_unretained NSString *addedOn;
	__unsafe_unretained NSString *destinationCountry;
	__unsafe_unretained NSString *isActive;
	__unsafe_unretained NSString *isFound;
	__unsafe_unretained NSString *isRead;
	__unsafe_unretained NSString *lastUpdatedOn;
	__unsafe_unretained NSString *originalCountry;
	__unsafe_unretained NSString *trackingNumber;
} TrackedItemAttributes;

extern const struct TrackedItemRelationships {
	__unsafe_unretained NSString *deliveryStatuses;
} TrackedItemRelationships;

extern const struct TrackedItemFetchedProperties {
} TrackedItemFetchedProperties;

@class DeliveryStatus;










@interface TrackedItemID : NSManagedObjectID {}
@end

@interface _TrackedItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TrackedItemID*)objectID;





@property (nonatomic, strong) NSDate* addedOn;



//- (BOOL)validateAddedOn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* destinationCountry;



//- (BOOL)validateDestinationCountry:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* isActive;



//- (BOOL)validateIsActive:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isFound;



@property BOOL isFoundValue;
- (BOOL)isFoundValue;
- (void)setIsFoundValue:(BOOL)value_;

//- (BOOL)validateIsFound:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isRead;



@property BOOL isReadValue;
- (BOOL)isReadValue;
- (void)setIsReadValue:(BOOL)value_;

//- (BOOL)validateIsRead:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastUpdatedOn;



//- (BOOL)validateLastUpdatedOn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* originalCountry;



//- (BOOL)validateOriginalCountry:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* trackingNumber;



//- (BOOL)validateTrackingNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *deliveryStatuses;

- (NSMutableOrderedSet*)deliveryStatusesSet;





@end

@interface _TrackedItem (CoreDataGeneratedAccessors)

- (void)addDeliveryStatuses:(NSOrderedSet*)value_;
- (void)removeDeliveryStatuses:(NSOrderedSet*)value_;
- (void)addDeliveryStatusesObject:(DeliveryStatus*)value_;
- (void)removeDeliveryStatusesObject:(DeliveryStatus*)value_;

@end

@interface _TrackedItem (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveAddedOn;
- (void)setPrimitiveAddedOn:(NSDate*)value;




- (NSString*)primitiveDestinationCountry;
- (void)setPrimitiveDestinationCountry:(NSString*)value;




- (NSString*)primitiveIsActive;
- (void)setPrimitiveIsActive:(NSString*)value;




- (NSNumber*)primitiveIsFound;
- (void)setPrimitiveIsFound:(NSNumber*)value;

- (BOOL)primitiveIsFoundValue;
- (void)setPrimitiveIsFoundValue:(BOOL)value_;




- (NSNumber*)primitiveIsRead;
- (void)setPrimitiveIsRead:(NSNumber*)value;

- (BOOL)primitiveIsReadValue;
- (void)setPrimitiveIsReadValue:(BOOL)value_;




- (NSDate*)primitiveLastUpdatedOn;
- (void)setPrimitiveLastUpdatedOn:(NSDate*)value;




- (NSString*)primitiveOriginalCountry;
- (void)setPrimitiveOriginalCountry:(NSString*)value;




- (NSString*)primitiveTrackingNumber;
- (void)setPrimitiveTrackingNumber:(NSString*)value;





- (NSMutableOrderedSet*)primitiveDeliveryStatuses;
- (void)setPrimitiveDeliveryStatuses:(NSMutableOrderedSet*)value;


@end
