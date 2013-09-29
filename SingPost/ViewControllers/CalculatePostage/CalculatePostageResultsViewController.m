//
//  CalculatePostageResultsViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CalculatePostageResultsViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"

@interface CalculatePostageResultsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation CalculatePostageResultsViewController
{
    UILabel *toLabel, *weightLabel, *expectedDeliveryTimeLabel;
    UITableView *resultsTableView;
}

#define TEST_DATA_COUNT 8

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Calculate Postage"];
    [navigationBarView setShowBackButton:YES];
    [contentView addSubview:navigationBarView];
    
    //postage results view
    UIView *postageResultsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBarView.frame), contentView.bounds.size.width, 100)];
    [postageResultsView setBackgroundColor:RGB(240, 240, 240)];
    [contentView addSubview:postageResultsView];
    
    UILabel *toDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 130, 20)];
    [toDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [toDisplayLabel setText:@"To"];
    [toDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [toDisplayLabel setTextColor:RGB(168, 173, 180)];
    [postageResultsView addSubview:toDisplayLabel];
    
    UILabel *weightDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 130, 20)];
    [weightDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [weightDisplayLabel setText:@"Weight"];
    [weightDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [weightDisplayLabel setTextColor:RGB(168, 173, 180)];
    [postageResultsView addSubview:weightDisplayLabel];
    
    UILabel *expectedDeliveryTimeDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 170, 20)];
    [expectedDeliveryTimeDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [expectedDeliveryTimeDisplayLabel setText:@"Expected delivery time"];
    [expectedDeliveryTimeDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [expectedDeliveryTimeDisplayLabel setTextColor:RGB(168, 173, 180)];
    [postageResultsView addSubview:expectedDeliveryTimeDisplayLabel];
    
    toLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 16, 100, 20)];
    [toLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [toLabel setText:@"Australia"];
    [toLabel setTextColor:RGB(51, 51, 51)];
    [toLabel setBackgroundColor:[UIColor clearColor]];
    [postageResultsView addSubview:toLabel];

    weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 40, 100, 20)];
    [weightLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [weightLabel setText:@"10 kg"];
    [weightLabel setTextColor:RGB(51, 51, 51)];
    [weightLabel setBackgroundColor:[UIColor clearColor]];
    [postageResultsView addSubview:weightLabel];

    expectedDeliveryTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 65, 100, 20)];
    [expectedDeliveryTimeLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [expectedDeliveryTimeLabel setText:@"2 days"];
    [expectedDeliveryTimeLabel setTextColor:RGB(51, 51, 51)];
    [expectedDeliveryTimeLabel setBackgroundColor:[UIColor clearColor]];
    [postageResultsView addSubview:expectedDeliveryTimeLabel];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, postageResultsView.bounds.size.height - 1, contentView.bounds.size.width, 1)];
    [separatorView setBackgroundColor:RGB(196, 197, 200)];
    [postageResultsView addSubview:separatorView];
    
    resultsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 144, contentView.bounds.size.width, contentView.bounds.size.height - 300) style:UITableViewStylePlain];
    [resultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [resultsTableView setSeparatorColor:[UIColor clearColor]];
    [resultsTableView setDelegate:self];
    [resultsTableView setDataSource:self];
    [resultsTableView setBackgroundColor:[UIColor whiteColor]];
    [resultsTableView setShowsVerticalScrollIndicator:NO];
    [resultsTableView setBackgroundView:nil];
    [contentView addSubview:resultsTableView];
    
    UIButton *findSingpostLocationNearYouButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [findSingpostLocationNearYouButton setBackgroundImage:[[UIImage imageNamed:@"blue_bg_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] forState:UIControlStateNormal];
    [findSingpostLocationNearYouButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [findSingpostLocationNearYouButton setFrame:CGRectMake(15, CGRectGetMaxY(resultsTableView.frame) + 15, contentView.bounds.size.width - 30, 48)];
    [findSingpostLocationNearYouButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [findSingpostLocationNearYouButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [findSingpostLocationNearYouButton addTarget:self action:@selector(findSingpostLocationNearYouButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [findSingpostLocationNearYouButton setTitle:@"FIND SINGPOST LOCATION NEAR YOU" forState:UIControlStateNormal];
    [contentView addSubview:findSingpostLocationNearYouButton];
    
    UIButton *calculateAgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [calculateAgainButton setBackgroundImage:[[UIImage imageNamed:@"blue_bg_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] forState:UIControlStateNormal];
    [calculateAgainButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [calculateAgainButton setFrame:CGRectMake(15, CGRectGetMaxY(findSingpostLocationNearYouButton.frame) + 5, contentView.bounds.size.width - 30, 48)];
    [calculateAgainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [calculateAgainButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [calculateAgainButton addTarget:self action:@selector(calculateAgainButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [calculateAgainButton setTitle:@"CALCULATE AGAIN" forState:UIControlStateNormal];
    [contentView addSubview:calculateAgainButton];
    
    self.view = contentView;
}

#pragma mark - IBActions

- (IBAction)findSingpostLocationNearYouButtonClicked:(id)sender
{
    NSLog(@"find sing post near you clicked");
}

- (IBAction)calculateAgainButtonClicked:(id)sender
{
    NSLog(@"calculate again button clicked");
}

#pragma mark - UITableView DataSource & Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0f;
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
    NSInteger numHeaders = 1;
    NSInteger numSeparators = numHeaders + (TEST_DATA_COUNT - 1);
    return TEST_DATA_COUNT + numHeaders + numSeparators;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [sectionHeaderView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *serviceHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 50, 16)];
    [serviceHeaderLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [serviceHeaderLabel setText:@"Service"];
    [serviceHeaderLabel setTextColor:RGB(125, 136, 149)];
    [serviceHeaderLabel setBackgroundColor:[UIColor clearColor]];
    [sectionHeaderView addSubview:serviceHeaderLabel];
    
    UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 5, 100, 16)];
    [costLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [costLabel setText:@"Cost"];
    [costLabel setTextColor:RGB(125, 136, 149)];
    [costLabel setBackgroundColor:[UIColor clearColor]];
    [sectionHeaderView addSubview:costLabel];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, sectionHeaderView.bounds.size.height - 1, sectionHeaderView.bounds.size.width - 30, 1)];
    [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [separatorView setBackgroundColor:RGB(196, 197, 200)];
    [sectionHeaderView addSubview:separatorView];
    
    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellIdentifier = @"ResultsTableViewCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    
    return cell;
}

@end
