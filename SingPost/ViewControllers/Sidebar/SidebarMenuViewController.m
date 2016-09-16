//
//  SidebarMenuViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SidebarMenuViewController.h"
#import "UIFont+SingPost.h"
#import "SidebarMenuTableViewCell.h"
#import "SidebarMenuSubRowTableViewCell.h"
#import "AppDelegate.h"
#import "RegexKitLite.h"
#import "ApiClient.h"

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
#import "AnnouncementViewController.h"
#import "ShopViewController.h"

#import "FeedbackViewController.h"
#import "AboutThisAppViewController.h"
#import "TermsOfUseViewController.h"
#import "FAQViewController.h"
#import "MaintanancePageViewController.h"

#import "TrackingDetailsViewController.h"

#import "TrackedItem.h"
#import <SVProgressHUD.h>

#import <FacebookSDK/FacebookSDK.h>
#import "ProceedViewController.h"
#import "PersistentBackgroundView.h"
#import "BarScannerViewController.h"
#import "UserDefaultsManager.h"

@interface SidebarTrackingNumberTextField : UITextField

@property (nonatomic, assign) CGSize insetBoundsSize;

@end

@implementation SidebarTrackingNumberTextField

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.background = [UIImage imageNamed:@"trackingTextBox"];
        self.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = RGB(36, 84, 157);
        self.font = [UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans];
        self.insetBoundsSize = CGSizeMake(36, 6);
    }
    
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    [RGB(163, 163, 163) setFill];
    //[[self placeholder] drawInRect:CGRectInset(rect, 0, 2)  withFont:[UIFont SingPostLightItalicFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    
    [self.placeholder drawInRect:CGRectInset(rect, 0, 2) withAttributes:@{NSFontAttributeName:[UIFont SingPostLightItalicFontOfSize:12.0f fontKey:kSingPostFontOpenSans]}];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectInset(rect, _insetBoundsSize.width, _insetBoundsSize.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    return CGRectInset(rect, _insetBoundsSize.width, _insetBoundsSize.height);
}

@end

@interface SidebarMenuViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end

@implementation SidebarMenuViewController
{
    UIButton *landingPageButton;
    SidebarTrackingNumberTextField *trackingNumberTextField;
    UITableView *menuTableView;
    UIButton *trackingListButton;
    UIButton *findTrackingNumberButton;
    
    UIButton *logButton;
    
    BOOL showOffersMoreSubrows;
}

