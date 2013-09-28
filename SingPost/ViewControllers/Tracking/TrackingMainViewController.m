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
#import "TrackingNumberTextField.h"
#import "TrackingItemMainTableViewCell.h"
#import "TrackingHeaderMainTableViewCell.h"
#import <SevenSwitch.h>

typedef enum {
    TRACKINGITEMS_SECTION_ACTIVE,
    TRACKINGITEMS_SECTION_COMPLETED,
    
    TRACKINGITEMS_SECTION_TOTAL
} tTrackingItemsSections;

@interface TrackingMainViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation TrackingMainViewController
{
    TrackingNumberTextField *trackingNumberTextField;
    UITableView *trackingItemsTableView;
    SevenSwitch *receiveUpdateSwitch;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
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
    [infoButton setFrame:CGRectMake(250, 7, 50, 30)];
    [navigationBarView addSubview:infoButton];
    
    UIImageView *trackingTextBoxBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trackingTextBox_grayBg"]];
    [trackingTextBoxBackgroundImageView setFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(15, 80, 290, 47) : CGRectMake(15, 70, 290, 30)];
    [contentView addSubview:trackingTextBoxBackgroundImageView];
    
    trackingNumberTextField = [[TrackingNumberTextField alloc] initWithFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(20, 80, 240, 47) : CGRectMake(20, 70, 245, 30)];
    [trackingNumberTextField setBackgroundColor:[UIColor clearColor]];
    [trackingNumberTextField setPlaceholder:@"Last tracking number entered"];
    [trackingNumberTextField setDelegate:self];
    [contentView addSubview:trackingNumberTextField];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 140, 220, 50)];
    [instructionsLabel setFont:[UIFont SingPostLightFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [instructionsLabel setText:@"Turn on push notification to auto-receive\nlatest status updates of item(s) you are\ncurrently tracking"];
    [instructionsLabel setNumberOfLines:0];
    [instructionsLabel setTextColor:RGB(51, 51, 51)];
    [instructionsLabel setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview:instructionsLabel];
    
    receiveUpdateSwitch = [[SevenSwitch alloc] initWithFrame:CGRectZero];
    receiveUpdateSwitch.onTintColor = [UIColor SingPostBlueColor];
    receiveUpdateSwitch.inactiveColor = [UIColor lightGrayColor];
    receiveUpdateSwitch.center = CGPointMake(270, 165);
    [contentView addSubview:receiveUpdateSwitch];

    trackingItemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, contentView.bounds.size.width, contentView.bounds.size.height - 200) style:UITableViewStyleGrouped];
    [trackingItemsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [trackingItemsTableView setSeparatorColor:[UIColor clearColor]];
    [trackingItemsTableView setDelegate:self];
    [trackingItemsTableView setDataSource:self];
    [trackingItemsTableView setBackgroundColor:[UIColor clearColor]];
    [trackingItemsTableView setShowsVerticalScrollIndicator:NO];
    [trackingItemsTableView setBackgroundView:nil];
    [contentView addSubview:trackingItemsTableView];
    
    [contentView endEditing:YES];
    
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
    return YES;
}

#pragma mark - IBActions

- (IBAction)infoButtonClicked:(id)sender
{
    NSLog(@"info button is clicked");
}

#pragma mark - UITableView DataSource & Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0) ? 36.0f : 44.0f;
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
    return 4;
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
    static NSString *const itemCellIdentifier = @"TrackingItemMainTableViewCell";
    static NSString *const headerCellIdentifier = @"TrackingHeaderMainTableViewCell";

    if (indexPath.row == 0) {
        TrackingHeaderMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
        if (!cell) {
            cell = [[TrackingHeaderMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIdentifier];
        }
        
        return cell;
    }
    else {
        TrackingItemMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
        if (!cell) {
            cell = [[TrackingItemMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
        }
        
        [cell setShowBottomSeparator:indexPath.row < 3];
        
        return cell;
    }
}


@end
