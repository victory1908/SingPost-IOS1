//
//  SidebarMenuViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SidebarMenuViewController.h"
#import "UIFont+SingPost.h"
#import "UIColor+SingPost.h"
#import "SidebarMenuTableViewCell.h"
#import "SidebarMenuSubRowTableViewCell.h"
#import "AppDelegate.h"

#import "CalculatePostageMainViewController.h"
#import "LandingPageViewController.h"
#import "FindPostalCodesMainViewController.h"
#import "TrackingMainViewController.h"
#import "LocateUsMainViewController.h"
#import "SendReceiveMainViewController.h"
#import "PaymentMainViewController.h"
#import "ShopMainViewController.h"
#import "MoreServicesMainViewController.h"
#import "StampCollectiblesMainViewController.h"
#import "OffersMainViewController.h"
#import "MoreAppsViewController.h"

#import "FeedbackViewController.h"
#import "AboutThisAppViewController.h"
#import "TermsOfUseViewController.h"
#import "FAQViewController.h"
#import "MaintanancePageViewController.h"

#import "ItemTracking.h"
#import <SVProgressHUD.h>

@interface SidebarTrackingNumberTextField : UITextField

@end

@implementation SidebarTrackingNumberTextField

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.background = [UIImage imageNamed:@"trackingTextBox"];
        self.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor SingPostBlueColor];
        self.font = [UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans];
    }
    
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    [RGB(163, 163, 163) setFill];
    [[self placeholder] drawInRect:CGRectInset(rect, 0, 2)  withFont:[UIFont SingPostLightItalicFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 6);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 6);
}

@end

@interface SidebarMenuViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end

@implementation SidebarMenuViewController
{
    UIButton *landingPageButton;
    SidebarTrackingNumberTextField *trackingNumberTextField;
    UITableView *menuTableView;
    
    BOOL showOffersMoreSubrows;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat offsetY = 10.0f;
    UIImageView *singPostLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_singaporepost_colored"]];
    [singPostLogoImageView setFrame:CGRectMake(10, offsetY, 120, 44)];
    [contentView addSubview:singPostLogoImageView];
    
    landingPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [landingPageButton setImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [landingPageButton addTarget:self action:@selector(landingPageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [landingPageButton setFrame:CGRectMake(SIDEBAR_WIDTH - 50, offsetY + 2, 44, 44)];
    [contentView addSubview:landingPageButton];
    
    offsetY += 55.0f;
    
    menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offsetY, contentView.bounds.size.width, contentView.bounds.size.height - offsetY) style:UITableViewStylePlain];
    [menuTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [menuTableView setDelegate:self];
    [menuTableView setDataSource:self];
    [menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [menuTableView setSeparatorColor:[UIColor clearColor]];
    [menuTableView setShowsVerticalScrollIndicator:NO];
    [menuTableView setBackgroundView:nil];
    [contentView addSubview:menuTableView];
    
    UIImageView *dropShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop-shadow"]];
    [dropShadowImageView setFrame:CGRectMake(SIDEBAR_WIDTH - 25, 0, 25, 640)];
    [contentView addSubview:dropShadowImageView];
    
    self.view = contentView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateMaintananceStatusUIs];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [trackingNumberTextField resignFirstResponder];
}

- (void)updateMaintananceStatusUIs
{
    [menuTableView reloadData];
}

#pragma mark - IBActions

- (IBAction)landingPageButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    LandingPageViewController *landingPageViewController = [[LandingPageViewController alloc] initWithNibName:nil bundle:nil];
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:landingPageViewController];
}

- (IBAction)findTrackingNumberButtonClicked:(id)sender
{
    if (trackingNumberTextField.text.length > 0) {
        [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
        [ItemTracking API_getItemTrackingDetailsForTrackingNumber:trackingNumberTextField.text onCompletion:^(BOOL success, NSError *error) {
            [self.view endEditing:YES];
            if (success) {
                [SVProgressHUD dismiss];
                TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
                trackingMainViewController.trackingNumber = trackingNumberTextField.text;
                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:trackingMainViewController];
            }
            else {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
        }];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"Please enter tracking number"];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == trackingNumberTextField) {
        [self findTrackingNumberButtonClicked:nil];
    }
    return YES;
}

#pragma mark - UIGestures

