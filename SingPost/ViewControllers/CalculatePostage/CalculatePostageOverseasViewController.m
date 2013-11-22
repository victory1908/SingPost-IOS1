//
//  CalculatePostageOverseasViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 14/11/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CalculatePostageOverseasViewController.h"
#import "CTextField.h"
#import "CDropDownListControl.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "FlatBlueButton.h"
#import "CalculatePostageResultsViewController.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import "CalculatePostageResultItem.h"

@interface CalculatePostageOverseasViewController () <UITextFieldDelegate>

@end

@implementation CalculatePostageOverseasViewController
{
    TPKeyboardAvoidingScrollView *contentScrollView;
    CTextField *weightTextField;
    NSNumberFormatter *numberFormatter;
    CDropDownListControl *toWhichCountryDropDownList, *weightUnitsDropDownList, *expectedDeliveryTimeInDaysDropDownList;
}

- (void)loadView
{
    contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentScrollView setDelaysContentTouches:NO];
    [contentScrollView setContentSize:CGSizeMake(320, 300)];
    [contentScrollView setBackgroundColor:RGB(240, 240, 240)];
    
    toWhichCountryDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(15, 15, 290, 44)];
    [toWhichCountryDropDownList setPlistValueFile:@"CalculatePostage_Countries"];
    [toWhichCountryDropDownList setPlaceholderText:@"To which country"];
    [contentScrollView addSubview:toWhichCountryDropDownList];
    
    weightTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 75, 175, 44)];
    [weightTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [weightTextField setDelegate:self];
    [weightTextField setPlaceholder:@"Weight"];
    [contentScrollView addSubview:weightTextField];
    
    weightUnitsDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(202, 75, 103, 44)];
    [weightUnitsDropDownList setPlistValueFile:@"CalculatePostage_WeightUnits"];
    [weightUnitsDropDownList selectRow:0 animated:NO];
    [contentScrollView addSubview:weightUnitsDropDownList];
    
    UILabel *allFieldMandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 125, 150, 20)];
    [allFieldMandatoryLabel setText:@"All fields are mandatory"];
    [allFieldMandatoryLabel setBackgroundColor:[UIColor clearColor]];
    [allFieldMandatoryLabel setTextColor:RGB(125, 136, 149)];
    [allFieldMandatoryLabel setFont:[UIFont SingPostLightItalicFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [contentScrollView addSubview:allFieldMandatoryLabel];
    
    expectedDeliveryTimeInDaysDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(15, 160, 290, 44)];
    [expectedDeliveryTimeInDaysDropDownList setPlistValueFile:@"CalculatePostage_ExpectedDeliveryTimeDays"];
    [expectedDeliveryTimeInDaysDropDownList setPlaceholderText:@"Expected delivery time (days)"];
    [contentScrollView addSubview:expectedDeliveryTimeInDaysDropDownList];
    
    FlatBlueButton *calculatePostageButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, 215, contentScrollView.bounds.size.width - 30, 48)];
    [calculatePostageButton addTarget:self action:@selector(calculatePostageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [calculatePostageButton setTitle:@"CALCULATE" forState:UIControlStateNormal];
    [contentScrollView addSubview:calculatePostageButton];
    
    self.view = contentScrollView;
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    [contentScrollView setContentSize:CGSizeMake(320, 200)];
//}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == weightTextField) {
        //only digits with 1 decimal place
        if (!numberFormatter)
            numberFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *match = [numberFormatter numberFromString:[textField.text stringByAppendingString:string]];  // in case we entered two decimals
        return (match != nil);
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - IBActions

- (IBAction)calculatePostageButtonClicked:(id)sender
{
    if ([toWhichCountryDropDownList.selectedValue length] == 0 || [weightTextField.text length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please ensure that all fields are entered correctly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeClear];
        
        NSString *weightInGrams = [weightUnitsDropDownList.selectedValue isEqualToString:WEIGHT_KG_CODE] ? [NSNumber numberWithFloat:[weightTextField.text floatValue] * 1000].stringValue : [NSNumber numberWithFloat:[weightTextField.text floatValue]].stringValue;
        
        [CalculatePostageResultItem API_calculateOverseasPostageForCountryCode:toWhichCountryDropDownList.selectedValue andWeight:weightInGrams andItemTypeCode:@"" andDeliveryCode:expectedDeliveryTimeInDaysDropDownList.selectedValue onCompletion:^(NSArray *items, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"An error has occurred"];
            }
            else {
                [SVProgressHUD dismiss];
                CalculatePostageResultsViewController *viewController = [[CalculatePostageResultsViewController alloc] initWithResultItems:items andResultType:CALCULATEPOSTAGE_RESULT_TYPE_OVERSEAS];
                viewController.toCountry = toWhichCountryDropDownList.selectedText;
                viewController.itemWeight = [NSString stringWithFormat:@"%@ %@", weightTextField.text, [weightUnitsDropDownList.selectedValue isEqualToString:WEIGHT_KG_CODE] ? WEIGHT_KG_UNIT : WEIGHT_G_UNIT];
                viewController.expectedDeliveryTime = expectedDeliveryTimeInDaysDropDownList.selectedRowIndex == 0 ? @"-" : [NSString stringWithFormat:@"%@ days", expectedDeliveryTimeInDaysDropDownList.selectedValue];
                [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            }
        }];
    }
}

@end
