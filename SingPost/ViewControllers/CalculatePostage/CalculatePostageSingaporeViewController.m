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
#import <TPKeyboardAvoidingScrollView.h>
#import "FlatBlueButton.h"
#import "CalculatePostageResultsViewController.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import "CalculatePostageResultItem.h"

#define NUM_DIGITS_SINGAPORE_POSTAL_CODES 6

@interface CalculatePostageSingaporeViewController () <UITextFieldDelegate>

@end

@implementation CalculatePostageSingaporeViewController

{
    TPKeyboardAvoidingScrollView *contentScrollView;
    CTextField *fromPostalCodeTextField, *toPostalCodeTextField, *weightTextField;
    CDropDownListControl *weightUnitsDropDownList;
    NSNumberFormatter *numberFormatter;
}

- (void)loadView
{
    contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentScrollView setDelaysContentTouches:NO];
    [contentScrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [contentScrollView setBackgroundColor:RGB(240, 240, 240)];
    
    fromPostalCodeTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 20, contentScrollView.width - 30, 44)];
    [fromPostalCodeTextField setDelegate:self];
    [fromPostalCodeTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [fromPostalCodeTextField setPlaceholder:@"From postal code"];
    [contentScrollView addSubview:fromPostalCodeTextField];
    
    toPostalCodeTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 75, contentScrollView.width - 30, 44)];
    [toPostalCodeTextField setDelegate:self];
    [toPostalCodeTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [toPostalCodeTextField setPlaceholder:@"To postal code"];
    [contentScrollView addSubview:toPostalCodeTextField];
    
    weightUnitsDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(202, 130, 103, 44)];
    weightUnitsDropDownList.right = toPostalCodeTextField.right;
    [weightUnitsDropDownList setPlistValueFile:@"CalculatePostage_WeightUnits"];
    [weightUnitsDropDownList selectRow:0 animated:NO];
    [contentScrollView addSubview:weightUnitsDropDownList];
    
    weightTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 130, toPostalCodeTextField.width - weightUnitsDropDownList.width - 10, 44)];
    [weightTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [weightTextField setDelegate:self];
    [weightTextField setDelegate:self];
    [weightTextField setPlaceholder:@"Weight"];
    [contentScrollView addSubview:weightTextField];
    
    UILabel *allFieldMandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 175, 290, 20)];
    [allFieldMandatoryLabel setText:@"All fields above are mandatory"];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Postage - Singapore"];
}


#pragma mark - UITextField Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == weightTextField) {
        //only digits with 1 decimal place
        if (!numberFormatter)
            numberFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *match = [numberFormatter numberFromString:[textField.text stringByAppendingString:string]];  // in case we entered two decimals
        return (match != nil);
    }
    else if (textField == fromPostalCodeTextField || textField == toPostalCodeTextField) {
        //only digits with no decimal place
        NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,20}$" options:0 error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
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
    if ([weightTextField.text length] == 0 || [fromPostalCodeTextField.text length] != NUM_DIGITS_SINGAPORE_POSTAL_CODES || [toPostalCodeTextField.text length] != NUM_DIGITS_SINGAPORE_POSTAL_CODES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:INCOMPLETE_FIELDS_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeClear];
        
        NSString *weightInGrams = [weightUnitsDropDownList.selectedValue isEqualToString:WEIGHT_KG_CODE] ? [NSNumber numberWithFloat:[weightTextField.text floatValue] * 1000].stringValue : [NSNumber numberWithFloat:[weightTextField.text floatValue]].stringValue;
        
        [CalculatePostageResultItem API_calculateSingaporePostageForFromPostalCode:fromPostalCodeTextField.text andToPostalCode:toPostalCodeTextField.text andWeight:weightInGrams onCompletion:^(NSArray *items, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"An error has occurred"];
            }
            else {
                [SVProgressHUD dismiss];
                
                if (items.count == 0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NO_RESULTS_ERROR delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alertView show];
                }
                else {
                    CalculatePostageResultsViewController *viewController = [[CalculatePostageResultsViewController alloc] initWithResultItems:items andResultType:CALCULATEPOSTAGE_RESULT_TYPE_SINGAPORE];
                    viewController.fromPostalCode = fromPostalCodeTextField.text;
                    viewController.toPostalCode = toPostalCodeTextField.text;
                    viewController.itemWeight = [NSString stringWithFormat:@"%@ %@", weightTextField.text, [weightUnitsDropDownList.selectedValue isEqualToString:WEIGHT_KG_CODE] ? WEIGHT_KG_UNIT : WEIGHT_G_UNIT];
                    viewController.expectedDeliveryTime = @"-";
                    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
                }
            }
        }];
    }
}

@end
