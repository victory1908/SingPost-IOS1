//
//  LandingPageViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LandingPageViewController.h"
#import "AppDelegate.h"
#import "UIFont+SingPost.h"
#import "UIColor+SingPost.h"
#import "UIView+Position.h"
#import "CTextField.h"
#import "OffersMoreMenuView.h"

#import "TrackingMainViewController.h"
#import "CalculatePostageViewController.h"
#import "FindPostalCodesMainViewController.h"
#import "LocateUsMainViewController.h"
#import "SendReceiveMainViewController.h"
#import "PaymentMainViewController.h"
#import "ShopMainViewController.h"
#import "MoreServicesMainViewController.h"
#import "FeedbackViewController.h"
#import "TermsOfUseViewController.h"
#import "StampCollectiblesMainViewController.h"
#import "AboutThisAppViewController.h"
#import "OffersMainViewController.h"
#import "MoreAppsViewController.h"
#import "FAQViewController.h"

typedef enum {
    LANDINGPAGEBUTTON_CALCULATEPOSTAGE = 1,
    LANDINGPAGEBUTTON_POSTALCODES,
    LANDINGPAGEBUTTON_LOCATEUS,
    LANDINGPAGEBUTTON_SENDRECEIVE,
    LANDINGPAGEBUTTON_PAY,
    LANDINGPAGEBUTTON_SHOP,
    LANDINGPAGEBUTTON_MORESERVICES,
    LANDINGPAGEBUTTON_STAMPCOLLECTIBLES,
    LANDINGPAGEBUTTON_MOREAPPS
} tLandingPageButtons;

@interface LandingPageViewController () <UITextFieldDelegate, OffersMenuDelegate>

@end

@implementation LandingPageViewController
{
    CTextField *trackingNumberTextField;
    OffersMoreMenuView *offersMoreMenuView;
}

