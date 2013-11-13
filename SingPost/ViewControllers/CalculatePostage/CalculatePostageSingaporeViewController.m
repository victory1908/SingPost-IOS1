//
//  CalculatePostageSingaporeViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 14/11/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CalculatePostageSingaporeViewController.h"
#import "CTextField.h"
#import "CDropDownListControl.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"
#import "FlatBlueButton.h"
#import <TPKeyboardAvoidingScrollView.h>

@interface CalculatePostageSingaporeViewController ()

@end

@implementation CalculatePostageSingaporeViewController

{
    TPKeyboardAvoidingScrollView *contentScrollView;
    CTextField *fromPostalCodeTextField, *toPostalCodeTextField, *weightTextField;
    CDropDownListControl *weightUnitsDropDownList;
}

- (void)loadView
{
    contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentScrollView setDelaysContentTouches:NO];
    [contentScrollView setBackgroundColor:RGB(240, 240, 240)];
    
    fromPostalCodeTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 20, 290, 44)];
    [fromPostalCodeTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [fromPostalCodeTextField setPlaceholder:@"From postal code"];
    [contentScrollView addSubview:fromPostalCodeTextField];
    
    toPostalCodeTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 75, 290, 44)];
    [toPostalCodeTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [toPostalCodeTextField setPlaceholder:@"To postal code"];
    [contentScrollView addSubview:toPostalCodeTextField];
    
    weightTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 130, 175, 44)];
    [weightTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [weightTextField setPlaceholder:@"Weight"];
    [contentScrollView addSubview:weightTextField];
    
    weightUnitsDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(202, 130, 103, 44)];
    [weightUnitsDropDownList setPlistValueFile:@"CalculatePostage_WeightUnits"];
    [weightUnitsDropDownList selectRow:0 animated:NO];
    [contentScrollView addSubview:weightUnitsDropDownList];
    
    UILabel *allFieldMandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 175, 150, 20)];
    [allFieldMandatoryLabel setText:@"All fields are mandatory"];
    [allFieldMandatoryLabel setBackgroundColor:[UIColor clearColor]];
    [allFieldMandatoryLabel setTextColor:RGB(125, 136, 149)];
    [allFieldMandatoryLabel setFont:[UIFont SingPostLightItalicFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [contentScrollView addSubview:allFieldMandatoryLabel];
    
    FlatBlueButton *calculatePostageButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, 210, contentScrollView.bounds.size.width - 30, 48)];
    [calculatePostageButton addTarget:self action:@selector(calculatePostageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [calculatePostageButton setTitle:@"CALCULATE" forState:UIControlStateNormal];
    [contentScrollView addSubview:calculatePostageButton];
    
    self.view = contentScrollView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [contentScrollView setContentSize:contentScrollView.bounds.size];
}

#pragma mark - IBActions

- (IBAction)calculatePostageButtonClicked:(id)sender
{
    NSLog(@"calculate postage button clicked");
}

@end
