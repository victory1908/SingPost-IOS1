// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to StampImage.h instead.

#import <CoreData/CoreData.h>


extern const struct StampImageAttributes {
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *name;
} StampImageAttributes;

extern const struct StampImageRelationships {
	__unsafe_unretained NSString *stamp;
} StampImageRelationships;

extern const struct StampImageFetchedProperties {
} StampImageFetchedProperties;

@class Stamp;




@interface StampImageID : NSManagedObjectID {}
@end

@interface _StampImage : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (StampImageID*)objectID;





@property (nonatomic, strong) NSString* image;



//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Stamp *stamp;

//- (BOOL)validateStamp:(id*)value_ error:(NSError**)error_;





@end

@interface _StampImage (CoreDataGeneratedAccessors)

@end

@interface _StampImage (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveImage;
- (void)setPrimitiveImage:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (Stamp*)primitiveStamp;
- (void)setPrimitiveStamp:(Stamp*)value;


@end
