// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Offer.m instead.

#import "_Offer.h"

const struct OfferAttributes OfferAttributes = {
	.details = @"details",
	.offerDate = @"offerDate",
	.ordering = @"ordering",
	.title = @"title",
	.year = @"year",
};

const struct OfferRelationships OfferRelationships = {
	.images = @"images",
};

const struct OfferFetchedProperties OfferFetchedProperties = {
};

@implementation OfferID
@end

@implementation _Offer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Offer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Offer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:moc_];
}

- (OfferID*)objectID {
	return (OfferID*)[super objectID];
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




@dynamic details;






@dynamic offerDate;






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






@dynamic images;

	
- (NSMutableOrderedSet*)imagesSet {
	[self willAccessValueForKey:@"images"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"images"];
  
	[self didAccessValueForKey:@"images"];
	return result;
}
	






@end
