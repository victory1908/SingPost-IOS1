// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Article.h instead.

#import <CoreData/CoreData.h>


extern const struct ArticleAttributes {
	__unsafe_unretained NSString *buttonType;
	__unsafe_unretained NSString *htmlContent;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *ordering;
	__unsafe_unretained NSString *thumbnail;
	__unsafe_unretained NSString *websiteURL;
} ArticleAttributes;

extern const struct ArticleRelationships {
} ArticleRelationships;

extern const struct ArticleFetchedProperties {
} ArticleFetchedProperties;









@interface ArticleID : NSManagedObjectID {}
@end

@interface _Article : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ArticleID*)objectID;





@property (nonatomic, strong) NSString* buttonType;



//- (BOOL)validateButtonType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* htmlContent;



//- (BOOL)validateHtmlContent:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* ordering;



@property int32_t orderingValue;
- (int32_t)orderingValue;
- (void)setOrderingValue:(int32_t)value_;

//- (BOOL)validateOrdering:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* thumbnail;



//- (BOOL)validateThumbnail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* websiteURL;



//- (BOOL)validateWebsiteURL:(id*)value_ error:(NSError**)error_;






@end

@interface _Article (CoreDataGeneratedAccessors)

@end

@interface _Article (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveButtonType;
- (void)setPrimitiveButtonType:(NSString*)value;




- (NSString*)primitiveHtmlContent;
- (void)setPrimitiveHtmlContent:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveOrdering;
- (void)setPrimitiveOrdering:(NSNumber*)value;

- (int32_t)primitiveOrderingValue;
- (void)setPrimitiveOrderingValue:(int32_t)value_;




- (NSString*)primitiveThumbnail;
- (void)setPrimitiveThumbnail:(NSString*)value;




- (NSString*)primitiveWebsiteURL;
- (void)setPrimitiveWebsiteURL:(NSString*)value;




@end
