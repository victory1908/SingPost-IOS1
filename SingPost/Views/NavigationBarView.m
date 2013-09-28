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
    UIButton *toggleSidebarButton;
    UILabel *titleLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_gradient_background"]]];
        
        toggleSidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [toggleSidebarButton setHidden:YES];
        [toggleSidebarButton setFrame:CGRectMake(10, 8, 30, 30)];
        [toggleSidebarButton setImage:[UIImage imageNamed:@"sidebar_button"] forState:UIControlStateNormal];
        [toggleSidebarButton addTarget:self action:@selector(toggleSidebarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:toggleSidebarButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
        [titleLabel setCenter:self.center];
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

- (void)setTitle:(NSString *)title
{
    [titleLabel setText:title];
}

#pragma mark - IBAction

- (IBAction)toggleSidebarButtonClicked:(id)sender
{
    [[AppDelegate sharedAppDelegate].rootViewController toggleSideBarVisiblity];
}

@end
