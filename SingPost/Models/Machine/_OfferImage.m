// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OfferImage.m instead.

#import "_OfferImage.h"

const struct OfferImageAttributes OfferImageAttributes = {
	.image = @"image",
};

const struct OfferImageRelationships OfferImageRelationships = {
	.offer = @"offer",
};

const struct OfferImageFetchedProperties OfferImageFetchedProperties = {
};

@implementation OfferImageID
@end

@implementation _OfferImage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OfferImage" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OfferImage";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OfferImage" inManagedObjectContext:moc_];
}

- (OfferImageID*)objectID {
	return (OfferImageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic image;






@dynamic offer;

	






@end
