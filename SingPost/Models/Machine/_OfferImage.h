// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OfferImage.h instead.

#import <CoreData/CoreData.h>


extern const struct OfferImageAttributes {
	__unsafe_unretained NSString *image;
} OfferImageAttributes;

extern const struct OfferImageRelationships {
	__unsafe_unretained NSString *offer;
} OfferImageRelationships;

extern const struct OfferImageFetchedProperties {
} OfferImageFetchedProperties;

@class Offer;



@interface OfferImageID : NSManagedObjectID {}
@end

@interface _OfferImage : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OfferImageID*)objectID;





@property (nonatomic, strong) NSString* image;



//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Offer *offer;

//- (BOOL)validateOffer:(id*)value_ error:(NSError**)error_;





@end

@interface _OfferImage (CoreDataGeneratedAccessors)

@end

@interface _OfferImage (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveImage;
- (void)setPrimitiveImage:(NSString*)value;





- (Offer*)primitiveOffer;
- (void)setPrimitiveOffer:(Offer*)value;


@end
