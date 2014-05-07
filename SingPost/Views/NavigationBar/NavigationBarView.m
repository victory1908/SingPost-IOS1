//
//  NavigationBarView.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "NavigationBarView.h"
#import "AppDelegate.h"
#import "UIFont+SingPost.h"

@implementation NavigationBarView
{
    UIButton *toggleSidebarButton, *backButton;
    UILabel *titleLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_gradient_background"]]];
        
        toggleSidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [toggleSidebarButton setHidden:YES];
        [toggleSidebarButton setFrame:CGRectMake(0, 0, 44, 44)];
        [toggleSidebarButton setImage:[UIImage imageNamed:@"sidebar_button"] forState:UIControlStateNormal];
        [toggleSidebarButton addTarget:self action:@selector(toggleSidebarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:toggleSidebarButton];
        
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setHidden:YES];
        [backButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        [backButton setFrame:CGRectMake(0, 0, 44, 44)];
        [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 44)];
        [titleLabel setCenter:self.center];
        [titleLabel setNumberOfLines:2];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:titleLabel];
    }
    return self;
}

#pragma mark - Accessors

- (void)setShowSidebarToggleButton:(BOOL)showSidebarToggleButton
{
    [toggleSidebarButton setHidden:!showSidebarToggleButton];
}

- (void)setShowBackButton:(BOOL)showBackButton
{
    [backButton setHidden:!showBackButton];
}

- (void)setTitle:(NSString *)title
{
    [titleLabel setText:title];
}

- (void)setTitleFontSize:(CGFloat)titleFontSize
{
    [titleLabel setFont:[UIFont SingPostLightFontOfSize:titleFontSize fontKey:kSingPostFontOpenSans]];
}

#pragma mark - IBAction

- (IBAction)toggleSidebarButtonClicked:(id)sender
{
    [[AppDelegate sharedAppDelegate].rootViewController toggleSideBarVisiblity];
}

- (IBAction)backButtonClicked:(id)sender
{
    [[AppDelegate sharedAppDelegate].rootViewController cPopViewController];
}

@end
