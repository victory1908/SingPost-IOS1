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
    [envelopBackgroundImageView setFrame:INTERFACE_IS_IPAD ? CGRectMake(0, 0, 768, 690) : CGRectMake(0, 0, 320, 276)];
    [contentView addSubview:envelopBackgroundImageView];
    
    UIImageView *trackingTextBoxBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trackingTextBox"]];
    [trackingTextBoxBackgroundImageView setFrame:CGRectMake(15, 80, 290, 47)];
    [contentView addSubview:trackingTextBoxBackgroundImageView];
    
    UIImageView *singPostLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_singaporepost"]];
    [singPostLogoImageView setFrame:INTERFACE_IS_IPAD ? CGRectMake(0, 0, 0, 0) : CGRectMake(82, 8, 155, 55)];
    [contentView addSubview:singPostLogoImageView];
    
    UIButton *toggleSidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleSidebarButton setFrame:CGRectMake(10, 10, 30, 30)];
    [toggleSidebarButton setImage:[UIImage imageNamed:@"sidebar_button"] forState:UIControlStateNormal];
    [toggleSidebarButton addTarget:self action:@selector(toggleSidebarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:toggleSidebarButton];
    
    //landing page buttons
#define NUM_ICON_HORIZONTAL 3.0f
#define ICON_WIDTH 90.0f
#define ICON_HEIGHT 90.0f
#define STARTING_OFFSET_X 30.0f
#define STARTING_OFFSET_Y 230.0f
    CGFloat offsetX, offsetY;
    
    offsetY = STARTING_OFFSET_Y;
    offsetX = STARTING_OFFSET_X;
    UIButton *landingCalculatePostageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [landingCalculatePostageButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [landingCalculatePostageButton setImage:[UIImage imageNamed:@"landing_calculatePostage"] forState:UIControlStateNormal];
    [contentView addSubview:landingCalculatePostageButton];

    offsetX += ICON_WIDTH;
    UIButton *landingPostalCodesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [landingPostalCodesButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [landingPostalCodesButton setImage:[UIImage imageNamed:@"landing_postalCodes"] forState:UIControlStateNormal];
    [contentView addSubview:landingPostalCodesButton];
    
    offsetX += ICON_WIDTH;
    UIButton *landingPageLocateUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [landingPageLocateUsButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [landingPageLocateUsButton setImage:[UIImage imageNamed:@"landing_locateUs"] forState:UIControlStateNormal];
    [contentView addSubview:landingPageLocateUsButton];

    offsetX = STARTING_OFFSET_X;
    offsetY += ICON_HEIGHT + 10.0f;
    UIButton *landingSendReceiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [landingSendReceiveButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [landingSendReceiveButton setImage:[UIImage imageNamed:@"landing_sendReceive"] forState:UIControlStateNormal];
    [contentView addSubview:landingSendReceiveButton];
    
    offsetX += ICON_WIDTH;
    UIButton *landingPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [landingPayButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [landingPayButton setImage:[UIImage imageNamed:@"landing_pay"] forState:UIControlStateNormal];
    [contentView addSubview:landingPayButton];
    
    offsetX += ICON_WIDTH;
    UIButton *landingShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [landingShopButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [landingShopButton setImage:[UIImage imageNamed:@"landing_shop"] forState:UIControlStateNormal];
    [contentView addSubview:landingShopButton];
    
    offsetX = STARTING_OFFSET_X;
    offsetY += ICON_HEIGHT + 10.0f;
    UIButton *landingMoreServicesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [landingMoreServicesButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [landingMoreServicesButton setImage:[UIImage imageNamed:@"landing_moreServices"] forState:UIControlStateNormal];
    [contentView addSubview:landingMoreServicesButton];
    
    offsetX += ICON_WIDTH;
    UIButton *landingStampCollectiblesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [landingStampCollectiblesButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [landingStampCollectiblesButton setImage:[UIImage imageNamed:@"landing_stampCollectibles"] forState:UIControlStateNormal];
    [contentView addSubview:landingStampCollectiblesButton];
    
    offsetX += ICON_WIDTH;
    UIButton *landingOffersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [landingOffersButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [landingOffersButton setImage:[UIImage imageNamed:@"landing_offers"] forState:UIControlStateNormal];
    [contentView addSubview:landingOffersButton];

    UIImageView *backgroundMore = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"background_more"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)]];
    [backgroundMore setFrame:CGRectMake(0, contentView.bounds.size.height - 46, contentView.bounds.size.width, 26)];
    [contentView addSubview:backgroundMore];
    
    self.view = contentView;
}

#pragma mark - IBActions

- (IBAction)toggleSidebarButtonClicked:(id)sender
{
    [[AppDelegate sharedAppDelegate] toggleSideBarVisiblity];
}

@end
