// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Offer.h instead.

#import <CoreData/CoreData.h>


extern const struct OfferAttributes {
	__unsafe_unretained NSString *details;
	__unsafe_unretained NSString *offerDate;
	__unsafe_unretained NSString *ordering;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *year;
} OfferAttributes;

extern const struct OfferRelationships {
	__unsafe_unretained NSString *images;
} OfferRelationships;

extern const struct OfferFetchedProperties {
} OfferFetchedProperties;

@class OfferImage;







@interface OfferID : NSManagedObjectID {}
@end

@interface _Offer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OfferID*)objectID;





@property (nonatomic, strong) NSString* details;



//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* offerDate;



//- (BOOL)validateOfferDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* ordering;



@property int32_t orderingValue;
- (int32_t)orderingValue;
- (void)setOrderingValue:(int32_t)value_;

//- (BOOL)validateOrdering:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* year;



//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *images;

- (NSMutableOrderedSet*)imagesSet;





@end

@interface _Offer (CoreDataGeneratedAccessors)

- (void)addImages:(NSOrderedSet*)value_;
- (void)removeImages:(NSOrderedSet*)value_;
- (void)addImagesObject:(OfferImage*)value_;
- (void)removeImagesObject:(OfferImage*)value_;

@end

@interface _Offer (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDetails;
- (void)setPrimitiveDetails:(NSString*)value;




- (NSDate*)primitiveOfferDate;
- (void)setPrimitiveOfferDate:(NSDate*)value;




- (NSNumber*)primitiveOrdering;
- (void)setPrimitiveOrdering:(NSNumber*)value;

- (int32_t)primitiveOrderingValue;
- (void)setPrimitiveOrderingValue:(int32_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveYear;
- (void)setPrimitiveYear:(NSString*)value;





- (NSMutableOrderedSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableOrderedSet*)value;


@end
