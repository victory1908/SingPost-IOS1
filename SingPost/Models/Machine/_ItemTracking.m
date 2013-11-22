// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ItemTracking.m instead.

#import "_ItemTracking.h"

const struct ItemTrackingAttributes ItemTrackingAttributes = {
	.addedOn = @"addedOn",
	.destinationCountry = @"destinationCountry",
	.isActive = @"isActive",
	.originalCountry = @"originalCountry",
	.trackingNumber = @"trackingNumber",
};

const struct ItemTrackingRelationships ItemTrackingRelationships = {
	.deliveryStatuses = @"deliveryStatuses",
};

const struct ItemTrackingFetchedProperties ItemTrackingFetchedProperties = {
};

@implementation ItemTrackingID
@end

@implementation _ItemTracking

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ItemTracking" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ItemTracking";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ItemTracking" inManagedObjectContext:moc_];
}

- (ItemTrackingID*)objectID {
	return (ItemTrackingID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isActiveValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isActive"];
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
