// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stamp.m instead.

#import "_Stamp.h"

const struct StampAttributes StampAttributes = {
	.coverImage = @"coverImage",
	.day = @"day",
	.details = @"details",
	.month = @"month",
	.ordering = @"ordering",
	.price = @"price",
	.serverId = @"serverId",
	.thumbnail = @"thumbnail",
	.title = @"title",
	.year = @"year",
};

const struct StampRelationships StampRelationships = {
	.images = @"images",
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
	if ([key isEqualToString:@"serverIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"serverId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic coverImage;






@dynamic day;






@dynamic details;






@dynamic month;






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





@dynamic price;






@dynamic serverId;



- (int32_t)serverIdValue {
	NSNumber *result = [self serverId];
	return [result intValue];
}

- (void)setServerIdValue:(int32_t)value_ {
	[self setServerId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveServerIdValue {
	NSNumber *result = [self primitiveServerId];
	return [result intValue];
}

- (void)setPrimitiveServerIdValue:(int32_t)value_ {
	[self setPrimitiveServerId:[NSNumber numberWithInt:value_]];
}





@dynamic thumbnail;






@dynamic title;






@dynamic year;






@dynamic images;

	
- (NSMutableOrderedSet*)imagesSet {
	[self willAccessValueForKey:@"images"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"images"];
  
	[self didAccessValueForKey:@"images"];
	return result;
}
	






@end
