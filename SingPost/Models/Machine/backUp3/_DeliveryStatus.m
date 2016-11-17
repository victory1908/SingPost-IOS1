// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DeliveryStatus.m instead.

#import "_DeliveryStatus.h"

const struct DeliveryStatusAttributes DeliveryStatusAttributes = {
	.date = @"date",
	.location = @"location",
	.statusDescription = @"statusDescription",
};

const struct DeliveryStatusRelationships DeliveryStatusRelationships = {
};

const struct DeliveryStatusFetchedProperties DeliveryStatusFetchedProperties = {
};

@implementation DeliveryStatusID
@end

@implementation _DeliveryStatus

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DeliveryStatus" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DeliveryStatus";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DeliveryStatus" inManagedObjectContext:moc_];
}

- (DeliveryStatusID*)objectID {
	return (DeliveryStatusID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic date;






@dynamic location;






@dynamic statusDescription;











@end
