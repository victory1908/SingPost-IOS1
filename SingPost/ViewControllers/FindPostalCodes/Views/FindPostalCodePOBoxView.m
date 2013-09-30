//
//  FindPostalCodePOBoxView.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "FindPostalCodePOBoxView.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "CTextField.h"
#import "CDropDownListControl.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"
#import <QuartzCore/QuartzCore.h>

@interface FindPostalCodePOBoxView () <CDropDownListControlDelegate>

@end

@implementation FindPostalCodePOBoxView
{
    TPKeyboardAvoidingScrollView *contentScrollView;
    CTextField *idTextField, *postOfficeTextField;
    CDropDownListControl *typeDropDownList;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.bounds];
        [contentScrollView setDelaysContentTouches:NO];
        [contentScrollView setBackgroundColor:[UIColor clearColor]];
        
        idTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 20, 140, 44)];
        [contentScrollView addSubview:idTextField];
        
        typeDropDownList= [[CDropDownListControl alloc] initWithFrame:CGRectMake(160, 20, 150, 44)];
        [typeDropDownList setPlistValueFile:@"FindPostalCodes_Types"];
        [typeDropDownList setDelegate:self];
        [typeDropDownList selectRow:0 animated:NO];
        [contentScrollView addSubview:typeDropDownList];
        
        postOfficeTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 75, 290, 44)];
        [postOfficeTextField setPlaceholder:@"Post Office"];
        [contentScrollView addSubview:postOfficeTextField];
        
        UIButton *findButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [findButton setBackgroundImage:[[UIImage imageNamed:@"blue_bg_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] forState:UIControlStateNormal];
        [findButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [findButton setFrame:CGRectMake(15, 175, self.bounds.size.width - 30, 48)];
        [findButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [findButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
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

- (IBAction)findButtonClicked:(id)sender
{
    NSLog(@"find button clicked");
}


@end
