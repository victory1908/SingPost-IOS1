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
#import "TrackingItemDetailTableViewCell.h"
#import <KGModal.h>

@interface TrackingDetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TrackingDetailsViewController
{
    UILabel *trackingNumberLabel, *originLabel, *destinationLabel;
    UITableView *trackingDetailTableView;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    //navigation bar
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setShowBackButton:YES];
    [navigationBarView setTitle:@"Parcel Information"];
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
    [trackingNumberLabel setText:@"RA00000000SG"];
    [trackingNumberLabel setTextColor:RGB(36, 84, 157)];
    [trackingNumberLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:trackingNumberLabel];
    
    originLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 40, 130, 20)];
    [originLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [originLabel setText:@"Singapore"];
    [originLabel setTextColor:RGB(51, 51, 51)];
    [originLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:originLabel];
    
    destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 65, 130, 20)];
    [destinationLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [destinationLabel setText:@"Australia"];
    [destinationLabel setTextColor:RGB(51, 51, 51)];
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
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 100, 16)];
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
    trackingDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 174, contentView.bounds.size.width, contentView.bounds.size.height - 174) style:UITableViewStylePlain];
    [trackingDetailTableView setDelegate:self];
    [trackingDetailTableView setDataSource:self];
    [trackingDetailTableView setBackgroundColor:[UIColor clearColor]];
    [trackingDetailTableView setBackgroundView:nil];
    [trackingDetailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [trackingDetailTableView setSeparatorColor:[UIColor clearColor]];
    [contentView addSubview:trackingDetailTableView];
    
    self.view = contentView;
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
    return 44.0f;
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellIdentifier = @"TrackingItemMainTableViewCell";

    TrackingItemDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TrackingItemDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end
