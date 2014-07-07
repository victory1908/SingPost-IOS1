//
//  LocateUsMapViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 1/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface LocateUsMapViewController : UIViewController
@property (strong, nonatomic) CLLocation *userLocation;
@property (nonatomic, readonly) NSString *selectedLocationType;
@property (nonatomic) NSUInteger selectedTypeRowIndex;
@property (nonatomic) NSString *searchTerm;
@property (nonatomic, weak) id delegate;

- (void)removeMapAnnotations;
- (void)showFilteredLocationsOnMap;
- (void)centerMapAtLocation:(CLLocationCoordinate2D)coordinate;

@end
