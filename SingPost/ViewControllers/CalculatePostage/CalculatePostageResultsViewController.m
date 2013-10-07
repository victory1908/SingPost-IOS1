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
#import "CalculatePostageResultsItemTableViewCell.h"
#import "AppDelegate.h"
#import "FlatBlueButton.h"
#import "LocateUsMainViewController.h"

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
    
    resultsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 135) style:UITableViewStylePlain];
    [resultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [resultsTableView setSeparatorColor:[UIColor clearColor]];
    [resultsTableView setDelegate:self];
    [resultsTableView setDataSource:self];
    [resultsTableView setBackgroundColor:[UIColor whiteColor]];
    [resultsTableView setBackgroundView:nil];
    [contentView addSubview:resultsTableView];
    
    FlatBlueButton *locateUsButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(resultsTableView.frame) + 10, 125, 48)];
    [locateUsButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [locateUsButton addTarget:self action:@selector(locateUsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [locateUsButton setTitle:@"LOCATE US" forState:UIControlStateNormal];
    [contentView addSubview:locateUsButton];

    FlatBlueButton *calculateAgainButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(145, locateUsButton.frame.origin.y, 160, 48)];
    [calculateAgainButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [calculateAgainButton addTarget:self action:@selector(calculateAgainButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [calculateAgainButton setTitle:@"CALCULATE AGAIN" forState:UIControlStateNormal];
    [contentView addSubview:calculateAgainButton];
    
    self.view = contentView;
}

#pragma mark - IBActions

- (IBAction)locateUsButtonClicked:(id)sender
{
    LocateUsMainViewController *viewController = [[LocateUsMainViewController alloc] initWithNibName:nil bundle:nil];
    viewController.showNavBarBackButton = YES;
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
}

- (IBAction)calculateAgainButtonClicked:(id)sender
{
    [[AppDelegate sharedAppDelegate].rootViewController cPopViewController];
}

#pragma mark - UITableView DataSource & Delegate

#define HEADER_ROW 0
#define TITLE_ROW 1

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == HEADER_ROW)
        return 100.0f;

    if (indexPath.row == TITLE_ROW)
        return 30.0f;

    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TEST_DATA_COUNT + 2; //2 = header + title row
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const headerCellIdentifier = @"CalculatePostageResultsHeaderTableViewCell";
    static NSString *const titleCellIdentifier = @"CalculatePostageResultsTitleTableViewCell";
    static NSString *const cellIdentifier = @"CalculatePostageResultsItemTableViewCell";
    
    if (indexPath.row == HEADER_ROW) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, 100)];
            [cellContentView setBackgroundColor:RGB(240, 240, 240)];
            [cell.contentView addSubview:cellContentView];
            
            UILabel *toDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 130, 20)];
            [toDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [toDisplayLabel setText:@"To"];
            [toDisplayLabel setBackgroundColor:[UIColor clearColor]];
            [toDisplayLabel setTextColor:RGB(168, 173, 180)];
            [cellContentView addSubview:toDisplayLabel];
            
            UILabel *weightDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 130, 20)];
            [weightDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [weightDisplayLabel setText:@"Weight"];
            [weightDisplayLabel setBackgroundColor:[UIColor clearColor]];
            [weightDisplayLabel setTextColor:RGB(168, 173, 180)];
            [cellContentView addSubview:weightDisplayLabel];
            
            UILabel *expectedDeliveryTimeDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 170, 20)];
            [expectedDeliveryTimeDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [expectedDeliveryTimeDisplayLabel setText:@"Expected delivery time"];
            [expectedDeliveryTimeDisplayLabel setBackgroundColor:[UIColor clearColor]];
            [expectedDeliveryTimeDisplayLabel setTextColor:RGB(168, 173, 180)];
            [cellContentView addSubview:expectedDeliveryTimeDisplayLabel];
            
            toLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 16, 100, 20)];
            [toLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [toLabel setText:@"Australia"];
            [toLabel setTextColor:RGB(51, 51, 51)];
            [toLabel setBackgroundColor:[UIColor clearColor]];
            [cellContentView addSubview:toLabel];
            
            weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 40, 100, 20)];
            [weightLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [weightLabel setText:@"10 kg"];
            [weightLabel setTextColor:RGB(51, 51, 51)];
            [weightLabel setBackgroundColor:[UIColor clearColor]];
            [cellContentView addSubview:weightLabel];
            
            expectedDeliveryTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 65, 100, 20)];
            [expectedDeliveryTimeLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [expectedDeliveryTimeLabel setText:@"2 days"];
            [expectedDeliveryTimeLabel setTextColor:RGB(51, 51, 51)];
            [expectedDeliveryTimeLabel setBackgroundColor:[UIColor clearColor]];
            [cellContentView addSubview:expectedDeliveryTimeLabel];
            
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cellContentView.bounds.size.height - 1, cellContentView.bounds.size.width, 1)];
            [separatorView setBackgroundColor:RGB(196, 197, 200)];
            [cellContentView addSubview:separatorView];
        }
        
        return cell;
    }
    else if (indexPath.row == TITLE_ROW) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *titleContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, 30)];
            [titleContentView setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:titleContentView];
            
            UILabel *serviceHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 50, 16)];
            [serviceHeaderLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
            [serviceHeaderLabel setText:@"Service"];
            [serviceHeaderLabel setTextColor:RGB(125, 136, 149)];
            [serviceHeaderLabel setBackgroundColor:[UIColor clearColor]];
            [titleContentView addSubview:serviceHeaderLabel];
            
            UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 5, 100, 16)];
            [costLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
            [costLabel setText:@"Cost"];
            [costLabel setTextColor:RGB(125, 136, 149)];
            [costLabel setBackgroundColor:[UIColor clearColor]];
            [titleContentView addSubview:costLabel];
            
            UIView *headerViewSeparator = [[UIView alloc] initWithFrame:CGRectMake(15, titleContentView.bounds.size.height - 1, titleContentView.bounds.size.width - 30, 1)];
            [headerViewSeparator setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [headerViewSeparator setBackgroundColor:RGB(196, 197, 200)];
            [titleContentView addSubview:headerViewSeparator];
        }
        
        return cell;
    }
    else {
        CalculatePostageResultsItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[CalculatePostageResultsItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
}

@end
