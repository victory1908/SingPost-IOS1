// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ArticleCategory.m instead.

#import "_ArticleCategory.h"

const struct ArticleCategoryAttributes ArticleCategoryAttributes = {
	.category = @"category",
	.module = @"module",
};

const struct ArticleCategoryRelationships ArticleCategoryRelationships = {
	.articles = @"articles",
};

const struct ArticleCategoryFetchedProperties ArticleCategoryFetchedProperties = {
};

@implementation ArticleCategoryID
@end

@implementation _ArticleCategory

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ArticleCategory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ArticleCategory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ArticleCategory" inManagedObjectContext:moc_];
}

- (ArticleCategoryID*)objectID {
	return (ArticleCategoryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic category;






@dynamic module;






@dynamic articles;

	
- (NSMutableOrderedSet*)articlesSet {
	[self willAccessValueForKey:@"articles"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"articles"];
  
	[self didAccessValueForKey:@"articles"];
	return result;
}
	






@end
