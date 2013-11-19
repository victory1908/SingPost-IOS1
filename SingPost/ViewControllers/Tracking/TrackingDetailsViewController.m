//
//  TrackingDetailsViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TrackingDetailsViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "UIImage+Extensions.h"
#import "TrackingItemDetailTableViewCell.h"
#import "ItemTracking.h"
#import <KGModal.h>
#import <QuartzCore/QuartzCore.h>

@interface TrackingDetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TrackingDetailsViewController
{
    UILabel *trackingNumberLabel, *originLabel, *destinationLabel;
    UITableView *trackingDetailTableView;
    ItemTracking *_trackedItem;
    NSArray *_deliveryStatuses;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    //navigation bar
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setShowBackButton:YES];
    [navigationBarView setTitle:@"Parcel Information"];
    [contentView addSubview:navigationBarView];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton.layer setBorderWidth:1.0f];
    [infoButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [infoButton setBackgroundImage:nil forState:UIControlStateNormal];
    [infoButton setBackgroundImage:[UIImage imageWithColor:RGB(76, 109, 166)] forState:UIControlStateHighlighted];
    [infoButton setTitle:@"Info" forState:UIControlStateNormal];
    [infoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoButton.titleLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setFrame:CGRectMake(255, 7, 50, 30)];
    [navigationBarView addSubview:infoButton];
    
    //tracking info view
    UIView *trackingInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBarView.frame), contentView.bounds.size.width, 100)];
    [trackingInfoView setBackgroundColor:RGB(240, 240, 240)];
    [contentView addSubview:trackingInfoView];
    
    UILabel *trackingNumberDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 130, 20)];
    [trackingNumberDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [trackingNumberDisplayLabel setText:@"Tracking number"];
    [trackingNumberDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [trackingNumberDisplayLabel setTextColor:RGB(168, 173, 180)];
    [trackingInfoView addSubview:trackingNumberDisplayLabel];
    
    UILabel *originDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 130, 20)];
    [originDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [originDisplayLabel setText:@"Origin"];
    [originDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [originDisplayLabel setTextColor:RGB(168, 173, 180)];
    [trackingInfoView addSubview:originDisplayLabel];
    
    UILabel *destinationDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 130, 20)];
    [destinationDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [destinationDisplayLabel setText:@"Destination"];
    [destinationDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [destinationDisplayLabel setTextColor:RGB(168, 173, 180)];
    [trackingInfoView addSubview:destinationDisplayLabel];
    
    trackingNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 16, 130, 20)];
    [trackingNumberLabel setFont:[UIFont SingPostSemiboldFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [trackingNumberLabel setTextColor:RGB(36, 84, 157)];
    [trackingNumberLabel setText:_trackedItem.trackingNumber];
    [trackingNumberLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:trackingNumberLabel];
    
    originLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 40, 130, 20)];
    [originLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [originLabel setTextColor:RGB(51, 51, 51)];
    [originLabel setText:_trackedItem.originalCountry];
    [originLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:originLabel];
    
    destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 65, 130, 20)];
    [destinationLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [destinationLabel setTextColor:RGB(51, 51, 51)];
    [destinationLabel setText:_trackedItem.destinationCountry];
    [destinationLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:destinationLabel];
    
    UIView *bottomTrackingInfoSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, trackingInfoView.bounds.size.height - 1, contentView.bounds.size.width, 1)];
    [bottomTrackingInfoSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [trackingInfoView addSubview:bottomTrackingInfoSeparatorView];
    
    //header view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 144, contentView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *dateHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 50, 16)];
    [dateHeaderLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [dateHeaderLabel setText:@"Date"];
    [dateHeaderLabel setTextColor:RGB(125, 136, 149)];
    [dateHeaderLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:dateHeaderLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 50, 16)];
    [statusLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [statusLabel setText:@"Status"];
    [statusLabel setTextColor:RGB(125, 136, 149)];
    [statusLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:statusLabel];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 100, 16)];
    [locationLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [locationLabel setText:@"Location"];
    [locationLabel setTextColor:RGB(125, 136, 149)];
    [locationLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:locationLabel];
    
    UIView *headerSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(15, headerView.bounds.size.height - 1, headerView.bounds.size.width - 30, 1)];
    [headerSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [headerSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [headerView addSubview:headerSeparatorView];
    [contentView addSubview:headerView];
    
    //content
    trackingDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 174, contentView.bounds.size.width, contentView.bounds.size.height - 194) style:UITableViewStylePlain];
    [trackingDetailTableView setDelegate:self];
    [trackingDetailTableView setDataSource:self];
    [trackingDetailTableView setBackgroundColor:[UIColor clearColor]];
    [trackingDetailTableView setBackgroundView:nil];
    [trackingDetailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [trackingDetailTableView setSeparatorColor:[UIColor clearColor]];
    [contentView addSubview:trackingDetailTableView];
    
    self.view = contentView;
}

//designated initializer
- (id)initWithTrackedItem:(ItemTracking *)inTrackedItem
{
    NSParameterAssert(inTrackedItem);
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _trackedItem = inTrackedItem;
        _deliveryStatuses = _trackedItem.deliveryStatuses.array;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithTrackedItem:nil];
}

#pragma mark - IBActions

- (IBAction)infoButtonClicked:(id)sender
{
    UIView *contentView = [[UIView alloc] initWithFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(0, 0, 280, 500) : CGRectMake(0, 0, 280, 400)];
    
    CGRect headerLabelRect = contentView.bounds;
    headerLabelRect.origin.y = 20;
    headerLabelRect.size.height = 20;
    UIFont *headerLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerLabelRect];
    headerLabel.text = @"Parcel information";
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
    infoLabel.text = @"Parcel information";
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
    return 71.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deliveryStatuses.count;
}

- (void)configureCell:(TrackingItemDetailTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.deliveryStatus = _deliveryStatuses[indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellIdentifier = @"TrackingItemMainTableViewCell";

    TrackingItemDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TrackingItemDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

@end
