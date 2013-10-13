// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stamp.h instead.

#import <CoreData/CoreData.h>


extern const struct StampAttributes {
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *issueDate;
	__unsafe_unretained NSString *ordering;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *year;
} StampAttributes;

extern const struct StampRelationships {
} StampRelationships;

extern const struct StampFetchedProperties {
} StampFetchedProperties;








@interface StampID : NSManagedObjectID {}
@end

@interface _Stamp : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (StampID*)objectID;





@property (nonatomic, strong) NSString* image;



//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;





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






@end

@interface _Stamp (CoreDataGeneratedAccessors)

@end

@interface _Stamp (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveImage;
- (void)setPrimitiveImage:(NSString*)value;




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




@end
