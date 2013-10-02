//
//  EntityLocationMapAnnotation.m
//  SingPost
//
//  Created by Edward Soetiono on 1/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "EntityLocationMapAnnotation.h"
#import "EntityLocation.h"

@implementation EntityLocationMapAnnotation

- (id)initWithEntityLocation:(EntityLocation *)inLocation
{
    NSParameterAssert(inLocation);
	if (self = [super init]) {
		_location = inLocation;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate
{
	return _location.coordinate;
}

- (NSString *)title
{
    return _location.name;
}

- (NSString *)subtitle
{
    return _location.address;
}

@end
