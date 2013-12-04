// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to StampImage.m instead.

#import "_StampImage.h"

const struct StampImageAttributes StampImageAttributes = {
	.image = @"image",
	.name = @"name",
};

const struct StampImageRelationships StampImageRelationships = {
	.stamp = @"stamp",
};

const struct StampImageFetchedProperties StampImageFetchedProperties = {
};

@implementation StampImageID
@end

@implementation _StampImage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"StampImage" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"StampImage";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"StampImage" inManagedObjectContext:moc_];
}

- (StampImageID*)objectID {
	return (StampImageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic image;






@dynamic name;






@dynamic stamp;

	






@end
