//
//  FindPostalCodeStreetViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 14/11/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "FindPostalCodeStreetViewController.h"
#import "CTextField.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIFont+SingPost.h"
#import "FlatBlueButton.h"
#import <QuartzCore/QuartzCore.h>
#import <SVProgressHUD.h>
#import "PostalCode.h"
#import "PostalCodeStreetTableViewCell.h"
#import "NSString+Extensions.h"

@interface FindPostalCodeStreetViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FindPostalCodeStreetViewController
{
    TPKeyboardAvoidingScrollView *contentScrollView;
    CTextField *buildingBlockHouseNumberTextField, *streetNameTextField;
    UITableView *resultsTableView;
    NSArray *_searchResults;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [contentScrollView setDelaysContentTouches:NO];
        [contentScrollView setContentSize:CGSizeMake(320, 370)];
        [contentScrollView setBackgroundColor:[UIColor clearColor]];
        
        buildingBlockHouseNumberTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 20, 290, 44)];
        [buildingBlockHouseNumberTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [buildingBlockHouseNumberTextField setPlaceholder:@"Building/block/house number (Min. 1 character)"];
        [contentScrollView addSubview:buildingBlockHouseNumberTextField];
        
        streetNameTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 75, 290, 44)];
        [streetNameTextField setPlaceholder:@"Street name (Min. 3 characters)"];
        [contentScrollView addSubview:streetNameTextField];
        
        UILabel *allFieldMandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 125, 290, 20)];
        [allFieldMandatoryLabel setText:@"All fields above are mandatory"];
        [allFieldMandatoryLabel setBackgroundColor:[UIColor clearColor]];
        [allFieldMandatoryLabel setTextColor:RGB(125, 136, 149)];
        [allFieldMandatoryLabel setFont:[UIFont SingPostLightItalicFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [contentScrollView addSubview:allFieldMandatoryLabel];
        
        FlatBlueButton *findButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, 165, contentScrollView.bounds.size.width - 30, 48)];
        [findButton addTarget:self action:@selector(findButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [findButton setTitle:@"FIND" forState:UIControlStateNormal];
        [contentScrollView addSubview:findButton];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 234, 320, 0.5f)];
        [separatorView setBackgroundColor:RGB(196, 197, 200)];
        [contentScrollView addSubview:separatorView];
        
        resultsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 235, contentScrollView.bounds.size.width, contentScrollView.bounds.size.height - 351) style:UITableViewStylePlain];
        [resultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [resultsTableView setSeparatorColor:[UIColor clearColor]];
        [resultsTableView setDelegate:self];
        [resultsTableView setDataSource:self];
        [resultsTableView setBackgroundColor:[UIColor whiteColor]];
        [resultsTableView setBackgroundView:nil];
        [contentScrollView addSubview:resultsTableView];
        
        self.view = contentScrollView;
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Postcode - Street"];
}

- (IBAction)findButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    if ([[streetNameTextField.text trimWhiteSpaces] length] < 3) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Enter a minimum of 3 characters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([[buildingBlockHouseNumberTextField.text trimWhiteSpaces] length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Enter a minimum of 1 character" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeClear];
        [PostalCode API_findPostalCodeForBuildingNo:buildingBlockHouseNumberTextField.text andStreetName:streetNameTextField.text onCompletion:^(NSArray *results, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"An error has occurred"];
            }
            else {
                _searchResults = results;
                [SVProgressHUD dismiss];
            }
            
            [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Postcode Result- Street"];
            
            if (results.count == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Sorry, there are no results found. Please try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }
            if (results.count > 20) {
                _searchResults = nil;
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Your enquiry matches a lot of addresses, Please make your enquiry as detailed as possible." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
            [resultsTableView reloadData];
            [resultsTableView setContentOffset:CGPointZero animated:YES];
            
        }];
    }
}


#pragma mark - UITableView DataSource & Delegate

#define TITLE_ROW 0

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == TITLE_ROW)
        return 35.0f;
    
    NSDictionary *result = _searchResults[indexPath.row - 1];
    
    CGSize labelSize = [[NSString stringWithFormat:@"%@ %@", result[@"buildingno"], result[@"streetname"]] sizeWithFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans] constrainedToSize:LOCATION_LABEL_SIZE];
    
    return MAX(36.0f, labelSize.height + 21.0f);
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
    return _searchResults.count + 1; //1 = title row
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const titleCellIdentifier = @"PostalCodeLandmarkResultsTitleTableViewCell";
    static NSString *const cellIdentifier = @"PostalCodeLandmarkItemTableViewCell";
    
    if (indexPath.row == TITLE_ROW) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *titleContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, 35)];
            [titleContentView setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:titleContentView];
            
            UILabel *majorBuildingEstateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 170, 16)];
            [majorBuildingEstateLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
            [majorBuildingEstateLabel setText:@"Street name"];
            [majorBuildingEstateLabel setTextColor:RGB(125, 136, 149)];
            [majorBuildingEstateLabel setBackgroundColor:[UIColor clearColor]];
            [titleContentView addSubview:majorBuildingEstateLabel];
            
            UILabel *postalCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(232, 9, 75, 16)];
            [postalCodeLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
            [postalCodeLabel setText:@"Postal Code"];
            [postalCodeLabel setTextColor:RGB(125, 136, 149)];
            [postalCodeLabel setBackgroundColor:[UIColor clearColor]];
            [titleContentView addSubview:postalCodeLabel];
            
            UIView *headerViewSeparator = [[UIView alloc] initWithFrame:CGRectMake(15, titleContentView.bounds.size.height - 1, titleContentView.bounds.size.width - 30, 0.5f)];
            [headerViewSeparator setBackgroundColor:RGB(196, 197, 200)];
            [titleContentView addSubview:headerViewSeparator];
        }
        
        return cell;
    }
    
    else {
        PostalCodeStreetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[PostalCodeStreetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
}

- (void)configureCell:(PostalCodeStreetTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell setResult:_searchResults[indexPath.row - 1]];
}

@end
