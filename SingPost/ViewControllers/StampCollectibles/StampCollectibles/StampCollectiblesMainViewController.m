//
//  StampCollectiblesMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 14/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "StampCollectiblesMainViewController.h"
#import "NavigationBarView.h"
#import "CDropDownListControl.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"

@interface StampCollectiblesMainViewController () <CDropDownListControlDelegate>

@end

@implementation StampCollectiblesMainViewController
{
    UIScrollView *contentScrollView;
    UILabel *chosenYearLabel;
    CDropDownListControl *yearDropDownList;
}

- (void)loadView
{
    contentScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentScrollView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Stamp Collectibles"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentScrollView addSubview:navigationBarView];
    
    UIImageView *featuredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, contentScrollView.bounds.size.width, 186)];
    [featuredImageView setImage:[UIImage imageNamed:@"sample_stamps_featured_image"]];
    [contentScrollView addSubview:featuredImageView];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 230, contentScrollView.bounds.size.width, 0.5f)];
    [topSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [topSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentScrollView addSubview:topSeparatorView];
    
    UIView *yearSectionBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 230.5, contentScrollView.bounds.size.width, 60)];
    [yearSectionBackgroundView setBackgroundColor:RGB(240, 240, 240)];
    [contentScrollView addSubview:yearSectionBackgroundView];
    
    chosenYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 240, 200, 44)];
    [chosenYearLabel setBackgroundColor:[UIColor clearColor]];
    [chosenYearLabel setTextColor:RGB(195, 17, 38)];
    [chosenYearLabel setText:@"2013 Collections"];
    [chosenYearLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [contentScrollView addSubview:chosenYearLabel];
    
    yearDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(contentScrollView.bounds.size.width - 95, 240, 80, 44)];
    [yearDropDownList setValues:@[@{@"code": @"2013 Collections", @"value": @"2013"}, @{@"code": @"2012 Collections", @"value": @"2012"}]];
    [yearDropDownList setDelegate:self];
    [yearDropDownList selectRow:0 animated:NO];
    [contentScrollView addSubview:yearDropDownList];

    self.view = contentScrollView;
}

#pragma mark - CDropDownListControlDelegate

- (void)repositionRelativeTo:(CDropDownListControl *)control byVerticalHeight:(CGFloat)offsetHeight
{
    [self.view endEditing:YES];
    
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
            [contentScrollView setContentOffset:CGPointMake(0, control.frame.origin.y - 100) animated:YES];
        else
            [contentScrollView setContentOffset:CGPointZero animated:YES];
    }];
}

- (void)dropDownListIsDismissed:(CDropDownListControl *)control
{
    if (control == yearDropDownList)
        [chosenYearLabel setText:yearDropDownList.selectedValue];
}

@end