- (void)handleResignRespondersTapped:(UITapGestureRecognizer *)tapGesture
{
    [trackingNumberTextField resignFirstResponder];
}

#pragma mark - UITableView DataSource & Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    [headerView setBackgroundColor:RGB(238, 238, 238)];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerView.bounds.size.width, 1)];
    [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [separatorView setBackgroundColor:RGB(196, 197, 200)];
    [headerView addSubview:separatorView];
    
    UILabel *trackLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 80, 14)];
    [trackLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [trackLabel setText:@"Track"];
    [trackLabel setTextColor:RGB(58, 68, 81)];
    [trackLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:trackLabel];
    
    UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
    [starImageView setFrame:CGRectMake(SIDEBAR_WIDTH - 38, 9, 20, 20)];
    [headerView addSubview:starImageView];
    
    trackingNumberTextField = [[SidebarTrackingNumberTextField alloc] initWithFrame:CGRectMake(15, 35, SIDEBAR_WIDTH - 35, 30)];
    [trackingNumberTextField setBackgroundColor:[UIColor clearColor]];
    [trackingNumberTextField setReturnKeyType:UIReturnKeySend];
    [trackingNumberTextField setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [trackingNumberTextField setDelegate:self];
    [trackingNumberTextField setPlaceholder:@"Please enter tracking number"];
    [trackingNumberTextField setText:[ItemTracking lastKnownTrackingNumber]];
    [headerView addSubview:trackingNumberTextField];
    
    UIButton *findTrackingNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [findTrackingNumberButton setImage:[UIImage imageNamed:@"tracking_button"] forState:UIControlStateNormal];
    [findTrackingNumberButton setFrame:CGRectMake(SIDEBAR_WIDTH - 50, 39, 25, 25)];
    [findTrackingNumberButton addTarget:self action:@selector(findTrackingNumberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:findTrackingNumberButton];
    
    UITapGestureRecognizer *resignRespondersTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleResignRespondersTapped:)];
    [headerView addGestureRecognizer:resignRespondersTapRecognizer];
	
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SIDEBARMENU_TOTAL + (showOffersMoreSubrows ? SUBROWS_OFFERSMORE_TOTAL : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < SIDEBARMENU_TOTAL) {
        static NSString *const cellIdentifier = @"SidebarMenuTableViewCell";
        
        SidebarMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[SidebarMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [cell setSidebarMenu:(tSidebarMenus)indexPath.row];
        
        return cell;
    }
    else if (showOffersMoreSubrows) {
        static NSString *const subRowCellIdentifier = @"SidebarMenuSubRowTableViewCell";
        
        SidebarMenuSubRowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subRowCellIdentifier];
        if (!cell) {
            cell = [[SidebarMenuSubRowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subRowCellIdentifier];
        }
        
        tSubRowsOffersMore subRow = (tSubRowsOffersMore)indexPath.row - SIDEBARMENU_OFFERSMORE - 1;
        [cell setShowBottomSeparator:((subRow + 1) < SUBROWS_OFFERSMORE_TOTAL)];
        [cell setSubrowMenuOffersMore:subRow];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    if (indexPath.row > SIDEBARMENU_OFFERSMORE) {
        switch ((tSubRowsOffersMore)(indexPath.row - SIDEBARMENU_OFFERSMORE - 1)) {
            case SUBROWS_OFFERSMORE_OFFERS:
            {
                OffersMainViewController *viewController = [[OffersMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                break;
            }
            case SUBROWS_OFFERSMORE_FEEDBACK:
            {
                FeedbackViewController *viewController = [[FeedbackViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                break;
            }
            case SUBROWS_OFFERSMORE_ABOUTTHISAPP:
            {
                AboutThisAppViewController *viewController = [[AboutThisAppViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                break;
            }
            case SUBROWS_OFFERSMORE_TERMSOFUSE:
            {
                TermsOfUseViewController *viewController = [[TermsOfUseViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                break;
            }
            case SUBROWS_OFFERSMORE_FAQ:
            {
                FAQViewController *viewController = [[FAQViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                break;
            }
            case SUBROWS_OFFERSMORE_RATEOURAPP:
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/sg/app/singpost-mobile/id647986630"]];
                break;
            }
            default:
            {
                NSLog(@"not yet implemented");
                break;
            }
        }
    }
    else {
        switch ((tSidebarMenus)indexPath.row) {
            case SIDEBARMENU_CALCULATEPOSTAGE:
            {
                if ([maintananceStatuses[@"CalculatePostage"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Calculate Postage" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentModalViewController:viewController animated:YES];
                }
                else {
                    CalculatePostageMainViewController *viewController = [[CalculatePostageMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                }
                break;
            }
            case SIDEBARMENU_FINDPOSTALCODES:
            {
                if ([maintananceStatuses[@"FindPostalCodes"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Find Postal Codes" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentModalViewController:viewController animated:YES];
                }
                else {
                    FindPostalCodesMainViewController *viewController = [[FindPostalCodesMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                }
                break;
            }
            case SIDEBARMENU_LOCATEUS:
            {
                if ([maintananceStatuses[@"LocateUs"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Locate Us" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentModalViewController:viewController animated:YES];
                }
                else {
                    LocateUsMainViewController *viewController = [[LocateUsMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                }
                break;
            }
            case SIDEBARMENU_SENDRECEIVE:
            {
                if ([maintananceStatuses[@"SendNReceive"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Send & Receive" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentModalViewController:viewController animated:YES];
                }
                else {
                    SendReceiveMainViewController *viewController = [[SendReceiveMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                }
                break;
            }
            case SIDEBARMENU_PAY:
            {
                if ([maintananceStatuses[@"Pay"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Pay" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentModalViewController:viewController animated:YES];
                }
                else {
                    PaymentMainViewController *viewController = [[PaymentMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                }
                break;
            }
            case SIDEBARMENU_SHOP:
            {
                if ([maintananceStatuses[@"Shop"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Shop" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentModalViewController:viewController animated:YES];
                }
                else {
                    ShopMainViewController *viewController = [[ShopMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                }
                break;
            }
            case SIDEBARMENU_MORESERVICES:
            {
                if ([maintananceStatuses[@"MoreServices"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"More Services" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentModalViewController:viewController animated:YES];
                }
                else {
                    MoreServicesMainViewController *viewController = [[MoreServicesMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                }
                break;
            }
            case SIDEBARMENU_STAMPCOLLECTIBLES:
            {
                if ([maintananceStatuses[@"StampCollectibles"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Stamp Collectibles" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentModalViewController:viewController animated:YES];
                }
                else {
                    StampCollectiblesMainViewController *viewController = [[StampCollectiblesMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                }
                break;
            }
            case SIDEBARMENU_MOREAPPS:
            {
                if ([maintananceStatuses[@"MoreApps"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"More Apps" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentModalViewController:viewController animated:YES];
                }
                else {
                    MoreAppsViewController *viewController = [[MoreAppsViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                }
                break;
            }
            case SIDEBARMENU_OFFERSMORE:
            {
                [self toggleOffersMoreSubRows];
                break;
            }
            default:
            {
                NSLog(@"not yet implemented");
                break;
            }
        }
    }
    [trackingNumberTextField resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Offers & More subrows

- (void)toggleOffersMoreSubRows
{
    showOffersMoreSubrows = !showOffersMoreSubrows;
    SidebarMenuTableViewCell *cell = (SidebarMenuTableViewCell *)[menuTableView cellForRowAtIndexPath:menuTableView.indexPathForSelectedRow];
    [cell animateShowSubRows:showOffersMoreSubrows];
    
    NSMutableArray *subRowsIndexPaths = [NSMutableArray array];
    for (int i = 1; i <= SUBROWS_OFFERSMORE_TOTAL; i++)
        [subRowsIndexPaths addObject:[NSIndexPath indexPathForRow:SIDEBARMENU_OFFERSMORE + i inSection:0]];

    [menuTableView beginUpdates];
    if (showOffersMoreSubrows) {
        [menuTableView insertRowsAtIndexPaths:subRowsIndexPaths
                             withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        [menuTableView deleteRowsAtIndexPaths:subRowsIndexPaths
                             withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [menuTableView endUpdates];
    [menuTableView scrollToRowAtIndexPath:(showOffersMoreSubrows ? subRowsIndexPaths[0] : [NSIndexPath indexPathForRow:SIDEBARMENU_OFFERSMORE inSection:0]) atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