#pragma mark - View lifecycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *envelopBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:INTERFACE_IS_4INCHSCREEN ? @"background_envelope" : @"35iphone_background_envelope"]];
    [envelopBackgroundImageView setUserInteractionEnabled:YES];
    [envelopBackgroundImageView setFrame:(INTERFACE_IS_4INCHSCREEN ? CGRectMake(0, 0, 320, 276) : CGRectMake(0, 0, 320, 248))];
    [contentView addSubview:envelopBackgroundImageView];
    
    trackingNumberTextField = [[CTextField alloc] initWithFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(20, 80, 280, 47) : CGRectMake(20, 70, 280, 30)];
    [trackingNumberTextField setBackground:[UIImage imageNamed:@"trackingTextBox"]];
    [trackingNumberTextField setFontSize:INTERFACE_IS_4INCHSCREEN ? 16.0f : 14.0f];
    [trackingNumberTextField setInsetBoundsSize: INTERFACE_IS_4INCHSCREEN ? CGSizeMake(14, 12) : CGSizeMake(14, 3)];
    [trackingNumberTextField setPlaceholder:@"Last tracking number entered"];
    [trackingNumberTextField setReturnKeyType:UIReturnKeySend];
    [trackingNumberTextField setDelegate:self];
    [contentView addSubview:trackingNumberTextField];
    
    UIButton *findTrackingNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [findTrackingNumberButton setImage:[UIImage imageNamed:@"tracking_button"] forState:UIControlStateNormal];
    [findTrackingNumberButton setFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(260, 87, 35, 35) : CGRectMake(269, 72, 29, 29)];
    [findTrackingNumberButton addTarget:self action:@selector(findTrackingNumberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:findTrackingNumberButton];
    
    UIImageView *singPostLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_singaporepost"]];
    [singPostLogoImageView setFrame:CGRectMake(82, 8, 155, 55)];
    [contentView addSubview:singPostLogoImageView];
    
    UIButton *toggleSidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleSidebarButton setFrame:CGRectMake(10, 10, 30, 30)];
    [toggleSidebarButton setImage:[UIImage imageNamed:@"sidebar_button"] forState:UIControlStateNormal];
    [toggleSidebarButton addTarget:self action:@selector(toggleSidebarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:toggleSidebarButton];
    
    //landing page buttons
#define NUM_ICON_HORIZONTAL 3.0f
#define ICON_WIDTH (INTERFACE_IS_4INCHSCREEN ? 90.0f : 80.0f)
#define ICON_HEIGHT (INTERFACE_IS_4INCHSCREEN ? 90.0f : 80.0f)
#define ICON_SPACING_VERTICAL (INTERFACE_IS_4INCHSCREEN ? 10.0f : 5.0f)
#define STARTING_OFFSET_X (INTERFACE_IS_4INCHSCREEN ? 30.0f : 40.0f)
#define STARTING_OFFSET_Y (INTERFACE_IS_4INCHSCREEN ? 230.0f : 185.0f)
    CGFloat offsetX, offsetY;
    
    offsetY = STARTING_OFFSET_Y;
    offsetX = STARTING_OFFSET_X;
    UIButton *menuCalculatePostageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuCalculatePostageButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuCalculatePostageButton setImage:[UIImage imageNamed:@"landing_calculatePostage"] forState:UIControlStateNormal];
    [menuCalculatePostageButton setTag:LANDINGPAGEBUTTON_CALCULATEPOSTAGE];
    [menuCalculatePostageButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuCalculatePostageButton];

    offsetX += ICON_WIDTH;
    UIButton *menuPostalCodesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuPostalCodesButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuPostalCodesButton setImage:[UIImage imageNamed:@"landing_postalCodes"] forState:UIControlStateNormal];
    [menuPostalCodesButton setTag:LANDINGPAGEBUTTON_POSTALCODES];
    [menuPostalCodesButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuPostalCodesButton];
    
    offsetX += ICON_WIDTH;
    UIButton *menuPageLocateUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuPageLocateUsButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuPageLocateUsButton setImage:[UIImage imageNamed:@"landing_locateUs"] forState:UIControlStateNormal];
    [menuPageLocateUsButton setTag:LANDINGPAGEBUTTON_LOCATEUS];
    [menuPageLocateUsButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuPageLocateUsButton];

    offsetX = STARTING_OFFSET_X;
    offsetY += ICON_HEIGHT + ICON_SPACING_VERTICAL;
    UIButton *menuSendReceiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuSendReceiveButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuSendReceiveButton setTag:LANDINGPAGEBUTTON_SENDRECEIVE];
    [menuSendReceiveButton setImage:[UIImage imageNamed:@"landing_sendReceive"] forState:UIControlStateNormal];
    [menuSendReceiveButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuSendReceiveButton];
    
    offsetX += ICON_WIDTH;
    UIButton *menuPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuPayButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuPayButton setTag:LANDINGPAGEBUTTON_PAY];
    [menuPayButton setImage:[UIImage imageNamed:@"landing_pay"] forState:UIControlStateNormal];
    [menuPayButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuPayButton];
    
    offsetX += ICON_WIDTH;
    UIButton *menuShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuShopButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuShopButton setTag:LANDINGPAGEBUTTON_SHOP];
    [menuShopButton setImage:[UIImage imageNamed:@"landing_shop"] forState:UIControlStateNormal];
    [menuShopButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuShopButton];
    
    offsetX = STARTING_OFFSET_X;
    offsetY += ICON_HEIGHT + ICON_SPACING_VERTICAL;
    UIButton *menuMoreServicesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuMoreServicesButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuMoreServicesButton setTag:LANDINGPAGEBUTTON_MORESERVICES];
    [menuMoreServicesButton setImage:[UIImage imageNamed:@"landing_moreServices"] forState:UIControlStateNormal];
    [menuMoreServicesButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuMoreServicesButton];
    
    offsetX += ICON_WIDTH;
    UIButton *menuStampCollectiblesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuStampCollectiblesButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuStampCollectiblesButton setTag:LANDINGPAGEBUTTON_STAMPCOLLECTIBLES];
    [menuStampCollectiblesButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [menuStampCollectiblesButton setImage:[UIImage imageNamed:@"landing_stampCollectibles"] forState:UIControlStateNormal];
    [contentView addSubview:menuStampCollectiblesButton];
    
    offsetX += ICON_WIDTH;
    UIButton *menuMoreAppsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuMoreAppsButton setFrame:CGRectMake(offsetX, offsetY, ICON_WIDTH, ICON_HEIGHT)];
    [menuMoreAppsButton setImage:[UIImage imageNamed:@"landing_moreApps"] forState:UIControlStateNormal];
    [menuMoreAppsButton setTag:LANDINGPAGEBUTTON_MOREAPPS];
    [menuMoreAppsButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:menuMoreAppsButton];
    
    offersMoreMenuView = [[OffersMoreMenuView alloc] initWithFrame:CGRectMake(0, contentView.bounds.size.height - 52, contentView.bounds.size.width, 500)];
    [offersMoreMenuView setDelegate:self];
    [contentView addSubview:offersMoreMenuView];
    
    self.view = contentView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [trackingNumberTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == trackingNumberTextField) {
        TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
        trackingMainViewController.trackingNumber = trackingNumberTextField.text;
        [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:trackingMainViewController];
    }
    
    return YES;
}

