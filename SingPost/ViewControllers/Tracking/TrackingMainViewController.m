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
#import "UIColor+SingPost.h"
#import "CTextField.h"
#import "TrackingItemMainTableViewCell.h"
#import "TrackingHeaderMainTableViewCell.h"
#import "TrackingDetailsViewController.h"
#import "AppDelegate.h"
#import <SevenSwitch.h>
#import <KGModal.h>

typedef enum {
    TRACKINGITEMS_SECTION_ACTIVE,
    TRACKINGITEMS_SECTION_COMPLETED,
    
    TRACKINGITEMS_SECTION_TOTAL
} tTrackingItemsSections;

#define TEST_DATA_COUNT 5

@interface TrackingMainViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation TrackingMainViewController
{
    CTextField *trackingNumberTextField;
    UITableView *trackingItemsTableView;
    SevenSwitch *receiveUpdateSwitch;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    //navigation bar
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setShowSidebarToggleButton:YES];
    [navigationBarView setTitle:@"Track"];
    [contentView addSubview:navigationBarView];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton.layer setBorderWidth:1.0f];
    [infoButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [infoButton setTitle:@"Info" forState:UIControlStateNormal];
    [infoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [infoButton.titleLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setFrame:CGRectMake(255, 7, 50, 30)];
    [navigationBarView addSubview:infoButton];
    
    //content
    CGFloat offsetY = INTERFACE_IS_4INCHSCREEN ? 80.0f : 70.0f;
    
    trackingNumberTextField = [[CTextField alloc] initWithFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(15, offsetY, 290, 47) : CGRectMake(15, offsetY, 290, 30)];
    [trackingNumberTextField setPlaceholder:@"Last tracking number entered"];
    [trackingNumberTextField setFontSize:INTERFACE_IS_4INCHSCREEN ? 16.0f : 14.0f];
    [trackingNumberTextField setBackground:[UIImage imageNamed:@"trackingTextBox"]];
    [trackingNumberTextField setInsetBoundsSize: INTERFACE_IS_4INCHSCREEN ? CGSizeMake(5, 12) : CGSizeMake(5, 3)];
    [trackingNumberTextField setText:_trackingNumber];
    [trackingNumberTextField setDelegate:self];
    [contentView addSubview:trackingNumberTextField];
    
    UIButton *findTrackingNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [findTrackingNumberButton setImage:[UIImage imageNamed:@"tracking_button"] forState:UIControlStateNormal];
    [findTrackingNumberButton setFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(265, 87, 35, 35) : CGRectMake(274, 72, 29, 29)];
    [findTrackingNumberButton addTarget:self action:@selector(findTrackingNumberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:findTrackingNumberButton];
    
    offsetY += INTERFACE_IS_4INCHSCREEN ? 60.0f : 45.0f;
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 220, 50)];
    [instructionsLabel setFont:[UIFont SingPostLightFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [instructionsLabel setText:@"Turn on push notification to auto-receive\nlatest status updates of item(s) you are\ncurrently tracking"];
    [instructionsLabel setNumberOfLines:0];
    [instructionsLabel setTextColor:RGB(51, 51, 51)];
    [instructionsLabel setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview:instructionsLabel];
    
    receiveUpdateSwitch = [[SevenSwitch alloc] initWithFrame:CGRectZero];
    receiveUpdateSwitch.onTintColor = [UIColor SingPostBlueColor];
    receiveUpdateSwitch.inactiveColor = [UIColor lightGrayColor];
    receiveUpdateSwitch.center = INTERFACE_IS_4INCHSCREEN ? CGPointMake(278, 165) : CGPointMake(278, 140);
    receiveUpdateSwitch.on = YES;
    [contentView addSubview:receiveUpdateSwitch];
    
    offsetY += 65.0f;

    trackingItemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offsetY, contentView.bounds.size.width, contentView.bounds.size.height - offsetY - [UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    [trackingItemsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [trackingItemsTableView setSeparatorColor:[UIColor clearColor]];
    [trackingItemsTableView setDelegate:self];
    [trackingItemsTableView setDataSource:self];
    [trackingItemsTableView setBackgroundColor:[UIColor clearColor]];
    [trackingItemsTableView setBackgroundView:nil];
    [contentView addSubview:trackingItemsTableView];
    
    self.view = contentView;
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
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - IBActions

- (IBAction)findTrackingNumberButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    NSLog(@"find tracking number button clicked");
}

- (IBAction)infoButtonClicked:(id)sender
{
    UIView *contentView = [[UIView alloc] initWithFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(0, 0, 280, 500) : CGRectMake(0, 0, 280, 400)];
    
    CGRect headerLabelRect = contentView.bounds;
    headerLabelRect.origin.y = 20;
    headerLabelRect.size.height = 20;
    UIFont *headerLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerLabelRect];
    headerLabel.text = @"Tracking information";
    headerLabel.font = headerLabelFont;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:headerLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(headerLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
    infoLabel.text = @"Tracking information";
    infoLabel.numberOfLines = 6;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.shadowColor = [UIColor blackColor];
    infoLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:infoLabel];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

#pragma mark - UITableView DataSource & Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 30.0f;
    
    return (indexPath.row % 2 == 0) ? 44.0f : 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TRACKINGITEMS_SECTION_TOTAL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numHeaders = 1;
    NSInteger numSeparators = numHeaders + (TEST_DATA_COUNT - 1);
    return TEST_DATA_COUNT + numHeaders + numSeparators;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    static NSString *const separatorCellIdentifier = @"SeparatorTableViewCell";

    if (indexPath.row == 0) {
        TrackingHeaderMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
        if (!cell) {
            cell = [[TrackingHeaderMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
        }
        
        return cell;
    }
    else {
        if ((indexPath.row % 2) == 0) {
            TrackingItemMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
            if (!cell)
                cell = [[TrackingItemMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
            
            return cell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:separatorCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:separatorCellIdentifier];
                UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, cell.contentView.bounds.size.width - 30, 1)];
                [separatorView setBackgroundColor:RGB(196, 197, 200)];
                [cell.contentView addSubview:separatorView];
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackingDetailsViewController *trackingDetailsViewController = [[TrackingDetailsViewController alloc] initWithNibName:nil bundle:nil];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:trackingDetailsViewController];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
