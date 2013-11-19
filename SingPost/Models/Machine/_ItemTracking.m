// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ItemTracking.m instead.

#import "_ItemTracking.h"

const struct ItemTrackingAttributes ItemTrackingAttributes = {
	.addedOn = @"addedOn",
	.destinationCountry = @"destinationCountry",
	.group = @"group",
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
	

	return keyPaths;
}




@dynamic addedOn;






@dynamic destinationCountry;






@dynamic group;






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
