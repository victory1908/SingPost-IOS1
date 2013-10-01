//
//  MapAnnotation.m
//  SingPost
//
//  Created by Edward Soetiono on 1/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation
{
    CLLocationDegrees _latitude, _longitude;
}

- (id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude
{
	if (self = [super init]) {
		_latitude = latitude;
		_longitude = longitude;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	return CLLocationCoordinate2DMake(_latitude, _longitude);
}

@end
