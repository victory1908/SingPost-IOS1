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
    [goButton setTitle:@"GO" forState:UIControlStateNormal];
    [contentScrollView addSubview:goButton];
    
    initialShouldCenterUserLocation = YES;
    locateUsMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 120, contentScrollView.bounds.size.width, contentScrollView.bounds.size.height - 120 - 65)];
    [locateUsMapView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [locateUsMapView setDelegate:self];
    [locateUsMapView setShowsUserLocation:YES];
    [contentScrollView addSubview:locateUsMapView];
    
    FlatBlueButton *aroundMeButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, contentScrollView.bounds.size.height - 56, contentScrollView.bounds.size.width - 30, 48)];
    [aroundMeButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [aroundMeButton addTarget:self action:@selector(aroundMeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [aroundMeButton setTitle:@"AROUND ME" forState:UIControlStateNormal];
    [contentScrollView addSubview:aroundMeButton];

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
    [self showPlacesForType:typesDropDownList.selectedText];
}

#pragma mark - Map

- (void)showPlacesForType:(NSString *)type
{
    [locateUsMapView removeAnnotations:locateUsMapView.annotations];
    for (EntityLocation *location in [EntityLocation MR_findByAttribute:EntityLocationAttributes.type withValue:typesDropDownList.selectedText]) {
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
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil; //use default
    
    static NSString *const annotationIdentifier = @"EntityLocationAnnotation";
    
    MKAnnotationView *annotationView = [locateUsMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"map_overlay"];
    }
    
    return annotationView;
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
    [self showPlacesForType:typesDropDownList.selectedText];
}

- (IBAction)locateUsButtonClicked:(id)sender
{
    NSLog(@"locate us clicked");
}

- (IBAction)aroundMeButtonClicked:(id)sender
{
    [self centerMapToLastKnownUserLocation];
}

@end