- (void)loadView
{
//    CGRect frame_screen = [[UIScreen mainScreen] bounds];
//    CGRect appFrame = CGRectMake(0,[[UIApplication sharedApplication] statusBarFrame].size.height,frame_screen.size.width,frame_screen.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height);
//    UIView *contentView = [[UIView alloc] initWithFrame:appFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat offsetY = 0.0f;
    UIImageView *singPostLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_singaporepost_colored"]];
    [singPostLogoImageView setFrame:CGRectMake(10, offsetY, 120, 40)];
    [contentView addSubview:singPostLogoImageView];
    
    landingPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [landingPageButton setImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [landingPageButton addTarget:self action:@selector(landingPageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [landingPageButton setFrame:CGRectMake(SIDEBAR_WIDTH - 50, offsetY + 2, 44, 44)];
    [contentView addSubview:landingPageButton];
    
    if(![ApiClient isWithoutFacebook]) {
        logButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString * str = @"Log In";
        
        if (FBSession.activeSession.state == FBSessionStateOpen
            || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
            str = @"Log Out";
        }
        
        
        
        [self performSelector:@selector(checkLoginStatus) withObject:nil afterDelay:1.0f];
        
        [logButton setTitle:str forState:UIControlStateNormal];
        [logButton.titleLabel setFont:[UIFont SingPostLightFontOfSize:13.0f fontKey:kSingPostFontOpenSans]];
        [logButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [logButton addTarget:self action:@selector(onClickLogButton) forControlEvents:UIControlEventTouchUpInside];
        [logButton setFrame:CGRectMake(SIDEBAR_WIDTH - 110, offsetY + 2, 60, 44)];
        [contentView addSubview:logButton];
        
    }
    
//    PersistentBackgroundView * separatorView2 = [[PersistentBackgroundView alloc] initWithFrame:CGRectMake(SIDEBAR_WIDTH - 49, offsetY + 10, 1, 25)];
    PersistentBackgroundView * separatorView2 = [[PersistentBackgroundView alloc] initWithFrame:CGRectMake(SIDEBAR_WIDTH - 49, offsetY + 5, 1, 25)];
    [separatorView2 setPersistentBackgroundColor:RGB(196, 197, 200)];
    [contentView addSubview:separatorView2];
    
    offsetY += 40.0f;
    
    menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offsetY, contentView.bounds.size.width, contentView.bounds.size.height - offsetY) style:UITableViewStyleGrouped];
    [menuTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [menuTableView setDelegate:self];
    [menuTableView setDataSource:self];
    [menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [menuTableView setSeparatorColor:[UIColor clearColor]];
    [menuTableView setShowsVerticalScrollIndicator:NO];
    [menuTableView setBackgroundView:nil];
    [contentView addSubview:menuTableView];
    
    UIImageView *dropShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop-shadow"]];
    [dropShadowImageView setFrame:CGRectMake(SIDEBAR_WIDTH - 25, 0, 25, contentView.height)];
    [contentView addSubview:dropShadowImageView];
    
    self.view = contentView;
    
    [contentView bringSubviewToFront:logButton];
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
    
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    if ([maintananceStatuses[@"TrackFeature"] isEqualToString:@"on"]) {
        trackingNumberTextField.alpha = 0.5;
        trackingListButton.alpha = 0.5;
        findTrackingNumberButton.alpha = 0.5;
    }
}

#pragma mark - IBActions

- (IBAction)landingPageButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    LandingPageViewController *landingPageViewController = [[LandingPageViewController alloc] initWithNibName:nil bundle:nil];
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:landingPageViewController];
}

- (void)findTrackingNumberButtonClicked
{
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    if ([maintananceStatuses[@"TrackFeature"] isEqualToString:@"on"]) {
        MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Tracking"
                                                                                                       andMessage:maintananceStatuses[@"Comment"]];
        [self presentViewController:viewController animated:YES completion:nil];
        return;
    }
    
    if ([trackingNumberTextField.text isMatchedByRegex:@"[^a-zA-Z0-9]"]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:INVALID_TRACKING_NUMBER_ERROR delegate:nil
//                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:INVALID_TRACKING_NUMBER_ERROR preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

        
        return;
    }
    
    if (!(trackingNumberTextField.text.length > 0)) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NO_TRACKING_NUMBER_ERROR delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alertView show];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NO_TRACKING_NUMBER_ERROR preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [self.view endEditing:YES];
    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
    trackingMainViewController.isPushNotification = NO;
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:trackingMainViewController];
    
    [trackingMainViewController setTrackingNumber:trackingNumberTextField.text];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [trackingMainViewController addTrackingNumber:trackingNumberTextField.text];
    });
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == trackingNumberTextField) {
        NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
        if ([maintananceStatuses[@"TrackFeature"] isEqualToString:@"on"]) {
            MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Tracking"
                                                                                                           andMessage:maintananceStatuses[@"Comment"]];
            [self presentViewController:viewController animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == trackingNumberTextField) {
        [self findTrackingNumberButtonClicked];
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width,40)];
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
    
    
    int whySoManyDifferentBuilds = 0;
    if(![ApiClient isScanner]) {
        whySoManyDifferentBuilds = 35;
    }
    
    trackingNumberTextField = [[SidebarTrackingNumberTextField alloc] initWithFrame:CGRectMake(15, 35, SIDEBAR_WIDTH - 35 - 35 + whySoManyDifferentBuilds, 30)];
    [trackingNumberTextField setBackgroundColor:[UIColor clearColor]];
    [trackingNumberTextField setReturnKeyType:UIReturnKeySend];
    [trackingNumberTextField setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [trackingNumberTextField setDelegate:self];
    [trackingNumberTextField setPlaceholder:@"Enter tracking number"];
    [trackingNumberTextField setText:[[UserDefaultsManager sharedInstance] getLastTrackingNumber]];
    [headerView addSubview:trackingNumberTextField];
    
    CGFloat findTrackingBtnX;
    
    if([ApiClient isScanner]) {
        //Add Scan Button
        UIButton * scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (INTERFACE_IS_IPAD) {
            findTrackingBtnX = headerView.width - 45;
            scanBtn.frame = CGRectMake(findTrackingBtnX, 35, 30, 30);
        }
        else {
            findTrackingBtnX = headerView.width - 45;
            scanBtn.frame = INTERFACE_IS_4INCHSCREEN ? CGRectMake(findTrackingBtnX, 35, 30, 30) : CGRectMake(findTrackingBtnX, 35, 30, 30);
        }
        [scanBtn setImage:[UIImage imageNamed:@"scanSidebarBtn"] forState:UIControlStateNormal];
        [scanBtn addTarget:self action:@selector(OnGoToScan) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:scanBtn];
    }
    
    trackingListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [trackingListButton setImage:[UIImage imageNamed:@"tracking_list_icon_small"] forState:UIControlStateNormal];
    [trackingListButton addTarget:self action:@selector(trackingListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [trackingListButton setFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(15, 29, 44, 44) : CGRectMake(15, 31, 40, 40)];
    [headerView addSubview:trackingListButton];
    
    findTrackingNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [findTrackingNumberButton setImage:[UIImage imageNamed:@"tracking_button"] forState:UIControlStateNormal];
    [findTrackingNumberButton setFrame:CGRectMake(SIDEBAR_WIDTH - 50 - 35 + whySoManyDifferentBuilds, 39, 25, 25)];
    [findTrackingNumberButton addTarget:self action:@selector(findTrackingNumberButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:findTrackingNumberButton];
    
    UITapGestureRecognizer *resignRespondersTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleResignRespondersTapped:)];
    [headerView addGestureRecognizer:resignRespondersTapRecognizer];
    
    return headerView;
}

- (void)OnGoToScan {
    BarScannerViewController * vc = [[BarScannerViewController alloc] init];
    LandingPageViewController *landingPageViewController = [[LandingPageViewController alloc] initWithNibName:nil bundle:nil];
    vc.landingVC = landingPageViewController;
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:vc];
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
            case SUBROWS_OFFERSMORE_ANNOUNCEMENTS:
            {
                AnnouncementViewController *viewController = [[AnnouncementViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                break;
            }
            case SUBROWS_OFFERSMORE_OFFERS:
            {
                OffersMainViewController *viewController = [[OffersMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                break;
            }
            case SUBROWS_OFFERSMORE_FEEDBACK:
            {
                FeedbackViewController *viewController = [[FeedbackViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                break;
            }
            case SUBROWS_OFFERSMORE_ABOUTTHISAPP:
            {
                AboutThisAppViewController *viewController = [[AboutThisAppViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                break;
            }
            case SUBROWS_OFFERSMORE_TERMSOFUSE:
            {
                TermsOfUseViewController *viewController = [[TermsOfUseViewController alloc] initWithNibName:nil bundle:nil];
                viewController.isFirstLaunch = NO;
                [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                break;
            }
            case SUBROWS_OFFERSMORE_FAQ:
            {
                FAQViewController *viewController = [[FAQViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                break;
            }
            case SUBROWS_OFFERSMORE_RATEOURAPP:
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/sg/app/singpost-mobile/id647986630"]];
                break;
            }
                /* case SUBROWS_OFFERSMORE_SIGNOFF:
                 {
                 if (FBSession.activeSession.state == FBSessionStateOpen
                 || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
                 
                 // Close the session and remove the access token from the cache
                 // The session state handler (in the app delegate) will be called automatically
                 
                 
                 [FBSession.activeSession closeAndClearTokenInformation];
                 [FBSession.activeSession close];
                 //[FBSession setActiveSession:nil];
                 
                 [self fbDidLogout];
                 
                 [ApiClient sharedInstance].serverToken = @"";
                 
                 //ProceedViewController *vc = [[ProceedViewController alloc] initWithNibName:nil bundle:nil];
                 
                 
                 //[[LandingPageViewController alloc] initWithNibName:nil bundle:nil]
                 
                 [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:[[LandingPageViewController alloc] initWithNibName:nil bundle:nil]];
                 
                 
                 UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Signed Out" message:@"You have signed out from Facebook account successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 
                 [alert show];
                 
                 [self checkLoginStatus];
                 // If the session state is not any of the two "open" states when the button is clicked
                 } else {
                 
                 
                 
                 
                 ProceedViewController *vc = [[ProceedViewController alloc] initWithNibName:nil bundle:nil];
                 
                 [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:vc];
                 //[[AppDelegate sharedAppDelegate].rootViewController cPushViewController:vc];
                 }
                 
                 
                 
                 //[FBSession.activeSession closeAndClearTokenInformation];
                 break;
                 }*/
            default:
            {
                break;
            }
        }
        [self toggleOffersMoreSubRows];
    }
    else {
        switch ((tSidebarMenus)indexPath.row) {
            case SIDEBARMENU_CALCULATEPOSTAGE:
            {
                if ([maintananceStatuses[@"CalculatePostage"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Calculate Postage" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentViewController:viewController animated:YES completion:nil];
                }
                else {
                    CalculatePostageMainViewController *viewController = [[CalculatePostageMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                }
                if (showOffersMoreSubrows)
                    [self toggleOffersMoreSubRows];
                break;
            }
            case SIDEBARMENU_FINDPOSTALCODES:
            {
                if ([maintananceStatuses[@"FindPostalCodes"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Find Postal Codes" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentViewController:viewController animated:YES completion:nil];
                }
                else {
                    FindPostalCodesMainViewController *viewController = [[FindPostalCodesMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                }
                if (showOffersMoreSubrows)
                    [self toggleOffersMoreSubRows];
                break;
            }
            case SIDEBARMENU_LOCATEUS:
            {
                if ([maintananceStatuses[@"LocateUs"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Locate Us" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentViewController:viewController animated:YES completion:nil];
                }
                else {
                    LocateUsMainViewController *viewController = [[LocateUsMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                }
                if (showOffersMoreSubrows)
                    [self toggleOffersMoreSubRows];
                break;
            }
            case SIDEBARMENU_SENDRECEIVE:
            {
                if ([maintananceStatuses[@"SendNReceive"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Send & Receive" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentViewController:viewController animated:YES completion:nil];
                }
                else {
                    SendReceiveMainViewController *viewController = [[SendReceiveMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                }
                if (showOffersMoreSubrows)
                    [self toggleOffersMoreSubRows];
                break;
            }
            case SIDEBARMENU_PAY:
            {
                if ([maintananceStatuses[@"Pay"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Pay" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentViewController:viewController animated:YES completion:nil];
                }
                else {
                    PaymentMainViewController *viewController = [[PaymentMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                }
                if (showOffersMoreSubrows)
                    [self toggleOffersMoreSubRows];
                break;
            }
            case SIDEBARMENU_SHOP:
            {
                if ([maintananceStatuses[@"Shop"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Shop" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentViewController:viewController animated:YES completion:nil];
                }
                else {
                    ShopViewController *viewController = [[ShopViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                }
                if (showOffersMoreSubrows)
                    [self toggleOffersMoreSubRows];
                break;
            }
            case SIDEBARMENU_MORESERVICES:
            {
                if ([maintananceStatuses[@"MoreServices"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"More Services" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentViewController:viewController animated:YES completion:nil];
                }
                else {
                    MoreServicesMainViewController *viewController = [[MoreServicesMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                }
                if (showOffersMoreSubrows)
                    [self toggleOffersMoreSubRows];
                break;
            }
            case SIDEBARMENU_STAMPCOLLECTIBLES:
            {
                if ([maintananceStatuses[@"StampCollectibles"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Stamp Collectibles" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentViewController:viewController animated:YES completion:nil];
                }
                else {
                    StampCollectiblesMainViewController *viewController = [[StampCollectiblesMainViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                }
                if (showOffersMoreSubrows)
                    [self toggleOffersMoreSubRows];
                break;
            }
            case SIDEBARMENU_MOREAPPS:
            {
                if ([maintananceStatuses[@"MoreApps"] isEqualToString:@"on"]) {
                    MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"More Apps" andMessage:maintananceStatuses[@"Comment"]];
                    [self presentViewController:viewController animated:YES completion:nil];
                }
                else {
                    MoreAppsViewController *viewController = [[MoreAppsViewController alloc] initWithNibName:nil bundle:nil];
                    [[AppDelegate sharedAppDelegate].rootViewController newSwitchToViewController2:viewController];
                }
                if (showOffersMoreSubrows)
                    [self toggleOffersMoreSubRows];
                break;
            }
            case SIDEBARMENU_OFFERSMORE:
            {
                [self toggleOffersMoreSubRows];
                break;
            }
            default:
            {
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:SIDEBARMENU_OFFERSMORE inSection:1];
    
    SidebarMenuTableViewCell *cell = (SidebarMenuTableViewCell *)[menuTableView cellForRowAtIndexPath:indexPath];
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

- (IBAction)trackingListButtonClicked:(id)sender
{
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    if ([maintananceStatuses[@"TrackFeature"] isEqualToString:@"on"]) {
        MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Tracking"
                                                                                                       andMessage:maintananceStatuses[@"Comment"]];
        [self presentViewController:viewController animated:YES completion:nil];
        return;
    }
    [self.view endEditing:YES];
    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:trackingMainViewController];
}

-(void) checkLoginStatus {
    NSString * str = @"Log In";
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        str = @"Log Out";
    }
    
    [logButton setTitle:str forState:UIControlStateNormal];
}

-(void) onClickLogButton {
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        
        
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        //[FBSession setActiveSession:nil];
        
        [self fbDidLogout];
        
        [ApiClient sharedInstance].serverToken = @"";
        
        [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:[[LandingPageViewController alloc] initWithNibName:nil bundle:nil]];
        
        
        /*UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Logged Out" message:@"You have logged out from Facebook account successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         
         [alert show];*/
        
        [self checkLoginStatus];
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        
        /*ProceedViewController *vc = [[ProceedViewController alloc] initWithNibName:nil bundle:nil];
         
         [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:vc];*/
        
        if (FBSession.activeSession.state == FBSessionStateOpen
            || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
            
            // Close the session and remove the access token from the cache
            // The session state handler (in the app delegate) will be called automatically
            
            
            [FBSession.activeSession closeAndClearTokenInformation];
            [FBSession.activeSession close];
            //[FBSession setActiveSession:nil];
            
            [self fbDidLogout];
            
            [ApiClient sharedInstance].serverToken = @"";
            
            // If the session state is not any of the two "open" states when the button is clicked
        } else {
            // Open a session showing the user the login UI
            // You must ALWAYS ask for public_profile permissions when opening a session
            
            NSArray *permissions = @[@"public_profile",@"email",@"user_about_me",@"user_birthday",@"user_location"];
            FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
            [FBSession setActiveSession:session];

            [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingWebView fromViewController:self completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                // Retrieve the app delegate
                AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
                appDelegate.isLoginFromSideBar = YES;
                // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                [appDelegate sessionStateChanged:session state:status error:error];
            }];

//            [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//                
//                // Retrieve the app delegate
//                AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                
//                appDelegate.isLoginFromSideBar = YES;
//                // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
//                [appDelegate sessionStateChanged:session state:state error:error];
//            }];
            
        }
        
    }
}

-(void) fbDidLogout
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for(NSHTTPCookie *cookie in [storage cookies])
    {
        NSString *domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
}

@end
