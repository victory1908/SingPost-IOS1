// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TrackedItem.m instead.

#import "_TrackedItem.h"

const struct TrackedItemAttributes TrackedItemAttributes = {
	.addedOn = @"addedOn",
	.destinationCountry = @"destinationCountry",
	.isActive = @"isActive",
	.isFound = @"isFound",
	.isRead = @"isRead",
	.lastUpdatedOn = @"lastUpdatedOn",
	.originalCountry = @"originalCountry",
	.trackingNumber = @"trackingNumber",
};

const struct TrackedItemRelationships TrackedItemRelationships = {
	.deliveryStatuses = @"deliveryStatuses",
};

const struct TrackedItemFetchedProperties TrackedItemFetchedProperties = {
};

@implementation TrackedItemID
@end

@implementation _TrackedItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TrackedItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TrackedItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TrackedItem" inManagedObjectContext:moc_];
}

- (TrackedItemID*)objectID {
	return (TrackedItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isFoundValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isFound"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isReadValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isRead"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic addedOn;






@dynamic destinationCountry;






@dynamic isActive;






@dynamic isFound;



- (BOOL)isFoundValue {
	NSNumber *result = [self isFound];
	return [result boolValue];
}

- (void)setIsFoundValue:(BOOL)value_ {
	[self setIsFound:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsFoundValue {
	NSNumber *result = [self primitiveIsFound];
	return [result boolValue];
}

- (void)setPrimitiveIsFoundValue:(BOOL)value_ {
	[self setPrimitiveIsFound:[NSNumber numberWithBool:value_]];
}





@dynamic isRead;



- (BOOL)isReadValue {
	NSNumber *result = [self isRead];
	return [result boolValue];
}

- (void)setIsReadValue:(BOOL)value_ {
	[self setIsRead:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsReadValue {
	NSNumber *result = [self primitiveIsRead];
	return [result boolValue];
}

- (void)setPrimitiveIsReadValue:(BOOL)value_ {
	[self setPrimitiveIsRead:[NSNumber numberWithBool:value_]];
}





@dynamic lastUpdatedOn;






@dynamic originalCountry;






@dynamic trackingNumber;






@dynamic deliveryStatuses;

	
- (NSMutableOrderedSet*)deliveryStatusesSet {
	[self willAccessValueForKey:@"deliveryStatuses"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"deliveryStatuses"];
  
	[self didAccessValueForKey:@"deliveryStatuses"];
	return result;
}
	






@end
