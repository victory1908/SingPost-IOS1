// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PostingBox.m instead.

#import "_PostingBox.h"

const struct PostingBoxAttributes PostingBoxAttributes = {
	.address = @"address",
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
	.postingbox = @"postingbox",
	.sat_closing = @"sat_closing",
	.sat_opening = @"sat_opening",
	.services = @"services",
	.sun_closing = @"sun_closing",
	.sun_opening = @"sun_opening",
	.thu_closing = @"thu_closing",
	.thu_opening = @"thu_opening",
	.tue_closing = @"tue_closing",
	.tue_opening = @"tue_opening",
	.type = @"type",
	.wed_closing = @"wed_closing",
	.wed_opening = @"wed_opening",
};

const struct PostingBoxRelationships PostingBoxRelationships = {
};

const struct PostingBoxFetchedProperties PostingBoxFetchedProperties = {
};

@implementation PostingBoxID
@end

@implementation _PostingBox

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PostingBox" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PostingBox";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PostingBox" inManagedObjectContext:moc_];
}

- (PostingBoxID*)objectID {
	return (PostingBoxID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic address;






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






@dynamic postingbox;






@dynamic sat_closing;






@dynamic sat_opening;






@dynamic services;






@dynamic sun_closing;






@dynamic sun_opening;






@dynamic thu_closing;






@dynamic thu_opening;






@dynamic tue_closing;






@dynamic tue_opening;






@dynamic type;






@dynamic wed_closing;






@dynamic wed_opening;











@end
