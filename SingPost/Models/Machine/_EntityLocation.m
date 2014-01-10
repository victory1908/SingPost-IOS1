// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EntityLocation.m instead.

#import "_EntityLocation.h"

const struct EntityLocationAttributes EntityLocationAttributes = {
	.address = @"address",
	.contactNumber = @"contactNumber",
	.fri_closing = @"fri_closing",
	.fri_opening = @"fri_opening",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.mon_closing = @"mon_closing",
	.mon_opening = @"mon_opening",
	.name = @"name",
	.notification = @"notification",
	.ph_closing = @"ph_closing",
	.ph_opening = @"ph_opening",
	.postal_code = @"postal_code",
	.postingbox = @"postingbox",
	.sat_closing = @"sat_closing",
	.sat_opening = @"sat_opening",
	.services = @"services",
	.sun_closing = @"sun_closing",
	.sun_opening = @"sun_opening",
	.thu_closing = @"thu_closing",
	.thu_opening = @"thu_opening",
	.town = @"town",
	.tue_closing = @"tue_closing",
	.tue_opening = @"tue_opening",
	.type = @"type",
	.wed_closing = @"wed_closing",
	.wed_opening = @"wed_opening",
};

const struct EntityLocationRelationships EntityLocationRelationships = {
};

const struct EntityLocationFetchedProperties EntityLocationFetchedProperties = {
};

@implementation EntityLocationID
@end

@implementation _EntityLocation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"EntityLocation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"EntityLocation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"EntityLocation" inManagedObjectContext:moc_];
}

- (EntityLocationID*)objectID {
	return (EntityLocationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic address;






@dynamic contactNumber;






@dynamic fri_closing;






@dynamic fri_opening;






@dynamic latitude;






@dynamic longitude;






@dynamic mon_closing;






@dynamic mon_opening;






@dynamic name;






@dynamic notification;






@dynamic ph_closing;






@dynamic ph_opening;






@dynamic postal_code;






@dynamic postingbox;






@dynamic sat_closing;






@dynamic sat_opening;






@dynamic services;






@dynamic sun_closing;






@dynamic sun_opening;






@dynamic thu_closing;






@dynamic thu_opening;






@dynamic town;






@dynamic tue_closing;






@dynamic tue_opening;






@dynamic type;






@dynamic wed_closing;






@dynamic wed_opening;











@end
