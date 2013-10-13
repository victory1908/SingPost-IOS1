// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stamp.h instead.

#import <CoreData/CoreData.h>


extern const struct StampAttributes {
	__unsafe_unretained NSString *details;
	__unsafe_unretained NSString *issueDate;
	__unsafe_unretained NSString *ordering;
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





@property (nonatomic, strong) NSString* details;



//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* issueDate;



//- (BOOL)validateIssueDate:(id*)value_ error:(NSError**)error_;





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

@interface _Stamp (CoreDataGeneratedAccessors)

- (void)addImages:(NSOrderedSet*)value_;
- (void)removeImages:(NSOrderedSet*)value_;
- (void)addImagesObject:(StampImage*)value_;
- (void)removeImagesObject:(StampImage*)value_;

@end

@interface _Stamp (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDetails;
- (void)setPrimitiveDetails:(NSString*)value;




- (NSDate*)primitiveIssueDate;
- (void)setPrimitiveIssueDate:(NSDate*)value;




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
