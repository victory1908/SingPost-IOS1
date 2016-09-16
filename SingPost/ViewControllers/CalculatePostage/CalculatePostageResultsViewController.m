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
#import "CalculatePostageResultItem.h"
#import "MaintanancePageViewController.h"
#import "TermsOfUseViewController.h"

@interface CalculatePostageResultsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation CalculatePostageResultsViewController
{
    UILabel *toCountryLabel, *weightLabel, *expectedDeliveryTimeLabel, *fromPostalCodeLabel, *toPostalCodeLabel;
    UITableView *resultsTableView;
}

//designated initializer
- (id)initWithResultItems:(NSArray *)inResultItems andResultType:(tCalculatePostageResultTypes)inResultType
{
    NSParameterAssert(inResultItems);
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _resultItems = inResultItems;
        _resultType = inResultType;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithResultItems:nil andResultType:CALCULATEPOSTAGE_RESULT_TYPE_OVERSEAS];
}

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
//    [resultsTableView setSeparatorColor:[UIColor clearColor]];
    
    [resultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [resultsTableView setDelegate:self];
    [resultsTableView setDataSource:self];
    [resultsTableView setBackgroundColor:[UIColor whiteColor]];
    [resultsTableView setBackgroundView:nil];

//
    [resultsTableView setEstimatedRowHeight:150];
    [resultsTableView setRowHeight:UITableViewAutomaticDimension];
//    [resultsTableView setRowHeight:200];
    
    [contentView addSubview:resultsTableView];
    
    CGFloat btnWidth = (contentView.width - 40)/2;
    
    FlatBlueButton *locateUsButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(resultsTableView.frame) + 10, btnWidth, 48)];
    [locateUsButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [locateUsButton setTitle:@"LOCATE US" forState:UIControlStateNormal];
    [locateUsButton addTarget:self action:@selector(locateUsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [contentView addSubview:locateUsButton];
//    [locateUsButton addTarget:self action:@selector(locateUsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    FlatBlueButton *calculateAgainButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(locateUsButton.right + 10, locateUsButton.top, btnWidth, 48)];
    [calculateAgainButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [calculateAgainButton addTarget:self action:@selector(calculateAgainButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [calculateAgainButton setTitle:@"CALCULATE AGAIN" forState:UIControlStateNormal];
    [contentView addSubview:calculateAgainButton];
    
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    if ([maintananceStatuses[@"LocateUs"] isEqualToString:@"on"] && locateUsButton != nil)
        locateUsButton.alpha = 0.5;
    
    self.view = contentView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:_resultType == CALCULATEPOSTAGE_RESULT_TYPE_OVERSEAS ? @"Postage Result - Overseas" : @"Postage Result - Singapore"];
    
}

#pragma mark - IBActions

- (IBAction)locateUsButtonClicked:(id)sender
{
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    if ([maintananceStatuses[@"LocateUs"] isEqualToString:@"on"]) {
        MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Locate Us" andMessage:maintananceStatuses[@"Comment"]];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else {
        LocateUsMainViewController *viewController = [[LocateUsMainViewController alloc] initWithNibName:nil bundle:nil];
        viewController.showNavBarBackButton = YES;
        [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
    }
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
    if (indexPath.row == HEADER_ROW) {
        return _resultType == CALCULATEPOSTAGE_RESULT_TYPE_OVERSEAS ? 76.0f : 100.0f;
    }
    
    if (indexPath.row == TITLE_ROW)
        return 40.0f;
    
//    CalculatePostageResultItem *item = _resultItems[indexPath.row - 2];
//    
//    
//    CGRect labelRect = [item.deliveryServiceName boundingRectWithSize:CGSizeMake(190, 0)
//                                                              options:NSStringDrawingUsesLineFragmentOrigin
//                                                           attributes:@{NSFontAttributeName:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]}
//                                                              context:nil];
//    
//    CGFloat labelHeight = labelRect.size.height;
//    
//    
//    return labelHeight + 65.0f;
    return UITableViewAutomaticDimension;
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
    return _resultItems.count + 2; //2 = header + title row
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
            
            UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, _resultType == CALCULATEPOSTAGE_RESULT_TYPE_OVERSEAS ? 78.0f : 100.0f)];
            [cellContentView setBackgroundColor:RGB(240, 240, 240)];
            [cell.contentView addSubview:cellContentView];
            
            CGFloat offsetY = 1.0f;
            
            UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, cellContentView.bounds.size.width, 1)];
            [topSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [topSeparatorView setBackgroundColor:RGB(196, 197, 200)];
            [cellContentView addSubview:topSeparatorView];
            
            offsetY += 14.0f;
            
            if (_resultType == CALCULATEPOSTAGE_RESULT_TYPE_OVERSEAS) {
                UILabel *toCountryDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 130, 20)];
                [toCountryDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
                [toCountryDisplayLabel setText:@"To"];
                [toCountryDisplayLabel setBackgroundColor:[UIColor clearColor]];
                [toCountryDisplayLabel setTextColor:RGB(168, 173, 180)];
                [cellContentView addSubview:toCountryDisplayLabel];
                
                toCountryLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, offsetY, 200, 20)];
                [toCountryLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
                [toCountryLabel setText:_toCountry];
                [toCountryLabel setTextColor:RGB(51, 51, 51)];
                [toCountryLabel setBackgroundColor:[UIColor clearColor]];
                [cellContentView addSubview:toCountryLabel];
                
                offsetY += 25.0f;
                
                UILabel *weightDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 130, 20)];
                [weightDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
                [weightDisplayLabel setText:@"Weight"];
                [weightDisplayLabel setBackgroundColor:[UIColor clearColor]];
                [weightDisplayLabel setTextColor:RGB(168, 173, 180)];
                [cellContentView addSubview:weightDisplayLabel];
                
                weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, offsetY, 200, 20)];
                [weightLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
                [weightLabel setText:_itemWeight];
                [weightLabel setTextColor:RGB(51, 51, 51)];
                [weightLabel setBackgroundColor:[UIColor clearColor]];
                [cellContentView addSubview:weightLabel];
            }
            else if (_resultType == CALCULATEPOSTAGE_RESULT_TYPE_SINGAPORE) {
                UILabel *fromPostalCodeDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 130, 20)];
                [fromPostalCodeDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
                [fromPostalCodeDisplayLabel setText:@"From postal code"];
                [fromPostalCodeDisplayLabel setBackgroundColor:[UIColor clearColor]];
                [fromPostalCodeDisplayLabel setTextColor:RGB(168, 173, 180)];
                [cellContentView addSubview:fromPostalCodeDisplayLabel];
                
                fromPostalCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, offsetY, 100, 20)];
                [fromPostalCodeLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
                [fromPostalCodeLabel setText:_fromPostalCode];
                [fromPostalCodeLabel setTextColor:RGB(51, 51, 51)];
                [fromPostalCodeLabel setBackgroundColor:[UIColor clearColor]];
                [cellContentView addSubview:fromPostalCodeLabel];
                
                offsetY += 25.0f;
                
                UILabel *toPostalCodeDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 130, 20)];
                [toPostalCodeDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
                [toPostalCodeDisplayLabel setText:@"To postal code"];
                [toPostalCodeDisplayLabel setBackgroundColor:[UIColor clearColor]];
                [toPostalCodeDisplayLabel setTextColor:RGB(168, 173, 180)];
                [cellContentView addSubview:toPostalCodeDisplayLabel];
                
                toPostalCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, offsetY, 100, 20)];
                [toPostalCodeLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
                [toPostalCodeLabel setText:_toPostalCode];
                [toPostalCodeLabel setTextColor:RGB(51, 51, 51)];
                [toPostalCodeLabel setBackgroundColor:[UIColor clearColor]];
                [cellContentView addSubview:toPostalCodeLabel];
                
                offsetY += 25.0f;
                
                UILabel *weightDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 130, 20)];
                [weightDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
                [weightDisplayLabel setText:@"Weight"];
                [weightDisplayLabel setBackgroundColor:[UIColor clearColor]];
                [weightDisplayLabel setTextColor:RGB(168, 173, 180)];
                [cellContentView addSubview:weightDisplayLabel];
                
                weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, offsetY, 100, 20)];
                [weightLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
                [weightLabel setText:_itemWeight];
                [weightLabel setTextColor:RGB(51, 51, 51)];
                [weightLabel setBackgroundColor:[UIColor clearColor]];
                [cellContentView addSubview:weightLabel];
            }
            
            offsetY += 35.0f;
            
            UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, cellContentView.bounds.size.width, 1)];
            [bottomSeparatorView setBackgroundColor:RGB(196, 197, 200)];
            [cellContentView addSubview:bottomSeparatorView];
        }
        
        
        return cell;
    }
    else if (indexPath.row == TITLE_ROW) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *titleContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
            [titleContentView setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:titleContentView];
            
            UILabel *serviceHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 50, 16)];
            [serviceHeaderLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
            [serviceHeaderLabel setText:@"Service"];
            [serviceHeaderLabel setTextColor:RGB(125, 136, 149)];
            [serviceHeaderLabel setBackgroundColor:[UIColor clearColor]];
            [titleContentView addSubview:serviceHeaderLabel];
            
            UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(277, 5, 40, 16)];
            costLabel.right = titleContentView.right - 15;
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
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
}

- (void)configureCell:(CalculatePostageResultsItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell setItem:_resultItems[indexPath.row - 2]];
}

@end
