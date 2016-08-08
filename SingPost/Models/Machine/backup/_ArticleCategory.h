//
//  ArticleCategory+CoreDataProperties.h
//  
//
//  Created by Le Khanh Vinh on 6/8/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ArticleCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleCategory

@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *module;
@property (nullable, nonatomic, retain) NSOrderedSet<Article *> *articles;

@end

@interface ArticleCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(Article *)value inArticlesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromArticlesAtIndex:(NSUInteger)idx;
- (void)insertArticles:(NSArray<Article *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeArticlesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInArticlesAtIndex:(NSUInteger)idx withObject:(Article *)value;
- (void)replaceArticlesAtIndexes:(NSIndexSet *)indexes withArticles:(NSArray<Article *> *)values;
- (void)addArticlesObject:(Article *)value;
- (void)removeArticlesObject:(Article *)value;
- (void)addArticles:(NSOrderedSet<Article *> *)values;
- (void)removeArticles:(NSOrderedSet<Article *> *)values;

@end

NS_ASSUME_NONNULL_END
