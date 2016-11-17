// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DeliveryStatus.h instead.

#import <CoreData/CoreData.h>


extern const struct DeliveryStatusAttributes {
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *statusDescription;
} DeliveryStatusAttributes;

extern const struct DeliveryStatusRelationships {
} DeliveryStatusRelationships;

extern const struct DeliveryStatusFetchedProperties {
} DeliveryStatusFetchedProperties;






@interface DeliveryStatusID : NSManagedObjectID {}
@end

@interface _DeliveryStatus : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DeliveryStatusID*)objectID;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* location;



//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* statusDescription;



//- (BOOL)validateStatusDescription:(id*)value_ error:(NSError**)error_;






@end

@interface _DeliveryStatus (CoreDataGeneratedAccessors)

@end

@interface _DeliveryStatus (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;




- (NSString*)primitiveStatusDescription;
- (void)setPrimitiveStatusDescription:(NSString*)value;




@end
