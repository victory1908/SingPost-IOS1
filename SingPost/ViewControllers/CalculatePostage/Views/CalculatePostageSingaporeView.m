//
//  CalculatePostageSingaporeView.m
//  SingPost
//
//  Created by Edward Soetiono on 29/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CalculatePostageSingaporeView.h"
#import "CTextField.h"
#import "CDropDownListControl.h"
#import "UIFont+SingPost.h"
#import <TPKeyboardAvoidingScrollView.h>

@interface CalculatePostageSingaporeView ()

@end

@implementation CalculatePostageSingaporeView
{
    CTextField *fromPostalCodeTextField, *toPostalCodeTextField, *weightTextField;
    CDropDownListControl *weightUnitsDropDownList;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.bounds];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        
        fromPostalCodeTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 20, 290, 44)];
        [fromPostalCodeTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [fromPostalCodeTextField setPlaceholder:@"From postal code"];
        [scrollView addSubview:fromPostalCodeTextField];
        
        toPostalCodeTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 75, 290, 44)];
        [toPostalCodeTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [toPostalCodeTextField setPlaceholder:@"To postal code"];
        [scrollView addSubview:toPostalCodeTextField];
        
        weightTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 130, 175, 44)];
        [weightTextField setPlaceholder:@"Weight"];
        [scrollView addSubview:weightTextField];
        
        weightUnitsDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(205, 130, 100, 44)];
        [weightUnitsDropDownList setPlistValueFile:@"CalculatePostage_WeightUnits"];
        [scrollView addSubview:weightUnitsDropDownList];
        
        UILabel *allFieldMandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 175, 150, 20)];
        [allFieldMandatoryLabel setText:@"All fields are mandatory"];
        [allFieldMandatoryLabel setTextColor:RGB(125, 136, 149)];
        [allFieldMandatoryLabel setFont:[UIFont SingPostLightItalicFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [scrollView addSubview:allFieldMandatoryLabel];
        
        UIButton *calculatePostageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [calculatePostageButton setBackgroundImage:[[UIImage imageNamed:@"blue_bg_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] forState:UIControlStateNormal];
        [calculatePostageButton.titleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [calculatePostageButton setFrame:CGRectMake(15, 210, self.bounds.size.width - 30, 48)];
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

- (IBAction)calculatePostageButtonClicked:(id)sender
{
    NSLog(@"beep beep");
}

@end
