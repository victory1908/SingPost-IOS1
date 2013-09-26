//
//  LandingPageViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LandingPageViewController.h"
#import "AppDelegate.h"

@interface LandingPageViewController ()

@end

@implementation LandingPageViewController

#pragma mark - View lifecycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *envelopBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_envelope"]];
    [envelopBackgroundImageView setFrame:INTERFACE_IS_IPAD ? CGRectMake(0, 0, 768, 690) : CGRectMake(0, 0, 320, 288)];
    [contentView addSubview:envelopBackgroundImageView];
    
    UIImageView *singPostLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_singaporepost"]];
    [singPostLogoImageView setFrame:INTERFACE_IS_IPAD ? CGRectMake(0, 0, 0, 0) : CGRectMake(82, 8, 155, 55)];
    [contentView addSubview:singPostLogoImageView];
    
    UIButton *toggleSidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleSidebarButton setFrame:CGRectMake(10, 10, 30, 30)];
    [toggleSidebarButton setImage:[UIImage imageNamed:@"sidebar_button"] forState:UIControlStateNormal];
    [toggleSidebarButton addTarget:self action:@selector(toggleSidebarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:toggleSidebarButton];
    
    self.view = contentView;
}

#pragma mark - IBActions

- (IBAction)toggleSidebarButtonClicked:(id)sender
{
    [[AppDelegate sharedAppDelegate] toggleSideBarVisiblity];
}

@end
