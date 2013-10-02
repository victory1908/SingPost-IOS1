//
//  EntityLocationMapAnnotation.h
//  SingPost
//
//  Created by Edward Soetiono on 1/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class EntityLocation;

@interface EntityLocationMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) EntityLocation *location;

- (id)initWithEntityLocation:(EntityLocation *)location;

@end
