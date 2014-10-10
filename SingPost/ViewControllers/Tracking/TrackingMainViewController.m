//
//  TrackingMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TrackingMainViewController.h"
#import "NavigationBarView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+SingPost.h"
#import "CTextField.h"
#import "TrackingItemMainTableViewCell.h"
#import "TrackingHeaderMainTableViewCell.h"
#import "TrackingDetailsViewController.h"
#import "AppDelegate.h"
#import <KGModal.h>
#import <SVProgressHUD.h>
#import "UIImage+Extensions.h"
#import "UIAlertView+Blocks.h"
#import <SevenSwitch.h>
#import "RegexKitLite.h"

#import "TrackedItem.h"
#import "Article.h"
#import "PushNotification.h"
#import "ApiClient.h"
#import "DeliveryStatus.h"

#import "TrackingSelectViewController.h"

typedef enum {
    TRACKINGITEMS_SECTION_HEADER,
    TRACKINGITEMS_SECTION_ACTIVE,
    TRACKINGITEMS_SECTION_UNSORTED,
    TRACKINGITEMS_SECTION_COMPLETED,
    
    TRACKINGITEMS_SECTION_TOTAL
} tTrackingItemsSections;

@interface UITableView(ReloadBlock)
-(void)reloadDataAndWait:(void(^)(void))waitBlock;
@end

@implementation UITableView (ReloadBlock)

-(void)reloadDataAndWait:(void(^)(void))waitBlock {
    [self reloadData];//if subclassed then super. else use [self.tableView
    if(waitBlock){
        waitBlock();
    }
}

@end

@interface TrackingMainViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *allItemsFetchedResultsController;
@property (nonatomic) NSFetchedResultsController *activeItemsFetchedResultsController;
@property (nonatomic) NSFetchedResultsController *completedItemsFetchedResultsController;
@property (nonatomic) NSFetchedResultsController *unsortedItemsFetchedResultsController;

@end

@implementation TrackingMainViewController
{
    CTextField *trackingNumberTextField;
    
    SevenSwitch *receiveUpdateSwitch;
    
    BOOL isViewDidAppear;
    TrackingSelectViewController * vc;
    
    NavigationBarView *navigationBarView;
    UIButton *infoButton;
}

@synthesize labelDic;
@synthesize trackingItemsTableView;

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    //navigation bar
    navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setShowSidebarToggleButton:YES];
    [navigationBarView setTitle:@"Track"];
    [contentView addSubview:navigationBarView];
    
    infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton.layer setBorderWidth:1.0f];
    [infoButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [infoButton setBackgroundImage:nil forState:UIControlStateNormal];
    [infoButton setBackgroundImage:[UIImage imageWithColor:RGB(76, 109, 166)] forState:UIControlStateHighlighted];
    [infoButton setTitle:@"Info" forState:UIControlStateNormal];
    [infoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoButton.titleLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setFrame:CGRectMake(contentView.width - 60, 7, 50, 30)];
    [navigationBarView addSubview:infoButton];
    
    trackingItemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    [trackingItemsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [trackingItemsTableView setSeparatorColor:[UIColor clearColor]];
    [trackingItemsTableView setDelegate:self];
    [trackingItemsTableView setDataSource:self];
    [trackingItemsTableView setBackgroundColor:[UIColor whiteColor]];
    [trackingItemsTableView setBackgroundView:nil];
    [contentView addSubview:trackingItemsTableView];
    
    self.view = contentView;
    
    labelDic = [[NSMutableDictionary alloc] init];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Tracking Numbers"];
    
    /*if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NOTIFICATION_KEY"]) {
        NSArray * trackedArray = [self.activeItemsFetchedResultsController fetchedObjects];
        if ([trackedArray count] == 0)
            return;
        
        NSMutableArray * numberArray = [NSMutableArray array];
        for(TrackedItem *trackedItem in trackedArray){
            [numberArray addObject:trackedItem.trackingNumber];
        }
        [PushNotificationManager API_subscribeNotificationForTrackingNumberArray:numberArray onCompletion:^(BOOL success, NSError *error) {
        }];
    }*/
    
    NSArray * arr = [self.allItemsFetchedResultsController fetchedObjects];
    [ApiClient sharedInstance].allTrackingItem = arr;
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.trackingMainViewController = self;
    
    if(!isViewDidAppear) {
        [self syncLabelsWithTrackingNumbers];
        isViewDidAppear = true;
    }
    
    //[self refreshTableView];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [trackingNumberTextField resignFirstResponder];
}

#pragma mark - Accessors

- (void)setTrackingNumber:(NSString *)inTrackingNumber
{
    _trackingNumber = inTrackingNumber;
    [trackingNumberTextField setText:_trackingNumber];
    [TrackedItem saveLastEnteredTrackingNumber:_trackingNumber];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == trackingNumberTextField) {
        self.isPushNotification = NO;
        [self addTrackingNumber:trackingNumberTextField.text];
    }
    return YES;
}

