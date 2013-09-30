//
//  LocateUsMapView.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LocateUsMapView.h"
#import "CTextField.h"
#import "FlatBlueButton.h"
#import "CDropDownListControl.h"
#import "FlatBlueButton.h"
#import <MapKit/MapKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "UIView+Position.h"

@interface LocateUsMapView () <CDropDownListControlDelegate>

@end

@implementation LocateUsMapView
{
    CTextField *findByTextField;
    CDropDownListControl *typesDropDownList;
    MKMapView *mapView;
    TPKeyboardAvoidingScrollView *contentScrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.bounds];
        [contentScrollView setDelaysContentTouches:NO];
        [contentScrollView setBackgroundColor:RGB(250, 250, 250)];
        
        findByTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 15, 290, 44)];
        findByTextField.placeholderFontSize = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 11.0f : 9.0f;
        findByTextField.insetBoundsSize = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? CGSizeMake(12, 6) : CGSizeMake(12, 10);
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
        
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 120, contentScrollView.bounds.size.width, contentScrollView.bounds.size.height - 120 - 65)];
        [contentScrollView addSubview:mapView];
        
        FlatBlueButton *aroundMeButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, contentScrollView.bounds.size.height - 56, contentScrollView.bounds.size.width - 30, 48)];
        [aroundMeButton addTarget:self action:@selector(aroundMeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [aroundMeButton setTitle:@"AROUND ME" forState:UIControlStateNormal];
        [contentScrollView addSubview:aroundMeButton];

        [contentScrollView setContentSize:contentScrollView.bounds.size];
        [self addSubview:contentScrollView];
    }
    return self;
}

#pragma mark - CDropDownListControlDelegate

- (void)repositionRelativeTo:(CDropDownListControl *)control byVerticalHeight:(CGFloat)offsetHeight
{
    [super endEditing:YES];
    
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
