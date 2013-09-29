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
    UILabel *trackingNumberValueLabel, *originValueLabel, *destinationValueLabel;
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
    
    UILabel *trackingNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 130, 20)];
    [trackingNumberLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [trackingNumberLabel setText:@"Tracking number"];
    [trackingNumberLabel setBackgroundColor:[UIColor clearColor]];
    [trackingNumberLabel setTextColor:RGB(168, 173, 180)];
    [trackingInfoView addSubview:trackingNumberLabel];
    
    UILabel *originLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 130, 20)];
    [originLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [originLabel setText:@"Origin"];
    [originLabel setBackgroundColor:[UIColor clearColor]];
    [originLabel setTextColor:RGB(168, 173, 180)];
    [trackingInfoView addSubview:originLabel];
    
    UILabel *destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 130, 20)];
    [destinationLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [destinationLabel setText:@"Destination"];
    [destinationLabel setBackgroundColor:[UIColor clearColor]];
    [destinationLabel setTextColor:RGB(168, 173, 180)];
    [trackingInfoView addSubview:destinationLabel];
    
    trackingNumberValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 16, 130, 20)];
    [trackingNumberValueLabel setFont:[UIFont SingPostSemiboldFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [trackingNumberValueLabel setText:@"RA00000000SG"];
    [trackingNumberValueLabel setTextColor:RGB(36, 84, 157)];
    [trackingNumberValueLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:trackingNumberValueLabel];
    
    originValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 40, 130, 20)];
    [originValueLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [originValueLabel setText:@"Singapore"];
    [originValueLabel setTextColor:RGB(51, 51, 51)];
    [originValueLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:originValueLabel];
    
    destinationValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 65, 130, 20)];
    [destinationValueLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [destinationValueLabel setText:@"Australia"];
    [destinationValueLabel setTextColor:RGB(51, 51, 51)];
    [destinationValueLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:destinationValueLabel];
    
    UIView *bottomTrackingInfoSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, trackingInfoView.bounds.size.height - 1, contentView.bounds.size.width, 1)];
    [bottomTrackingInfoSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [trackingInfoView addSubview:bottomTrackingInfoSeparatorView];
    
    //content
    CGFloat offsetY = CGRectGetMaxY(trackingInfoView.frame);
    trackingDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offsetY, contentView.bounds.size.width, contentView.bounds.size.height - offsetY) style:UITableViewStylePlain];
    [trackingDetailTableView setDelegate:self];
    [trackingDetailTableView setDataSource:self];
    [trackingDetailTableView setBackgroundColor:[UIColor whiteColor]];
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
    return 30.0f;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [sectionHeaderView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *dateHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 50, 16)];
    [dateHeaderLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [dateHeaderLabel setText:@"Date"];
    [dateHeaderLabel setTextColor:RGB(125, 136, 149)];
    [dateHeaderLabel setBackgroundColor:[UIColor clearColor]];
    [sectionHeaderView addSubview:dateHeaderLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 50, 16)];
    [statusLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [statusLabel setText:@"Status"];
    [statusLabel setTextColor:RGB(125, 136, 149)];
    [statusLabel setBackgroundColor:[UIColor clearColor]];
    [sectionHeaderView addSubview:statusLabel];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 100, 16)];
    [locationLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [locationLabel setText:@"Location"];
    [locationLabel setTextColor:RGB(125, 136, 149)];
    [locationLabel setBackgroundColor:[UIColor clearColor]];
    [sectionHeaderView addSubview:locationLabel];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, sectionHeaderView.bounds.size.height - 1, sectionHeaderView.bounds.size.width - 30, 1)];
    [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [separatorView setBackgroundColor:RGB(196, 197, 200)];
    [sectionHeaderView addSubview:separatorView];
    
    return sectionHeaderView;
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
