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

@interface LocateUsMapViewController () <CDropDownListControlDelegate, MKMapViewDelegate>

@end

@implementation LocateUsMapViewController
{
    CTextField *findByTextField;
    CDropDownListControl *typesDropDownList;
    MKMapView *locateUsMapView;
    TPKeyboardAvoidingScrollView *contentScrollView;
    
    CLLocationCoordinate2D lastKnownUserLocation;
    BOOL initialShouldCenterUserLocation;
}

- (void)loadView
{
    contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentScrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [contentScrollView setDelaysContentTouches:NO];
    [contentScrollView setBackgroundColor:RGB(250, 250, 250)];
    
    findByTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 15, 290, 44)];
    findByTextField.placeholderFontSize = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 11.0f : 9.0f;
    findByTextField.insetBoundsSize = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? CGSizeMake(10, 6) : CGSizeMake(10, 10);
    [findByTextField setPlaceholder:@"Find by street name,\nblk no., mrt station etc"];
    [contentScrollView addSubview:findByTextField];
    
    UIButton *locateUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locateUsButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [locateUsButton setFrame:CGRectMake(265, 24, 30, 30)];
    [locateUsButton addTarget:self action:@selector(locateUsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollView addSubview:locateUsButton];
    
    typesDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(15, 70, 215, 44)];
    [typesDropDownList setPlistValueFile:@"LocateUs_Types"];
    [typesDropDownList setDelegate:self];
    [typesDropDownList selectRow:0 animated:NO];
    [contentScrollView addSubview:typesDropDownList];
    
    FlatBlueButton *goButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(235, 70, 70, 44)];
    [goButton addTarget:self action:@selector(goButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [goButton setTitle:@"OK" forState:UIControlStateNormal];
    [contentScrollView addSubview:goButton];
    
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

#pragma mark - Map

- (void)showFilteredLocationsOnMap
{
    NSString *locationType = typesDropDownList.selectedText;
    NSString *searchText = findByTextField.text;
    
    [locateUsMapView removeAnnotations:locateUsMapView.annotations];
    NSArray *locations;
    if (searchText.length == 0) {
        locations = [EntityLocation MR_findByAttribute:EntityLocationAttributes.type withValue:locationType];
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@ AND ((name CONTAINS[cd] %@) OR (address CONTAINS[cd] %@))", locationType, searchText, searchText];
        locations = [EntityLocation MR_findAllWithPredicate:predicate];
    }
    
    for (EntityLocation *location in locations) {
        EntityLocationMapAnnotation *locationAnnotation = [[EntityLocationMapAnnotation alloc] initWithEntityLocation:location];
        [locateUsMapView addAnnotation:locationAnnotation];
    }
}

- (void)centerMapToLastKnownUserLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = locateUsMapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.015, 0.015);
    [locateUsMapView setRegion:mapRegion animated:YES];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    lastKnownUserLocation = mapView.userLocation.coordinate;
    
    //center user location on initial load if required
    if (initialShouldCenterUserLocation) {
        [self centerMapToLastKnownUserLocation];
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
            annotationView.image = [UIImage imageNamed:@"posting_box_map_overlay"];
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        }
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    EntityLocationMapAnnotation *mapAnnotation = view.annotation;
    
    LocateUsDetailsViewController *viewController = [[LocateUsDetailsViewController alloc] initWithEntityLocation:mapAnnotation.location];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
}

#pragma mark - CDropDownListControlDelegate

- (void)repositionRelativeTo:(CDropDownListControl *)control byVerticalHeight:(CGFloat)offsetHeight
{
    [self.view endEditing:YES];
    
    CGFloat repositionFromY = CGRectGetMaxY(control.frame);
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *subview in contentScrollView.subviews) {
            if (subview.frame.origin.y >= repositionFromY) {
                if (subview.tag != TAG_DROPDOWN_PICKERVIEW)
                    [subview setY:subview.frame.origin.y + offsetHeight];
            }
        }
    } completion:^(BOOL finished) {
        if (offsetHeight > 0)
            [contentScrollView setContentOffset:CGPointMake(0, control.frame.origin.y - 10) animated:YES];
        else
            [contentScrollView setContentOffset:CGPointZero animated:YES];
    }];
}

#pragma mark - IBActions

- (IBAction)goButtonClicked:(id)sender
{
    [self showFilteredLocationsOnMap];
}

- (IBAction)locateUsButtonClicked:(id)sender
{
    [self showFilteredLocationsOnMap];
}

@end
