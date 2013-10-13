// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stamp.m instead.

#import "_Stamp.h"

const struct StampAttributes StampAttributes = {
	.image = @"image",
	.issueDate = @"issueDate",
	.ordering = @"ordering",
	.title = @"title",
	.year = @"year",
};

const struct StampRelationships StampRelationships = {
};

const struct StampFetchedProperties StampFetchedProperties = {
};

@implementation StampID
@end

@implementation _Stamp

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Stamp" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Stamp";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Stamp" inManagedObjectContext:moc_];
}

- (StampID*)objectID {
	return (StampID*)[super objectID];
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




@dynamic image;






@dynamic issueDate;






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





@dynamic title;






@dynamic year;











@end
