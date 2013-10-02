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

@interface LocateUsMapViewController () <CDropDownListControlDelegate, MKMapViewDelegate>

@end

@implementation LocateUsMapViewController
{
    CTextField *findByTextField;
    CDropDownListControl *typesDropDownList;
    MKMapView *locateUsMapView;
    TPKeyboardAvoidingScrollView *contentScrollView;
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
    
    [contentScrollView setContentSize:contentScrollView.bounds.size];
    self.view = contentScrollView;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.015, 0.015);
    [mapView setRegion:mapRegion animated:YES];
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
    NSLog(@"go button clicked");
}

- (IBAction)locateUsButtonClicked:(id)sender
{
    NSLog(@"locate us clicked");
}

- (IBAction)aroundMeButtonClicked:(id)sender
{
    NSLog(@"around me clicked");
}

@end
