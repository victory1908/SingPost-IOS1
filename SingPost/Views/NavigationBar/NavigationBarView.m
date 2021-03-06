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
#import "ApiClient.h"

@implementation NavigationBarView
{
    UIButton *toggleSidebarButton, *backButton,*PDPABackButton;
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
        
        
        PDPABackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [PDPABackButton setHidden:YES];
        [PDPABackButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        [PDPABackButton setFrame:CGRectMake(0, 0, 44, 44)];
        [PDPABackButton addTarget:self action:@selector(PDPABackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:PDPABackButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 100, 44)];
        [titleLabel setCenter:self.center];
        [titleLabel setNumberOfLines:2];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
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

- (void)setToggleButtonEnable:(BOOL)isEnable
{
    [toggleSidebarButton setEnabled:isEnable];
}

- (void)setShowBackButton:(BOOL)showBackButton
{
    [backButton setHidden:!showBackButton];
}

- (void)setShowPDPABackButton{
    [PDPABackButton setHidden:NO];
}

- (void)setTitle:(NSString *)title
{
    [titleLabel setText:title];
    //[titleLabel sizeToFit];
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

- (IBAction)PDPABackButtonClicked:(id)sender
{
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
 
    
    [ApiClient sharedInstance].serverToken = @"";
    [[AppDelegate sharedAppDelegate].rootViewController cPopViewController];
}

@end
