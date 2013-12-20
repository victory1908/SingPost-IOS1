//
//  LocateUsMapViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 1/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LocateUsMapViewController.h"
#import "CTextField.h"
#import "FlatBlueButton.h"
#import "CDropDownListControl.h"
#import "FlatBlueButton.h"
#import <MapKit/MapKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "UIView+Position.h"
#import "EntityLocation.h"
#import "EntityLocationMapAnnotation.h"
#import "AppDelegate.h"
#import "LocateUsDetailsViewController.h"

@interface LocateUsMapViewController () <MKMapViewDelegate, CDropDownListControlDelegate, UITextFieldDelegate>

@end

@implementation LocateUsMapViewController
{
    CTextField *findByTextField;
    CDropDownListControl *typesDropDownList;
    MKMapView *locateUsMapView;
    TPKeyboardAvoidingScrollView *contentScrollView;
    NSMutableArray *locationAnnotations;
    
    BOOL initialShouldCenterUserLocation;
}

@synthesize searchTerm = _searchTerm;

- (void)loadView
{
    contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentScrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [contentScrollView setDelaysContentTouches:NO];
    [contentScrollView setBackgroundColor:RGB(250, 250, 250)];
    
    findByTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 15, 290, 44)];
    findByTextField.placeholderFontSize = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 11.0f : 9.0f;
    findByTextField.insetBoundsSize = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? CGSizeMake(40, 3) : CGSizeMake(40, 5);
    [findByTextField setReturnKeyType:UIReturnKeyGo];
    [findByTextField setDelegate:self];
    [findByTextField setPlaceholder:@"Find by street name,\nblk no., mrt station etc"];
    [contentScrollView addSubview:findByTextField];
    
    UIImageView *searchIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 24, 27, 30)];
    [searchIconImageView setImage:[UIImage imageNamed:@"magnifying_glass"]];
    [contentScrollView addSubview:searchIconImageView];
    
    typesDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(15, 70, 290, 44)];
    [typesDropDownList setPlistValueFile:@"LocateUs_Types"];
    [typesDropDownList selectRow:0 animated:NO];
    [typesDropDownList setDelegate:self];
    [contentScrollView addSubview:typesDropDownList];
    
    initialShouldCenterUserLocation = YES;
    locateUsMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 120, contentScrollView.bounds.size.width, contentScrollView.bounds.size.height - 180)];
    [locateUsMapView setDelegate:self];
    [locateUsMapView setShowsUserLocation:YES];
    [contentScrollView addSubview:locateUsMapView];

    self.view = contentScrollView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [contentScrollView setContentSize:contentScrollView.bounds.size];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showFilteredLocationsOnMap];
}

- (void)dealloc
{
    [locateUsMapView setDelegate:nil];
    locateUsMapView = nil;
}

#pragma mark - Accessors

- (NSString *)selectedLocationType
{
    return typesDropDownList.selectedText;
}

- (NSUInteger)selectedTypeRowIndex
{
    return typesDropDownList.selectedRowIndex;
}

- (void)setSelectedTypeRowIndex:(NSUInteger)inSelectedTypeRowIndex
{
    [typesDropDownList selectRow:inSelectedTypeRowIndex animated:YES];
}

- (NSString *)searchTerm
{
    return findByTextField.text;
}

- (void)setSearchTerm:(NSString *)searchTerm
{
    [findByTextField setText:searchTerm];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self showFilteredLocationsOnMap];
    return YES;
}

#pragma mark - Map

- (void)removeMapAnnotations
{
    [locateUsMapView removeAnnotations:locationAnnotations];
    [locationAnnotations removeAllObjects];
}

- (void)showFilteredLocationsOnMap
{
    [self.view endEditing:YES];
    NSString *locationType = typesDropDownList.selectedText;
    NSString *searchText = findByTextField.text;
    
    [self removeMapAnnotations];

    NSArray *locations;
    if (searchText.length == 0) {
        locations = [EntityLocation MR_findByAttribute:EntityLocationAttributes.type withValue:locationType];
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@ AND ((name CONTAINS[cd] %@) OR (address CONTAINS[cd] %@))", locationType, searchText, searchText];
        locations = [EntityLocation MR_findAllWithPredicate:predicate];
    }
    
    locationAnnotations = [NSMutableArray array];
    for (EntityLocation *location in locations)
        [locationAnnotations addObject:[[EntityLocationMapAnnotation alloc] initWithEntityLocation:location]];
    
    [locateUsMapView addAnnotations:locationAnnotations];
    
    if (locations.count > 0) {
        //zoom in to the first location
        [self centerMapToFitAllLocations];
    }
    
    if ([locationType isEqualToString:LOCATION_TYPE_POST_OFFICE])
        [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Locations- PO Map"];
    else if ([locationType isEqualToString:LOCATION_TYPE_SAM])
        [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Locations- SAM Map"];
    else if ([locationType isEqualToString:LOCATION_TYPE_POSTING_BOX])
        [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Locations- Posting Box Map"];
    else if ([locationType isEqualToString:LOCATION_TYPE_SAM])
        [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Locations- SAM Map"];
    else if ([locationType isEqualToString:LOCATION_TYPE_POPSTATION])
        [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Locations- POPStation Map"];
}

- (void)centerMapAtLocation:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.015, 0.015);
    [locateUsMapView setRegion:mapRegion animated:YES];
}

- (void)centerMapToFitAllLocations
{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in locateUsMapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [locateUsMapView setVisibleMapRect:zoomRect animated:YES];
}

#pragma mark - CDropDownListControlDelegate

- (void)CDropDownListControlDismissed:(CDropDownListControl *)dropDownListControl
{
    [self showFilteredLocationsOnMap];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //center user location on initial load if required
    if (initialShouldCenterUserLocation) {
        [self centerMapAtLocation:mapView.userLocation.coordinate];
        initialShouldCenterUserLocation = NO;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *annotationView;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        static NSString *const selfAnnotationIdentifier = @"SelfLocationAnnotation";
        
        annotationView = [locateUsMapView dequeueReusableAnnotationViewWithIdentifier:selfAnnotationIdentifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:selfAnnotationIdentifier];
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"self_map_overlay"];
        }
    }
    else {
        static NSString *const annotationIdentifier = @"EntityLocationAnnotation";
        
        annotationView = [locateUsMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
        NSString *locationType = self.selectedLocationType;
        if ([locationType isEqualToString:LOCATION_TYPE_POST_OFFICE])
            annotationView.image = [UIImage imageNamed:@"post_office_map_overlay"];
        else if ([locationType isEqualToString:LOCATION_TYPE_SAM])
            annotationView.image = [UIImage imageNamed:@"sam_map_overlay"];
        else if ([locationType isEqualToString:LOCATION_TYPE_POSTING_BOX])
            annotationView.image = [UIImage imageNamed:@"posting_box_map_overlay"];
        else if ([locationType isEqualToString:LOCATION_TYPE_AGENT])
            annotationView.image = [UIImage imageNamed:@"agent_map_overlay"];
        else if ([locationType isEqualToString:LOCATION_TYPE_POPSTATION])
            annotationView.image = [UIImage imageNamed:@"popstation_map_overlay"];
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    EntityLocationMapAnnotation *mapAnnotation = view.annotation;
    
    LocateUsDetailsViewController *viewController = [[LocateUsDetailsViewController alloc] initWithEntityLocation:mapAnnotation.location];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
}

@end