#pragma mark - Tracking Numbers

- (void)addTrackingNumber:(NSString *)trackingNumber {
    [self setTrackingNumber:trackingNumber];
    
    if (!self.isPushNotification) {
        if ([trackingNumberTextField.text isMatchedByRegex:@"[^a-zA-Z0-9]"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:INVALID_TRACKING_NUMBER_ERROR delegate:nil
                                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if (trackingNumberTextField.text.length == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NO_TRACKING_NUMBER_ERROR delegate:nil
                                                      cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
    }
    
    [self.view endEditing:YES];
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
        BOOL notificationStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"NOTIFICATION_KEY"];
        
        [TrackedItem API_getItemTrackingDetailsForTrackingNumber:trackingNumberTextField.text notification:notificationStatus onCompletion:^(BOOL success, NSError *error) {
            if (success) {
                [SVProgressHUD dismiss];
                NSString *capsTrackingNumber = [trackingNumberTextField.text uppercaseString]; //Making sure tracking number is in caps
                TrackedItem *trackedItem = [[TrackedItem MR_findByAttribute:TrackedItemAttributes.trackingNumber withValue:capsTrackingNumber]firstObject];
                if (trackedItem.isFoundValue) {
                    [self performSelector:@selector(submitAllTrackingItemWithLabel) withObject:nil afterDelay:1.0f];
                    [self goToDetailPageWithTrackedItem:trackedItem];
                    
                    
                    [self performSelector:@selector(stupidRequirementFromSingpost) withObject:nil afterDelay:1];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NEW_TRACKED_ITEM_NOT_FOUND_ERROR delegate:nil
                                                         cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            else {
                [SVProgressHUD dismiss];
                if (error.code == 1001) {
                    [UIAlertView showWithTitle:NO_INTERNET_ERROR_TITLE
                                       message:ERRORCODE1001_MESSAGE
                             cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
                }
                else {
                    [UIAlertView showWithTitle:NO_INTERNET_ERROR_TITLE
                                       message:NO_INTERNET_ERROR
                             cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
                }
            }
        }];
    }
}

#pragma mark - Actions
- (IBAction)infoButtonClicked:(id)sender
{
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [Article API_getTrackIOnCompletion:^(NSString *trackI) {
        [SVProgressHUD dismiss];
        
        if (trackI) {
            UIWebView *webView = [[UIWebView alloc] initWithFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(0, 0, 280, 500) : CGRectMake(0, 0, 280, 400)];
            [webView setBackgroundColor:[UIColor clearColor]];
            [webView setOpaque:NO];
            [webView loadHTMLString:[NSString stringWithFormat:@"<!DOCTYPE html><html><body style=\"font-family:OpenSans;color:white;\"><h4 style=\"text-align:center;\">Tracking Information</h4>%@</body></html>", trackI] baseURL:nil];
            [[KGModal sharedInstance] showWithContentView:webView andAnimated:YES];
        }
    }];
}

- (void)goToDetailPageWithTrackedItem:(TrackedItem *)trackedItem {
    TrackingDetailsViewController *trackingDetailsViewController = [[TrackingDetailsViewController alloc] initWithTrackedItem:trackedItem];
    trackedItem.isReadValue = YES;
    
    NSString * title = [labelDic objectForKey:trackedItem.trackingNumber];
    if(title && ![title isEqualToString:@""])
        trackingDetailsViewController.title = title;
    [[AppDelegate sharedAppDelegate]saveToPersistentStoreWithCompletion:nil];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:trackingDetailsViewController];
}

- (void)onTrackingNumberBtn:(id)sender {
    [self addTrackingNumber:trackingNumberTextField.text];
    self.isPushNotification = NO;
}

#pragma mark - UITableView DataSource & Delegate

- (void)configureCell:(TrackingItemMainTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TRACKINGITEMS_SECTION_ACTIVE) {
        cell.item = [self.activeItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        [cell setHideSeparatorView:indexPath.row == (self.activeItemsFetchedResultsController.fetchedObjects.count)];
    }
    else if (indexPath.section == TRACKINGITEMS_SECTION_COMPLETED) {
        cell.item = [self.completedItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        [cell setHideSeparatorView:indexPath.row == (self.completedItemsFetchedResultsController.fetchedObjects.count)];
    }
    else if (indexPath.section == TRACKINGITEMS_SECTION_UNSORTED) {
        cell.item = [self.unsortedItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        [cell setHideSeparatorView:indexPath.row == (self.unsortedItemsFetchedResultsController.fetchedObjects.count)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return indexPath.section == TRACKINGITEMS_SECTION_HEADER ? 140.0f : 30.0f;
    
    TrackedItem *trackedItem;
    if (indexPath.section == TRACKINGITEMS_SECTION_ACTIVE)
        trackedItem = [self.activeItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
    else if (indexPath.section == TRACKINGITEMS_SECTION_COMPLETED)
        trackedItem = [self.completedItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
    else if (indexPath.section == TRACKINGITEMS_SECTION_UNSORTED)
        trackedItem = [self.unsortedItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
    
    CGSize statusLabelSize = [trackedItem.status sizeWithFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans] constrainedToSize:STATUS_LABEL_SIZE];
    
    return MAX(60 + 30, statusLabelSize.height + 14 + 30);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == TRACKINGITEMS_SECTION_HEADER ? 0.0f : 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TRACKINGITEMS_SECTION_TOTAL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == TRACKINGITEMS_SECTION_HEADER)
        return 1;
    
    NSInteger HEADER_COUNT = 1;
    
    if (section == TRACKINGITEMS_SECTION_ACTIVE) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.activeItemsFetchedResultsController.sections objectAtIndex:0];
        return HEADER_COUNT + [sectionInfo numberOfObjects];
    }
    
    if (section == TRACKINGITEMS_SECTION_COMPLETED) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.completedItemsFetchedResultsController.sections objectAtIndex:0];
        return HEADER_COUNT + [sectionInfo numberOfObjects];
    }
    
    if (section == TRACKINGITEMS_SECTION_UNSORTED) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.unsortedItemsFetchedResultsController.sections objectAtIndex:0];
        return HEADER_COUNT + [sectionInfo numberOfObjects];
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == TRACKINGITEMS_SECTION_HEADER)
        return nil;
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
    [sectionHeaderView setBackgroundColor:RGB(240, 240, 240)];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)];
    [topSeparatorView setBackgroundColor:RGB(231, 232, 233)];
    [sectionHeaderView addSubview:topSeparatorView];
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, tableView.bounds.size.width, 1)];
    [bottomSeparatorView setBackgroundColor:RGB(231, 232, 233)];
    [sectionHeaderView addSubview:bottomSeparatorView];
    
    switch ((tTrackingItemsSections)section) {
        case TRACKINGITEMS_SECTION_ACTIVE:
        {
            UILabel *activeItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 300, 44)];
            [activeItemsLabel setTextColor:RGB(195, 17, 38)];
            [activeItemsLabel setText:@"Active items"];
            [activeItemsLabel setBackgroundColor:[UIColor clearColor]];
            [activeItemsLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [sectionHeaderView addSubview:activeItemsLabel];
            break;
        }
        case TRACKINGITEMS_SECTION_COMPLETED: {
            UILabel *completedItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 300, 44)];
            [completedItemsLabel setTextColor:RGB(125, 136, 149)];
            [completedItemsLabel setText:@"Completed items"];
            [completedItemsLabel setBackgroundColor:[UIColor clearColor]];
            [completedItemsLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [sectionHeaderView addSubview:completedItemsLabel];
            break;
        }
        case TRACKINGITEMS_SECTION_UNSORTED: {
            UILabel *completedItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 300, 44)];
            [completedItemsLabel setTextColor:RGB(125, 136, 149)];
            [completedItemsLabel setText:@"No info yet items"];
            [completedItemsLabel setBackgroundColor:[UIColor clearColor]];
            [completedItemsLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [sectionHeaderView addSubview:completedItemsLabel];
            break;
        }
        default:
            NSAssert(NO, @"unsupported TRACKINGITEMS_SECTION");
            break;
    }
    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const headerCellIdentifier = @"TrackingHeaderMainTableViewCell";
    static NSString *const itemCellIdentifier = @"TrackingItemMainTableViewCell";
    static NSString *const trackingCellIdentifier = @"TrackingCell";
    
    if (indexPath.section == TRACKINGITEMS_SECTION_HEADER) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:trackingCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:trackingCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            trackingNumberTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 21, tableView.width - 30, 44)];
            [trackingNumberTextField setPlaceholder:@"Please enter tracking number"];
            [trackingNumberTextField setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
            [trackingNumberTextField setFontSize:16.0f];
            [trackingNumberTextField setReturnKeyType:UIReturnKeySend];
            [trackingNumberTextField setText:_trackingNumber];
            [trackingNumberTextField setDelegate:self];
            [cell.contentView addSubview:trackingNumberTextField];
            
            UIButton *findTrackingNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [findTrackingNumberButton setImage:[UIImage imageNamed:@"tracking_button"] forState:UIControlStateNormal];
            [findTrackingNumberButton setFrame:CGRectMake(tableView.width - 55, 27, 35, 35)];
            [findTrackingNumberButton addTarget:self action:@selector(onTrackingNumberBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:findTrackingNumberButton];
            
            UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 77, tableView.width - 100, 50)];
            [instructionsLabel setFont:[UIFont SingPostRegularFontOfSize:11.0f fontKey:kSingPostFontOpenSans]];
            [instructionsLabel setText:@"Turn on to auto-receive latest status updates of item(s) you are currently tracking"];
            [instructionsLabel setNumberOfLines:0];
            [instructionsLabel setTextColor:RGB(51, 51, 51)];
            [instructionsLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:instructionsLabel];
            
            BOOL notificationStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"NOTIFICATION_KEY"];
            
            receiveUpdateSwitch = [[SevenSwitch alloc] initWithFrame:CGRectZero];
            receiveUpdateSwitch.inactiveColor = [UIColor lightGrayColor];
            receiveUpdateSwitch.center = CGPointMake(tableView.width - 42, 104);
            receiveUpdateSwitch.on = notificationStatus;
            [receiveUpdateSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:receiveUpdateSwitch];
        }
        
        return cell;
    }
    
    if (indexPath.row == 0) {
        TrackingHeaderMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
        if (!cell) {
            cell = [[TrackingHeaderMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
        }
        
        if (indexPath.section == TRACKINGITEMS_SECTION_ACTIVE) {
            [cell setHideSeparatorView:self.activeItemsFetchedResultsController.fetchedObjects.count == 0];
        }
        else if (indexPath.section == TRACKINGITEMS_SECTION_COMPLETED) {
            [cell setHideSeparatorView:self.completedItemsFetchedResultsController.fetchedObjects.count == 0];
        }
        else if (indexPath.section == TRACKINGITEMS_SECTION_UNSORTED) {
            [cell setHideSeparatorView:self.unsortedItemsFetchedResultsController.fetchedObjects.count == 0];
        }
        
        return cell;
    }
    else {
        TrackingItemMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
        //if (!cell)
        
        cell = [[TrackingItemMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier IsActive: (indexPath.section != TRACKINGITEMS_SECTION_COMPLETED) ? YES : NO];
        
        cell.delegate = self;
        [self configureCell:cell atIndexPath:indexPath];
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TRACKINGITEMS_SECTION_HEADER)
        [self.view endEditing:YES];
    else {
        TrackedItem *trackedItem;
        if (indexPath.section == TRACKINGITEMS_SECTION_ACTIVE) {
            if(indexPath.row - 1 < 0)
                return;
            
            trackedItem = [self.activeItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
            
            [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
            
            BOOL notificationStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"NOTIFICATION_KEY"];
            
            [TrackedItem API_getItemTrackingDetailsForTrackingNumber:trackedItem.trackingNumber notification:notificationStatus onCompletion:^(BOOL success, NSError *error) {
                if (success) {
                    [SVProgressHUD dismiss];
                    [self goToDetailPageWithTrackedItem:trackedItem];
                }
                else {
                    [SVProgressHUD dismiss];
                    if (error.code == 1001) {
                        [UIAlertView showWithTitle:NO_INTERNET_ERROR_TITLE
                                           message:ERRORCODE1001_MESSAGE
                                 cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
                    }
                    else {
                        [UIAlertView showWithTitle:NO_INTERNET_ERROR_TITLE
                                           message:NO_INTERNET_ERROR
                                 cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
                    }
                }
            }];
        }
        else if (indexPath.section == TRACKINGITEMS_SECTION_COMPLETED) {
            if(indexPath.row - 1 < 0)
                return;
            
            trackedItem = [self.completedItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
            [self goToDetailPageWithTrackedItem:trackedItem];
        }
        else if (indexPath.section == TRACKINGITEMS_SECTION_UNSORTED) {
            if(indexPath.row - 1 < 0)
                return;
            
            trackedItem = [self.unsortedItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
            
            [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
            
            BOOL notificationStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"NOTIFICATION_KEY"];
            
            [TrackedItem API_getItemTrackingDetailsForTrackingNumber:trackedItem.trackingNumber notification:notificationStatus onCompletion:^(BOOL success, NSError *error) {
                if (success) {
                    [SVProgressHUD dismiss];
                    if (trackedItem.isFoundValue)
                        [self goToDetailPageWithTrackedItem:trackedItem];
                    else {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:TRACKED_ITEM_NOT_FOUND_ERROR delegate:nil
                                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                }
                else {
                    [SVProgressHUD dismiss];
                    if (error.code == 1001) {
                        [UIAlertView showWithTitle:NO_INTERNET_ERROR_TITLE
                                           message:ERRORCODE1001_MESSAGE
                                 cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
                    }
                    else {
                    [UIAlertView showWithTitle:NO_INTERNET_ERROR_TITLE
                                       message:NO_INTERNET_ERROR
                             cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
                    }
                }
            }];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        //[tableView reloadData];
        [self performSelector:@selector(stupidRequirementFromSingpost) withObject:nil afterDelay:1];
    }
}

- (void) stupidRequirementFromSingpost {
    [self refreshTableView];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section != TRACKINGITEMS_SECTION_HEADER && indexPath.row > 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TrackedItem *trackedItemToDelete = nil;
        if (indexPath.section == TRACKINGITEMS_SECTION_ACTIVE)
            trackedItemToDelete = [self.activeItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        else if (indexPath.section == TRACKINGITEMS_SECTION_COMPLETED)
            trackedItemToDelete = [self.completedItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        else if (indexPath.section == TRACKINGITEMS_SECTION_UNSORTED)
            trackedItemToDelete = [self.unsortedItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        
        [SVProgressHUD showWithStatus:@"Please wait.." maskType:SVProgressHUDMaskTypeClear];
        [TrackedItem deleteTrackedItem:trackedItemToDelete onCompletion:^(BOOL success, NSError *error) {
            if (!success)
                [SVProgressHUD showErrorWithStatus:@"Delete fail."];
            else {
                [SVProgressHUD dismiss];
                [tableView setEditing:NO animated:YES];
            }
        }];
        
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)allItemsFetchedResultsController
{
    if (!_allItemsFetchedResultsController) {
        _allItemsFetchedResultsController = [TrackedItem MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:TrackedItemAttributes.addedOn ascending:NO delegate:self];
    }
    
    return _allItemsFetchedResultsController;
}

- (NSFetchedResultsController *)activeItemsFetchedResultsController
{
    if (!_activeItemsFetchedResultsController) {
        _activeItemsFetchedResultsController = [TrackedItem MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"isActive == 'true'"] sortedBy:TrackedItemAttributes.addedOn ascending:NO delegate:self];
    }
    
    return _activeItemsFetchedResultsController;
}

- (NSFetchedResultsController *)completedItemsFetchedResultsController
{
    if (!_completedItemsFetchedResultsController) {
        _completedItemsFetchedResultsController = [TrackedItem MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"isActive == 'false'"] sortedBy:TrackedItemAttributes.addedOn ascending:NO delegate:self];
    }
    
    return _completedItemsFetchedResultsController;
}

- (NSFetchedResultsController *)unsortedItemsFetchedResultsController
{
    if (!_unsortedItemsFetchedResultsController) {
        _unsortedItemsFetchedResultsController = [TrackedItem MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"isFound == 0"] sortedBy:TrackedItemAttributes.addedOn ascending:NO delegate:self];
    }
    
    return _unsortedItemsFetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [trackingItemsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [trackingItemsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [trackingItemsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSInteger section = TRACKINGITEMS_SECTION_HEADER;
    NSInteger rowCount = 0;
    if(controller == self.allItemsFetchedResultsController) {
        return;
    }
    
    if (controller == self.activeItemsFetchedResultsController) {
        section = TRACKINGITEMS_SECTION_ACTIVE;
        rowCount = self.activeItemsFetchedResultsController.fetchedObjects.count;
    }
    else if (controller == self.completedItemsFetchedResultsController) {
        section = TRACKINGITEMS_SECTION_COMPLETED;
        rowCount = self.completedItemsFetchedResultsController.fetchedObjects.count;
    }
    else if (controller == self.unsortedItemsFetchedResultsController) {
        section = TRACKINGITEMS_SECTION_UNSORTED;
        rowCount = self.unsortedItemsFetchedResultsController.fetchedObjects.count;
    }
    
    NSIndexPath *dataIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row + 1 inSection:section];
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            if (rowCount == 1)
                [trackingItemsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
            [trackingItemsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:dataIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            if (rowCount == 0)
                [trackingItemsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
            
            [trackingItemsTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
            
            //update cms tracking status
            
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            if(!appDelegate.isLoginFromSideBar)
                [self performSelector:@selector(submitAllTrackingItemWithLabel) withObject:nil afterDelay:1.5f];
            break;
        }
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(TrackingItemMainTableViewCell *)[trackingItemsTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [trackingItemsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:dataIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [trackingItemsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.trackingItemsTableView endUpdates];
    
}

#pragma mark - Notification switch

- (void)switchChanged:(UIControl *)sender {
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    BOOL notificationStatus = types != UIRemoteNotificationTypeNone;
    
    if (receiveUpdateSwitch.isOn) {
        if (notificationStatus) {
            //Register for notification
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NOTIFICATION_KEY"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSArray * trackedArray = [self.activeItemsFetchedResultsController fetchedObjects];
            if ([trackedArray count] == 0)
                return;
            
            [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
            
            NSMutableArray * numberArray = [NSMutableArray array];
            for(TrackedItem *trackedItem in trackedArray){
                [numberArray addObject:trackedItem.trackingNumber];
            }
            
            [PushNotificationManager API_subscribeNotificationForTrackingNumberArray:numberArray onCompletion:^(BOOL success, NSError *error) {
                [SVProgressHUD dismiss];
            }];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NOTIFICATION_KEY"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enable notifications in general settings to auto receive updates" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            receiveUpdateSwitch.on = NO;
        }
    }
    else {
        //Deregister for notification
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NOTIFICATION_KEY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSArray * trackedArray = [self.activeItemsFetchedResultsController fetchedObjects];
        if ([trackedArray count] == 0)
            return;
        
        [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
        
        NSMutableArray * numberArray = [NSMutableArray array];
        for(TrackedItem *trackedItem in trackedArray)
            [numberArray addObject:trackedItem.trackingNumber];
        
        [PushNotificationManager API_unsubscribeNotificationForTrackingNumberArray:numberArray onCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
}

#pragma mark - Facebook signin handler
- (void) refreshTableView {
    
    [self.trackingItemsTableView reloadData];
}


#pragma mark - Tracking Labelling
- (NSDictionary *) getLocalLabels {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (NSInteger j = 0; j < [trackingItemsTableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [trackingItemsTableView numberOfRowsInSection:j]; ++i)
        {
            id cell = [trackingItemsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            if(cell)
                [cells addObject:cell];
        }
    }
    
    for (id cell in cells)
    {
        if([cell isKindOfClass:[TrackingItemMainTableViewCell class]]) {
            TrackingItemMainTableViewCell * tempCell = (TrackingItemMainTableViewCell *)cell;
            
            if(![tempCell.signIn2Label.text isEqualToString:@"Sign in to label"] && ![tempCell.signIn2Label.text isEqualToString:@"Enter a label"]) {
                
                NSString * str = tempCell.signIn2Label.text;
                if(str == nil)
                    str = @"";
                if(tempCell.item.trackingNumber != nil)
                    [dic setObject:str forKey:tempCell.item.trackingNumber];

                
            }
            else {
                if(tempCell.item.trackingNumber != nil)
                    [dic setObject:@"" forKey:tempCell.item.trackingNumber];
            }
        }
    }
    
    return dic;
}

- (void) submitAllTrackingItemWithLabel {
    NSArray * arr = [self.allItemsFetchedResultsController fetchedObjects];
    [ApiClient sharedInstance].allTrackingItem = arr;
    
    if([ApiClient sharedInstance].allTrackingItem && [[ApiClient sharedInstance].allTrackingItem count] != 0) {
        
        NSMutableArray * numbers = [NSMutableArray array];
        NSMutableArray * labels = [NSMutableArray array];
        
        NSDictionary * locaLabelDic = [self getLocalLabels];
        
        int i = 0;
        NSArray * trackItemArray = [self.allItemsFetchedResultsController fetchedObjects];
        for(TrackedItem * item in trackItemArray) {
            [numbers addObject:item.trackingNumber];
            
            NSString * label = [locaLabelDic objectForKey:item.trackingNumber];
            if(label != nil)
                [labels addObject:[locaLabelDic objectForKey:item.trackingNumber]];
            else
                [labels addObject:@""];
            
            i++;
        }
        
        [[ApiClient sharedInstance] registerTrackingNunmbers:numbers WithLabels:labels TrackDetails:[ApiClient sharedInstance].allTrackingItem onSuccess:^(id responseObject)
         {
             NSLog(@"registerTrackingNunmbers success");
         } onFailure:^(NSError *error)
         {
             //NSLog([error localizedDescription]);
         }];
        
    } else {
        
        [[ApiClient sharedInstance] deleteAllTrackingNunmbersOnSuccess:^(id responseObject)
         {
             NSLog(@"deleteAllTrackingNunmbersOnSuccess success");
         } onFailure:^(NSError *error)
         {
             //NSLog([error localizedDescription]);
         }];
        
    }
}

- (void) syncLabelsWithTrackingNumbers {
    [self getAllLabel];
}

- (void) getAllLabel {
    [[ApiClient sharedInstance] getAllTrackingNunmbersOnSuccess:^(id responseObject)
     {
         NSLog(@"getAllTrackingNunmbersOnSuccess success");
         
         NSArray * dataArray = (NSArray *)[responseObject objectForKey:@"data"];
         
         if(dataArray == nil)
             return;
         
         NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
         [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         
         NSMutableDictionary * tempDic2 = [NSMutableDictionary dictionary];
         
         for(NSDictionary * dic in dataArray) {
             NSString * trackingDetailsStr = [dic objectForKey:@"tracking_details"];
             NSError * e;
             NSDictionary * trackingJson = [NSJSONSerialization JSONObjectWithData: [trackingDetailsStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                           options: NSJSONReadingMutableContainers
                                                                             error: &e];
             
             if(trackingJson == nil){
                 continue;
             }
             //NSDictionary * tempDic = [[trackingJson objectForKey:@"ItemsTrackingDetailList"] objectForKey:@"ItemTrackingDetail"];
             NSDictionary * tempDic = [trackingJson objectForKey:@"ItemTrackingDetail"];
             
             NSString * trackingNum = [tempDic objectForKey:@"TrackingNumber"];
             
             NSString * str = [dic objectForKey:@"tracking_last_modified"];
             NSDate * lastModifiedDate = [NSDate date];
             
             if(str != nil)
                 lastModifiedDate = [formatter dateFromString:str];
                 
            [self updateTrackItemInfo:trackingNum Info:tempDic Date:lastModifiedDate];
             
             
             [tempDic2 setValue:[dic objectForKey:@"label"] forKey:trackingNum];
         }
         
         NSArray * newLocalItem = [self checkNewLocalItem:dataArray];
         
         labelDic = tempDic2;
         //Got new local items which haven't been sync to the cms.
         //Ask User if he want to sync.
         if([newLocalItem count] > 0) {
             
             [self performSelector:@selector(showSelectView:) withObject:newLocalItem afterDelay:1.0f];
             
             [self refreshTableView];
             return;
         }
         
         
         
         NSArray * arr = [self.allItemsFetchedResultsController fetchedObjects];
         [ApiClient sharedInstance].allTrackingItem = arr;
         [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:YES];
         
         if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NOTIFICATION_KEY"]) {
             NSArray * trackedArray = [self.activeItemsFetchedResultsController fetchedObjects];
             if ([trackedArray count] == 0)
                 return;
             
             NSMutableArray * numberArray = [NSMutableArray array];
             for(TrackedItem *trackedItem in trackedArray){
                 [numberArray addObject:trackedItem.trackingNumber];
             }
             [PushNotificationManager API_subscribeNotificationForTrackingNumberArray:numberArray onCompletion:^(BOOL success, NSError *error) {
             }];
         }
         
         [self submitAllTrackingItemWithLabel];
         
         
     } onFailure:^(NSError *error)
     {
         
     }];
}


- (void) showSelectView : (NSArray *)newLocalItems{
    
    if(vc != nil)
        [vc.view removeFromSuperview];
    
    vc = [[TrackingSelectViewController alloc] init];
    vc.trackItems = newLocalItems;

    [self.view addSubview:vc.view];
    vc.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    vc.view.alpha = 0;
    vc.delegate = self;
    //[self presentViewController:vc animated:YES completion:^{ }];
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         vc.view.alpha = 1;
     } completion:nil];
    
    [self disableSideBar];
}

- (void) disableSideBar {
    [navigationBarView setToggleButtonEnable:NO];
    [infoButton setEnabled:NO];
}

- (void)enableSideBar {
    [navigationBarView setToggleButtonEnable:YES];
    [infoButton setEnabled:YES];
}

- (void) updateSelectItem : (NSArray *) items2Delete {
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    for(TrackedItem * item in items2Delete) {
         //TrackedItem * item2Delete = [[TrackedItem MR_findByAttribute:@"trackingNumber" withValue:item.trackingNumber] firstObject];
        
        [item MR_deleteEntity];
    }
    
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            [self.trackingItemsTableView reloadDataAndWait:^{
                //call the required method here
                [self performSelector:@selector(submitAllTrackingItemWithLabel) withObject:nil afterDelay:0.5f];
            }];
            
            [vc.view removeFromSuperview];
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NOTIFICATION_KEY"]) {
                NSArray * trackedArray = [self.activeItemsFetchedResultsController fetchedObjects];
                if ([trackedArray count] == 0)
                    return;
                
                NSMutableArray * numberArray = [NSMutableArray array];
                for(TrackedItem *trackedItem in trackedArray){
                    [numberArray addObject:trackedItem.trackingNumber];
                }
                [PushNotificationManager API_subscribeNotificationForTrackingNumberArray:numberArray onCompletion:^(BOOL success, NSError *error) {
                }];
            }
            
            [self enableSideBar];
        } else {
            [self performSelector:@selector(submitAllTrackingItemWithLabel) withObject:nil afterDelay:0.2f];
            [vc.view removeFromSuperview];
            [self enableSideBar];
        }
    }];
    [self enableSideBar];
    
}


- (void) updateTrackItemInfo: (NSString *)num Info : (NSDictionary *)dic Date : (NSDate *)lastModifiedDate {
    
    TrackedItem * item = [[TrackedItem MR_findByAttribute:@"trackingNumber" withValue:num] firstObject];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    if(item && ![item isKindOfClass:[NSNull class]]) {
        return;
        
        /*if ([item.lastUpdatedOn compare:lastModifiedDate] == NSOrderedDescending) {
            return;
        }
        
        item.originalCountry = [dic objectForKey:@"OriginalCountry"];
        
        NSString * isFound = [dic objectForKey:@"TrackingNumberFound"];
        if(![isFound isKindOfClass:[NSString class]]) {
            item.isFoundValue = [[dic objectForKey:@"TrackingNumberFound"]boolValue]?true:false;
        }
        
        else
            item.isFoundValue = [[dic objectForKey:@"TrackingNumberFound"] isEqualToString:@"true"]?true:false;
        
        item.destinationCountry = [dic objectForKey:@"DestinationCountry"];
        
        
        item.isActive = ([[dic objectForKey:@"TrackingNumberActive"] boolValue] == 1 ? @"1" : @"0");
        
        item.addedOn = [NSDate date];
        item.isRead = false;
        item.lastUpdatedOn = [NSDate date];
        
        NSArray * statusArray = [[dic objectForKey:@"DeliveryStatusDetails"] objectForKey:@"DeliveryStatusDetail"];
        NSMutableOrderedSet *newStatus = [NSMutableOrderedSet orderedSet];
        for(NSDictionary * dic in statusArray) {
            [newStatus addObject:[DeliveryStatus createFromDicElement:dic inContext:localContext]];
        }
        
        
        for(DeliveryStatus * oldStatus in item.deliveryStatuses) {
            [oldStatus MR_deleteEntity];
        }
        
        item.deliveryStatuses = newStatus;*/
        
    } else {
        item = [TrackedItem MR_createEntity];
        item.trackingNumber = num;
        item.originalCountry = [dic objectForKey:@"OriginalCountry"];
        NSString * isFound = [dic objectForKey:@"TrackingNumberFound"];
        if(![isFound isKindOfClass:[NSString class]]) {
            item.isFoundValue = [[dic objectForKey:@"TrackingNumberFound"]boolValue]?true:false;
        }
        
        else
            item.isFoundValue = [[dic objectForKey:@"TrackingNumberFound"] isEqualToString:@"true"]?true:false;
        item.destinationCountry = [dic objectForKey:@"DestinationCountry"];
        //item.isActive = [dic objectForKey:@"TrackingNumberActive"];
         item.isActive = ([[dic objectForKey:@"TrackingNumberActive"] boolValue] == 1 ? @"true" : @"false");
        
        item.addedOn = [NSDate date];
        item.isRead = false;
        item.lastUpdatedOn = [NSDate date];

        NSArray * statusArray = [[dic objectForKey:@"DeliveryStatusDetails"] objectForKey:@"DeliveryStatusDetail"];
        
        
        NSMutableOrderedSet *newStatus = [NSMutableOrderedSet orderedSet];
        if([statusArray isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dic = (NSDictionary *)statusArray;
            [newStatus addObject:[DeliveryStatus createFromDicElement:dic inContext:localContext]];
        } else {
            
            for(NSDictionary * dic in statusArray) {
                [newStatus addObject:[DeliveryStatus createFromDicElement:dic inContext:localContext]];
            }
        }
        
        item.deliveryStatuses = newStatus;
    }
    
    [localContext MR_saveToPersistentStoreAndWait];
    

}

- (NSArray *) checkNewLocalItem : (NSArray *) remoteDataArray{
    NSMutableArray * newItems = [NSMutableArray array];
    
    NSArray * allLocalItems = [_allItemsFetchedResultsController fetchedObjects];
    
    for(TrackedItem * localItem in allLocalItems) {
        BOOL isFound = false;
        
        for(NSDictionary * remoteItemDic in remoteDataArray) {
            NSString * trackingDetailsStr = [remoteItemDic objectForKey:@"tracking_details"];
            NSError * e;
            NSDictionary * trackingJson = [NSJSONSerialization JSONObjectWithData: [trackingDetailsStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                          options: NSJSONReadingMutableContainers
                                                                            error: &e];
            if(trackingJson == nil){
                continue;
            }
            //NSDictionary * tempDic = [[trackingJson objectForKey:@"ItemsTrackingDetailList"] objectForKey:@"ItemTrackingDetail"];
            
            NSDictionary * tempDic = [trackingJson objectForKey:@"ItemTrackingDetail"];
            
            NSString * trackingNum = [tempDic objectForKey:@"TrackingNumber"];
            
            if([localItem.trackingNumber isEqualToString:trackingNum]) {
                isFound = true;
                break;
            }
        }
        
        if(!isFound) {
            [newItems addObject:localItem];
        }
    }
    
    return newItems;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 160; // tweak as needed
    const float movementDuration = 0.1f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
