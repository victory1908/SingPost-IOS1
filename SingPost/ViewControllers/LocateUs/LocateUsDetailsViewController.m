//
//  LocateUsDetailsViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 1/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LocateUsDetailsViewController.h"
#import "NavigationBarView.h"
#import "EntityLocation.h"

#import <MapKit/MapKit.h>

#import "MapAnnotation.h"
#import "UIFont+SingPost.h"
#import "UILabel+VerticalAlign.h"

@interface LocateUsDetailsViewController () <MKMapViewDelegate>

@end

@implementation LocateUsDetailsViewController
{
    EntityLocation *_entityLocation;
    MKMapView *locationMapView;
    UILabel *addressLabel;
    UIImageView *isOpenedIndicatorImageView;
}

//designated initializer
- (id)initWithEntityLocation:(EntityLocation *)inEntityLocation
{
    NSParameterAssert(inEntityLocation);
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _entityLocation = inEntityLocation;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithEntityLocation:nil];
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:_entityLocation.name];
    [navigationBarView setShowBackButton:YES];
    [contentView addSubview:navigationBarView];
    
    locationMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, 200)];
    locationMapView.delegate = self;
    [contentView addSubview:locationMapView];
    
    UIImageView *addressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address_icon"]];
    [addressImageView setFrame:CGRectMake(15, 259, 35, 34)];
    [contentView addSubview:addressImageView];
    
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 255, 190, 44)];
    [addressLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [addressLabel setTextColor:RGB(51, 51, 51)];
    [addressLabel setNumberOfLines:2];
    [addressLabel setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview:addressLabel];
    
    isOpenedIndicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(255, 274, 10, 10)];
    [contentView addSubview:isOpenedIndicatorImageView];
    
    UIButton *searchMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchMapButton setImage:[UIImage imageNamed:@"search_map_button"] forState:UIControlStateNormal];
    [searchMapButton setFrame:CGRectMake(270, 256, 44, 44)];
    [contentView addSubview:searchMapButton];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //map
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(_entityLocation.latitude.floatValue, _entityLocation.longitude.floatValue);
    mapRegion.span = MKCoordinateSpanMake(0.015, 0.015);
    [locationMapView setRegion:mapRegion animated:YES];
    
    MapAnnotation *locationAnnotation = [[MapAnnotation alloc] initWithLatitude:_entityLocation.latitude.floatValue andLongitude:_entityLocation.longitude.floatValue];
    [locationMapView addAnnotation:locationAnnotation];
    
    //fields
    [addressLabel setText:_entityLocation.address];
//    [addressLabel sizeThatFits:addressLabel.bounds.size];
//    [addressLabel setCenter:CGPointMake(addressLabel.center.x, 276)];
    [isOpenedIndicatorImageView setImage:[UIImage imageNamed:_entityLocation.isOpened ? @"green_circle" : @"red_circle"]];
}

#pragma mark - MKMapViewDelegates

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *const annotationIdentifier = @"EntityLocationAnnotation";
    
    MKAnnotationView *annotationView = [locationMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"map_overlay"];
    }
    
    return annotationView;
}

@end