#pragma mark - OffersMenuDelegate

- (void)toggleShowOffersMoreMenu
{
    offersMoreMenuView.isShown = !offersMoreMenuView.isShown;
    
    if (offersMoreMenuView.isShown) {
#define TAG_CLOSEOFFERSMENUBUTTON 333
        UIButton *closeOffersMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeOffersMenuButton setTag:TAG_CLOSEOFFERSMENUBUTTON];
        [closeOffersMenuButton setBackgroundColor:[UIColor colorWithWhite:0.3f alpha:0.5f]];
        [closeOffersMenuButton setFrame:self.view.bounds];
        [closeOffersMenuButton setAlpha:0.0f];
        [closeOffersMenuButton addTarget:self action:@selector(toggleShowOffersMoreMenu) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:closeOffersMenuButton belowSubview:offersMoreMenuView];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        if (offersMoreMenuView.isShown) {
            [offersMoreMenuView setY:self.view.bounds.size.height - 236];
            [[self.view viewWithTag:TAG_CLOSEOFFERSMENUBUTTON] setAlpha:1.0f];
        }
        else {
            [offersMoreMenuView setY:self.view.bounds.size.height - 52];
            [[self.view viewWithTag:TAG_CLOSEOFFERSMENUBUTTON] removeFromSuperview];
        }
        
    }];
}

#pragma mark - IBActions

- (IBAction)menuButtonClicked:(UIButton *)sender
{
    tLandingPageButtons landingPageButton = ((UIButton *)sender).tag;
    
    switch (landingPageButton) {
        case LANDINGPAGEBUTTON_CALCULATEPOSTAGE:
        {
            CalculatePostageViewController *viewController = [[CalculatePostageViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case LANDINGPAGEBUTTON_POSTALCODES:
        {
            FindPostalCodesMainViewController *viewController = [[FindPostalCodesMainViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case LANDINGPAGEBUTTON_LOCATEUS:
        {
            LocateUsMainViewController *viewController = [[LocateUsMainViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case LANDINGPAGEBUTTON_SENDRECEIVE:
        {
            SendReceiveMainViewController *viewController = [[SendReceiveMainViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case LANDINGPAGEBUTTON_PAY:
        {
            PaymentMainViewController *viewController = [[PaymentMainViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case LANDINGPAGEBUTTON_SHOP:
        {
            ShopMainViewController *viewController = [[ShopMainViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case LANDINGPAGEBUTTON_MORESERVICES:
        {
            MoreServicesMainViewController *viewController = [[MoreServicesMainViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case LANDINGPAGEBUTTON_STAMPCOLLECTIBLES:
        {
            StampCollectiblesMainViewController *viewController = [[StampCollectiblesMainViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case LANDINGPAGEBUTTON_MOREAPPS:
        {
            MoreAppsViewController *viewController = [[MoreAppsViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        default:
            NSLog(@"not yet implemented");
            break;
    }
}

- (void)offersMenuButtonClicked:(tOffersMenuButtons)button
{
    [self toggleShowOffersMoreMenu];
    switch (button) {
        case OFFERSMENUBUTTON_OFFERS:
        {
            OffersMainViewController *viewController = [[OffersMainViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case OFFERSMENUBUTTON_FEEDBACK:
        {
            FeedbackViewController *viewController = [[FeedbackViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case OFFERSMENUBUTTON_TERMSOFUSE:
        {
            TermsOfUseViewController *viewController = [[TermsOfUseViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case OFFERSMENUBUTTON_ABOUTTHISAPP:
        {
            AboutThisAppViewController *viewController = [[AboutThisAppViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case OFFERSMENUBUTTON_FAQS:
        {
            FAQViewController *viewController = [[FAQViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case OFFERSMENUBUTTON_RATEOURAPP:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/sg/app/singpost-mobile/id647986630"]];
            break;
        }
        default:
            NSLog(@"offers menu button not implemented yet");
            break;
    }
}

- (IBAction)offersMoreButtonClicked:(id)sender
{
    NSLog(@"offers more button clicked");
}

- (void)findTrackingNumberButtonClicked:(id)sender
{
    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
    trackingMainViewController.trackingNumber = trackingNumberTextField.text;
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:trackingMainViewController];
}

- (IBAction)toggleSidebarButtonClicked:(id)sender
{
    [[AppDelegate sharedAppDelegate].rootViewController toggleSideBarVisiblity];
}

@end
