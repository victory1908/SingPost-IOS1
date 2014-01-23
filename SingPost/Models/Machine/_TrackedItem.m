// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TrackedItem.m instead.

#import "_TrackedItem.h"

const struct TrackedItemAttributes TrackedItemAttributes = {
	.addedOn = @"addedOn",
	.destinationCountry = @"destinationCountry",
	.isActive = @"isActive",
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
	
	if ([key isEqualToString:@"isActiveValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isActive"];
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



- (BOOL)isActiveValue {
	NSNumber *result = [self isActive];
	return [result boolValue];
}

- (void)setIsActiveValue:(BOOL)value_ {
	[self setIsActive:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsActiveValue {
	NSNumber *result = [self primitiveIsActive];
	return [result boolValue];
}

- (void)setPrimitiveIsActiveValue:(BOOL)value_ {
	[self setPrimitiveIsActive:[NSNumber numberWithBool:value_]];
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
