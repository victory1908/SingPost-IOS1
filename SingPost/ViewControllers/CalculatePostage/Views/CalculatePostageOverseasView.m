
//
//  CalculatePostageOverseasView.m
//  SingPost
//
//  Created by Edward Soetiono on 29/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CalculatePostageOverseasView.h"
#import "CTextField.h"
#import "CDropDownListControl.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"
#import <TPKeyboardAvoidingScrollView.h>

@interface CalculatePostageOverseasView () <CDropDownListControlDelegate>

@end

@implementation CalculatePostageOverseasView
{
    TPKeyboardAvoidingScrollView *contentScrollView;
    CTextField *weightTextField;
    CDropDownListControl *toWhichCountryDropDownList, *weightUnitsDropDownList, *expectedDeliveryTimeInDaysDropDownList;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.bounds];
        [contentScrollView setDelaysContentTouches:NO];
        [contentScrollView setBackgroundColor:RGB(240, 240, 240)];
        
        toWhichCountryDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(15, 15, 290, 44)];
        [toWhichCountryDropDownList setPlistValueFile:@"CalculatePostage_Countries"];
        [toWhichCountryDropDownList setPlaceholderText:@"To which country"];
        [toWhichCountryDropDownList setDelegate:self];
        [contentScrollView addSubview:toWhichCountryDropDownList];
        
        weightTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 75, 175, 44)];
        [weightTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [weightTextField setPlaceholder:@"Weight"];
        [contentScrollView addSubview:weightTextField];

        weightUnitsDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(205, 75, 100, 44)];
        [weightUnitsDropDownList setPlistValueFile:@"CalculatePostage_WeightUnits"];
        [weightUnitsDropDownList setDelegate:self];
        [weightUnitsDropDownList selectRow:0 animated:NO];
        [contentScrollView addSubview:weightUnitsDropDownList];
        
        UILabel *allFieldMandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 125, 150, 20)];
        [allFieldMandatoryLabel setText:@"All fields are mandatory"];
        [allFieldMandatoryLabel setBackgroundColor:[UIColor clearColor]];
        [allFieldMandatoryLabel setTextColor:RGB(125, 136, 149)];
        [allFieldMandatoryLabel setFont:[UIFont SingPostLightItalicFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [contentScrollView addSubview:allFieldMandatoryLabel];
        
        expectedDeliveryTimeInDaysDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(15, 160, 290, 44)];
        [expectedDeliveryTimeInDaysDropDownList setDelegate:self];
        [expectedDeliveryTimeInDaysDropDownList setPlistValueFile:@"CalculatePostage_ExpectedDeliveryTimeDays"];
        [expectedDeliveryTimeInDaysDropDownList setPlaceholderText:@"Expected delivery time (days)"];
        [contentScrollView addSubview:expectedDeliveryTimeInDaysDropDownList];
        
        UIButton *calculatePostageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [calculatePostageButton setBackgroundImage:[[UIImage imageNamed:@"blue_bg_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] forState:UIControlStateNormal];
        [calculatePostageButton.titleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [calculatePostageButton setFrame:CGRectMake(15, 215, self.bounds.size.width - 30, 48)];
        [calculatePostageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [calculatePostageButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [calculatePostageButton addTarget:self action:@selector(calculatePostageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [calculatePostageButton setTitle:@"CALCULATE" forState:UIControlStateNormal];
        [contentScrollView addSubview:calculatePostageButton];

        [contentScrollView setContentSize:contentScrollView.bounds.size];
        [self addSubview:contentScrollView];
    }
    return self;
}

- (BOOL)endEditing:(BOOL)force
{
    [toWhichCountryDropDownList resignFirstResponder];
    [weightUnitsDropDownList resignFirstResponder];
    [expectedDeliveryTimeInDaysDropDownList resignFirstResponder];
    return [super endEditing:force];
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

- (IBAction)calculatePostageButtonClicked:(id)sender
{
    NSLog(@"beep beep");
}

@end
