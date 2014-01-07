// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Article.m instead.

#import "_Article.h"

const struct ArticleAttributes ArticleAttributes = {
	.buttonType = @"buttonType",
	.htmlContent = @"htmlContent",
	.name = @"name",
	.ordering = @"ordering",
	.thumbnail = @"thumbnail",
	.websiteURL = @"websiteURL",
};

const struct ArticleRelationships ArticleRelationships = {
};

const struct ArticleFetchedProperties ArticleFetchedProperties = {
};

@implementation ArticleID
@end

@implementation _Article

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Article";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Article" inManagedObjectContext:moc_];
}

- (ArticleID*)objectID {
	return (ArticleID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"orderingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"ordering"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic buttonType;






@dynamic htmlContent;






@dynamic name;






@dynamic ordering;



- (int32_t)orderingValue {
	NSNumber *result = [self ordering];
	return [result intValue];
}

- (void)setOrderingValue:(int32_t)value_ {
	[self setOrdering:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveOrderingValue {
	NSNumber *result = [self primitiveOrdering];
	return [result intValue];
}

- (void)setPrimitiveOrderingValue:(int32_t)value_ {
	[self setPrimitiveOrdering:[NSNumber numberWithInt:value_]];
}





@dynamic thumbnail;






@dynamic websiteURL;











@end
