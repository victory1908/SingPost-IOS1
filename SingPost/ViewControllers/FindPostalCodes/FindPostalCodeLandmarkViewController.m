//
//  FindPostalCodeLandmarkViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 14/11/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "FindPostalCodeLandmarkViewController.h"
#import "CTextField.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIFont+SingPost.h"
#import "FlatBlueButton.h"
#import <QuartzCore/QuartzCore.h>
#import <SVProgressHUD.h>
#import "PostalCode.h"

@interface FindPostalCodeLandmarkViewController ()

@end

@implementation FindPostalCodeLandmarkViewController
{
    TPKeyboardAvoidingScrollView *contentScrollView;
    CTextField *majorBuildingEstateTextField;
    UILabel *postalCodeLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [contentScrollView setDelaysContentTouches:NO];
        [contentScrollView setBackgroundColor:[UIColor clearColor]];
        
        majorBuildingEstateTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 20, 290, 44)];
        [majorBuildingEstateTextField setPlaceholder:@"Major building / Estate name"];
        [contentScrollView addSubview:majorBuildingEstateTextField];
        
        FlatBlueButton *findButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, 175, contentScrollView.bounds.size.width - 30, 48)];
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
        
        postalCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, postalCodeContainerView.bounds.size.width, 44)];
        [postalCodeLabel setFont:[UIFont SingPostBoldFontOfSize:40.0f fontKey:kSingPostFontOpenSans]];
        [postalCodeLabel setTextAlignment:NSTextAlignmentCenter];
        [postalCodeLabel setTextColor:RGB(58, 68, 61)];
        [postalCodeLabel setBackgroundColor:[UIColor clearColor]];
        [postalCodeContainerView addSubview:postalCodeLabel];
        
        self.view = contentScrollView;
    }
    
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [contentScrollView setContentSize:contentScrollView.bounds.size];
}

- (IBAction)findButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    if ([majorBuildingEstateTextField.text length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please ensure that all fields are entered correctly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeClear];
        [postalCodeLabel setText:@""];
        [PostalCode API_findPostalCodeForLandmark:majorBuildingEstateTextField.text onCompletion:^(NSString *postalCode, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"An error has occurred"];
            }
            else {
                [SVProgressHUD dismiss];
                if (postalCode)
                    [postalCodeLabel setText:postalCode];
                else
                    [postalCodeLabel setText:@"Not found"];
            }
        }];
    }
}

@end
