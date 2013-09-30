//
//  FindPostalCodeStreetView.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "FindPostalCodeStreetView.h"
#import "CTextField.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIFont+SingPost.h"
#import "FlatBlueButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation FindPostalCodeStreetView
{
    TPKeyboardAvoidingScrollView *contentScrollView;
    CTextField *buildingBlockHouseNumberTextField, *streetNameTextField;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.bounds];
        [contentScrollView setDelaysContentTouches:NO];
        [contentScrollView setBackgroundColor:[UIColor clearColor]];
        
        buildingBlockHouseNumberTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 20, 290, 44)];
        [buildingBlockHouseNumberTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [buildingBlockHouseNumberTextField setPlaceholder:@"Building / block / house number"];
        [contentScrollView addSubview:buildingBlockHouseNumberTextField];
        
        streetNameTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 75, 290, 44)];
        [streetNameTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [streetNameTextField setPlaceholder:@"Street name"];
        [contentScrollView addSubview:streetNameTextField];
        
        UILabel *allFieldMandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 125, 150, 20)];
        [allFieldMandatoryLabel setText:@"All fields are mandatory"];
        [allFieldMandatoryLabel setBackgroundColor:[UIColor clearColor]];
        [allFieldMandatoryLabel setTextColor:RGB(125, 136, 149)];
        [allFieldMandatoryLabel setFont:[UIFont SingPostLightItalicFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [contentScrollView addSubview:allFieldMandatoryLabel];
        
        FlatBlueButton *findButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, 175, self.bounds.size.width - 30, 48)];
        [findButton addTarget:self action:@selector(findButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [findButton setTitle:@"FIND" forState:UIControlStateNormal];
        [contentScrollView addSubview:findButton];
        
        UIView *postalCodeContainerView = [[UIView alloc] initWithFrame:CGRectMake(15, 245, contentScrollView.bounds.size.width - 30, 100)];
        [postalCodeContainerView.layer setBorderWidth:1.0f];
        [postalCodeContainerView.layer setBorderColor:RGB(58, 68, 81).CGColor];
        [contentScrollView addSubview:postalCodeContainerView];
        
        UILabel *postalCodeHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, postalCodeContainerView.bounds.size.width, 30)];
        [postalCodeHeaderLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [postalCodeHeaderLabel setTextAlignment:NSTextAlignmentCenter];
        [postalCodeHeaderLabel setTextColor:RGB(58, 68, 61)];
        [postalCodeHeaderLabel setBackgroundColor:[UIColor clearColor]];
        [postalCodeHeaderLabel setText:@"Postal Code"];
        [postalCodeContainerView addSubview:postalCodeHeaderLabel];
        
        UILabel *postalCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, postalCodeContainerView.bounds.size.width, 44)];
        [postalCodeLabel setFont:[UIFont SingPostBoldFontOfSize:40.0f fontKey:kSingPostFontOpenSans]];
        [postalCodeLabel setTextAlignment:NSTextAlignmentCenter];
        [postalCodeLabel setTextColor:RGB(58, 68, 61)];
        [postalCodeLabel setBackgroundColor:[UIColor clearColor]];
        [postalCodeLabel setText:@"123456"];
        [postalCodeContainerView addSubview:postalCodeLabel];
        
        [contentScrollView setContentSize:contentScrollView.bounds.size];
        [self addSubview:contentScrollView];
    }
    
    return self;
}

- (IBAction)findButtonClicked:(id)sender
{
    NSLog(@"find button clicked");
}

@end
