// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stamp.h instead.

#import <CoreData/CoreData.h>


extern const struct StampAttributes {
	__unsafe_unretained NSString *coverImage;
	__unsafe_unretained NSString *day;
	__unsafe_unretained NSString *details;
	__unsafe_unretained NSString *month;
	__unsafe_unretained NSString *ordering;
	__unsafe_unretained NSString *serverId;
	__unsafe_unretained NSString *thumbnail;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *year;
} StampAttributes;

extern const struct StampRelationships {
	__unsafe_unretained NSString *images;
} StampRelationships;

extern const struct StampFetchedProperties {
} StampFetchedProperties;

@class StampImage;











@interface StampID : NSManagedObjectID {}
@end

@interface _Stamp : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (StampID*)objectID;





@property (nonatomic, strong) NSString* coverImage;



//- (BOOL)validateCoverImage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* day;



//- (BOOL)validateDay:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* details;



//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* month;



//- (BOOL)validateMonth:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* ordering;



@property int32_t orderingValue;
- (int32_t)orderingValue;
- (void)setOrderingValue:(int32_t)value_;

//- (BOOL)validateOrdering:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* serverId;



@property int32_t serverIdValue;
- (int32_t)serverIdValue;
- (void)setServerIdValue:(int32_t)value_;

//- (BOOL)validateServerId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* thumbnail;



//- (BOOL)validateThumbnail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* year;



//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *images;

- (NSMutableOrderedSet*)imagesSet;





@end

@interface _Stamp (CoreDataGeneratedAccessors)

- (void)addImages:(NSOrderedSet*)value_;
- (void)removeImages:(NSOrderedSet*)value_;
- (void)addImagesObject:(StampImage*)value_;
- (void)removeImagesObject:(StampImage*)value_;

@end

@interface _Stamp (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCoverImage;
- (void)setPrimitiveCoverImage:(NSString*)value;




- (NSString*)primitiveDay;
- (void)setPrimitiveDay:(NSString*)value;




- (NSString*)primitiveDetails;
- (void)setPrimitiveDetails:(NSString*)value;




- (NSString*)primitiveMonth;
- (void)setPrimitiveMonth:(NSString*)value;




- (NSNumber*)primitiveOrdering;
- (void)setPrimitiveOrdering:(NSNumber*)value;

- (int32_t)primitiveOrderingValue;
- (void)setPrimitiveOrderingValue:(int32_t)value_;




- (NSNumber*)primitiveServerId;
- (void)setPrimitiveServerId:(NSNumber*)value;

- (int32_t)primitiveServerIdValue;
- (void)setPrimitiveServerIdValue:(int32_t)value_;




- (NSString*)primitiveThumbnail;
- (void)setPrimitiveThumbnail:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveYear;
- (void)setPrimitiveYear:(NSString*)value;





- (NSMutableOrderedSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableOrderedSet*)value;


@end
