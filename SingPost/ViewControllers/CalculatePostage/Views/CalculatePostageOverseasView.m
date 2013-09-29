
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
#import <TPKeyboardAvoidingScrollView.h>

@implementation CalculatePostageOverseasView
{
    CTextField *weightTextField;
    CDropDownListControl *toWhichCountryDropDownList, *weightUnitsDropDownList, *expectedDeliveryTimeInDaysDropDownList;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.bounds];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        
        toWhichCountryDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(15, 20, 290, 44)];
        [toWhichCountryDropDownList setPlistValueFile:@"CalculatePostage_Countries"];
        [toWhichCountryDropDownList setPlaceholderText:@"To which country"];
        [scrollView addSubview:toWhichCountryDropDownList];
        
        weightTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 80, 175, 44)];
        [weightTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [weightTextField setPlaceholder:@"Weight"];
        [scrollView addSubview:weightTextField];
        
        weightUnitsDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(205, 80, 100, 44)];
        [weightUnitsDropDownList setPlistValueFile:@"CalculatePostage_WeightUnits"];
        [scrollView addSubview:weightUnitsDropDownList];
        
        UILabel *allFieldMandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 150, 20)];
        [allFieldMandatoryLabel setText:@"All fields are mandatory"];
        [allFieldMandatoryLabel setTextColor:RGB(125, 136, 149)];
        [allFieldMandatoryLabel setFont:[UIFont SingPostLightItalicFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [scrollView addSubview:allFieldMandatoryLabel];
        
        expectedDeliveryTimeInDaysDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(15, 165, 290, 44)];
        [expectedDeliveryTimeInDaysDropDownList setPlistValueFile:@"CalculatePostage_ExpectedDeliveryTimeDays"];
        [expectedDeliveryTimeInDaysDropDownList setPlaceholderText:@"Expected delivery time (days)"];
        [scrollView addSubview:expectedDeliveryTimeInDaysDropDownList];
        
        UIButton *calculatePostageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [calculatePostageButton setBackgroundImage:[[UIImage imageNamed:@"blue_bg_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] forState:UIControlStateNormal];
        [calculatePostageButton.titleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [calculatePostageButton setFrame:CGRectMake(15, 220, self.bounds.size.width - 30, 48)];
        [calculatePostageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [calculatePostageButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [calculatePostageButton addTarget:self action:@selector(calculatePostageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [calculatePostageButton setTitle:@"CALCULATE" forState:UIControlStateNormal];
        [scrollView addSubview:calculatePostageButton];

        [self addSubview:scrollView];
    }
    return self;
}

#pragma mark - IBActions

#pragma mark - IBActions

- (IBAction)calculatePostageButtonClicked:(id)sender
{
    NSLog(@"beep beep");
}

@end
