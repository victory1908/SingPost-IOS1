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
#import "UIView+Shadow.h"
#import "SidebarMenuTableViewCell.h"
#import "SidebarMenuSubRowTableViewCell.h"
#import "AppDelegate.h"

#import "CalculatePostageViewController.h"
#import "LandingPageViewController.h"
#import "FindPostalCodesMainViewController.h"
#import "TrackingMainViewController.h"
#import "LocateUsMainViewController.h"
#import "SendReceiveMainViewController.h"
#import "PaymentMainViewController.h"

#import "FeedbackViewController.h"
#import "AboutThisAppViewController.h"
#import "TermsOfUseViewController.h"

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
    [landingPageButton setFrame:CGRectMake(197, offsetY + 2, 44, 44)];
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
    
    self.view = contentView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.view makeInsetShadowWithRadius:10.0f Color:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1] Directions:@[@"right"]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [trackingNumberTextField resignFirstResponder];
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
    [self.view endEditing:YES];
    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
    trackingMainViewController.trackingNumber = trackingNumberTextField.text;
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:trackingMainViewController];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == trackingNumberTextField) {
        TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
        trackingMainViewController.trackingNumber = trackingNumberTextField.text;
        [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:trackingMainViewController];
    }
    return YES;
}

#pragma mark - UIGestures

- (void)handleResignRespondersTap:(UITapGestureRecognizer *)tapGesture
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
    [starImageView setFrame:CGRectMake(209, 9, 20, 20)];
    [headerView addSubview:starImageView];
    
    trackingNumberTextField = [[SidebarTrackingNumberTextField alloc] initWithFrame:CGRectMake(15, 35, 212, 30)];
    [trackingNumberTextField setBackgroundColor:[UIColor clearColor]];
    [trackingNumberTextField setReturnKeyType:UIReturnKeySend];
    [trackingNumberTextField setDelegate:self];
    [trackingNumberTextField setPlaceholder:@"Last tracking number entered"];
    [headerView addSubview:trackingNumberTextField];
    
    UIButton *findTrackingNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [findTrackingNumberButton setImage:[UIImage imageNamed:@"tracking_button"] forState:UIControlStateNormal];
    [findTrackingNumberButton setFrame:CGRectMake(200, 39, 25, 25)];
    [findTrackingNumberButton addTarget:self action:@selector(findTrackingNumberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:findTrackingNumberButton];
    
    UITapGestureRecognizer *resignRespondersTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleResignRespondersTap:)];
    [headerView addGestureRecognizer:resignRespondersTap];
	
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
    if (indexPath.row > SIDEBARMENU_OFFERSMORE) {
        switch ((tSubRowsOffersMore)(indexPath.row - SIDEBARMENU_OFFERSMORE - 1)) {
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
                CalculatePostageViewController *viewController = [[CalculatePostageViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                break;
            }
            case SIDEBARMENU_FINDPOSTALCODES:
            {
                FindPostalCodesMainViewController *viewController = [[FindPostalCodesMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                break;
            }
            case SIDEBARMENU_LOCATEUS:
            {
                LocateUsMainViewController *viewController = [[LocateUsMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                break;
            }
            case SIDEBARMENU_SENDRECEIVE:
            {
                SendReceiveMainViewController *viewController = [[SendReceiveMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
                break;
            }
            case SIDEBARMENU_PAY:
            {
                PaymentMainViewController *viewController = [[PaymentMainViewController alloc] initWithNibName:nil bundle:nil];
                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:viewController];
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
