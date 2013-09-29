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
#import "UIView+Position.h"
#import <TPKeyboardAvoidingScrollView.h>

@interface CalculatePostageSingaporeView () <CDropDownListControlDelegate>

@end

@implementation CalculatePostageSingaporeView
{
    TPKeyboardAvoidingScrollView *contentScrollView;
    CTextField *fromPostalCodeTextField, *toPostalCodeTextField, *weightTextField;
    CDropDownListControl *weightUnitsDropDownList;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.bounds];
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
        
        weightUnitsDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(205, 130, 100, 44)];
        [weightUnitsDropDownList setPlistValueFile:@"CalculatePostage_WeightUnits"];
        [weightUnitsDropDownList setDelegate:self];
        [weightUnitsDropDownList selectRow:0 animated:NO];
        [contentScrollView addSubview:weightUnitsDropDownList];
        
        UILabel *allFieldMandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 175, 150, 20)];
        [allFieldMandatoryLabel setText:@"All fields are mandatory"];
        [allFieldMandatoryLabel setBackgroundColor:[UIColor clearColor]];
        [allFieldMandatoryLabel setTextColor:RGB(125, 136, 149)];
        [allFieldMandatoryLabel setFont:[UIFont SingPostLightItalicFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [contentScrollView addSubview:allFieldMandatoryLabel];
        
        UIButton *calculatePostageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [calculatePostageButton setBackgroundImage:[[UIImage imageNamed:@"blue_bg_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] forState:UIControlStateNormal];
        [calculatePostageButton.titleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [calculatePostageButton setFrame:CGRectMake(15, 210, self.bounds.size.width - 30, 48)];
        [calculatePostageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [calculatePostageButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [calculatePostageButton addTarget:self action:@selector(calculatePostageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [calculatePostageButton setTitle:@"CALCULATE" forState:UIControlStateNormal];
        [contentScrollView addSubview:calculatePostageButton];
        
        [self addSubview:contentScrollView];
    }
    return self;
}

- (BOOL)endEditing:(BOOL)force
{
    [weightUnitsDropDownList resignFirstResponder];
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
