//
//  LocateUsListView.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LocateUsListView.h"
#import "CTextField.h"
#import "FlatBlueButton.h"
#import "CDropDownListControl.h"
#import "FlatBlueButton.h"
#import <MapKit/MapKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "UIView+Position.h"
#import "UIFont+SingPost.h"

@interface LocateUsListView () <CDropDownListControlDelegate>

@end


@implementation LocateUsListView
{
    CTextField *findByTextField;
    CDropDownListControl *typesDropDownList;
    TPKeyboardAvoidingScrollView *contentScrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.bounds];
        [contentScrollView setDelaysContentTouches:NO];
        [contentScrollView setBackgroundColor:RGB(250, 250, 250)];
        
        findByTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 15, 290, 44)];
        findByTextField.placeholderFontSize = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 11.0f : 9.0f;
        findByTextField.insetBoundsSize = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? CGSizeMake(12, 6) : CGSizeMake(12, 10);
        [findByTextField setPlaceholder:@"Find by street name,\nblk no., mrt station etc"];
        [contentScrollView addSubview:findByTextField];
        
        UIButton *locateUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [locateUsButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        [locateUsButton setFrame:CGRectMake(265, 24, 30, 30)];
        [locateUsButton addTarget:self action:@selector(locateUsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [contentScrollView addSubview:locateUsButton];
        
        typesDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(15, 70, 215, 44)];
        [typesDropDownList setPlistValueFile:@"LocateUs_Types"];
        [typesDropDownList setDelegate:self];
        [typesDropDownList selectRow:0 animated:NO];
        [contentScrollView addSubview:typesDropDownList];
        
        FlatBlueButton *goButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(235, 70, 70, 44)];
        [goButton addTarget:self action:@selector(goButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [goButton setTitle:@"GO" forState:UIControlStateNormal];
        [contentScrollView addSubview:goButton];
        
        UILabel *searchLocationsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, contentScrollView.bounds.size.width, 30)];
        [searchLocationsCountLabel setBackgroundColor:RGB(125, 136, 149)];
        [searchLocationsCountLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [searchLocationsCountLabel setTextColor:[UIColor whiteColor]];
        [searchLocationsCountLabel setText:@"     5 locations found"];
        [contentScrollView addSubview:searchLocationsCountLabel];

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

- (IBAction)goButtonClicked:(id)sender
{
    NSLog(@"go button clicked");
}

- (IBAction)locateUsButtonClicked:(id)sender
{
    NSLog(@"locate us clicked");
}

@end
