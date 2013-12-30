// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ArticleCategory.h instead.

#import <CoreData/CoreData.h>


extern const struct ArticleCategoryAttributes {
	__unsafe_unretained NSString *category;
	__unsafe_unretained NSString *module;
} ArticleCategoryAttributes;

extern const struct ArticleCategoryRelationships {
	__unsafe_unretained NSString *articles;
} ArticleCategoryRelationships;

extern const struct ArticleCategoryFetchedProperties {
} ArticleCategoryFetchedProperties;

@class Article;




@interface ArticleCategoryID : NSManagedObjectID {}
@end

@interface _ArticleCategory : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ArticleCategoryID*)objectID;





@property (nonatomic, strong) NSString* category;



//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* module;



//- (BOOL)validateModule:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *articles;

- (NSMutableOrderedSet*)articlesSet;





@end

@interface _ArticleCategory (CoreDataGeneratedAccessors)

- (void)addArticles:(NSOrderedSet*)value_;
- (void)removeArticles:(NSOrderedSet*)value_;
- (void)addArticlesObject:(Article*)value_;
- (void)removeArticlesObject:(Article*)value_;

@end

@interface _ArticleCategory (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCategory;
- (void)setPrimitiveCategory:(NSString*)value;




- (NSString*)primitiveModule;
- (void)setPrimitiveModule:(NSString*)value;





- (NSMutableOrderedSet*)primitiveArticles;
- (void)setPrimitiveArticles:(NSMutableOrderedSet*)value;


@end
