//
//  FindPostalCodePOBoxViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 14/11/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "FindPostalCodePOBoxViewController.h"
#import "CTextField.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIFont+SingPost.h"
#import "FlatBlueButton.h"
#import <QuartzCore/QuartzCore.h>
#import "CDropDownListControl.h"
#import "SVProgressHUD.h"
#import "PostalCode.h"
#import "PostalCodePoBoxTableViewCell.h"
#import "NSString+Extensions.h"
#import "UIView+Origami.h"

@interface FindPostalCodePOBoxViewController () <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@end

@implementation FindPostalCodePOBoxViewController
{
    UIScrollView *contentScrollView;
    CTextField *windowDeliveryNoTextField, *postOfficeTextField;
    CDropDownListControl *typeDropDownList;
    UITableView *resultsTableView;
    NSArray *_searchResults;
    
    UIView * searchTermsView, * searchResultsContainerView;
    BOOL isAnimating;
    BOOL isSearchTermViewShown;
}

- (void)loadView {
    contentScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    searchTermsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.bounds.size.width,225)];
    
    postOfficeTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 85, contentScrollView.width - 30, 44)];
    postOfficeTextField.delegate = self;
    [postOfficeTextField setPlaceholder:@"Name of Post Office (Min. 3 characters)"];
    [searchTermsView addSubview:postOfficeTextField];
    
    typeDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(160, 20, 145, 54)];
    typeDropDownList.right = postOfficeTextField.right;
    [typeDropDownList setFontSize:14.0f];
    [typeDropDownList setPlistValueFile:@"FindPostalCodes_Types"];
    [typeDropDownList selectRow:0 animated:NO];
    [searchTermsView addSubview:typeDropDownList];
    
    windowDeliveryNoTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 20, contentScrollView.width - 40 - typeDropDownList.width, 54)];
    windowDeliveryNoTextField.delegate = self;
    [windowDeliveryNoTextField setPlaceholder:@"Reference No\n(Min. 1 character)"];
    [searchTermsView addSubview:windowDeliveryNoTextField];
    
    UILabel *allFieldMandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 134, 290, 20)];
    [allFieldMandatoryLabel setText:@"All fields above are mandatory"];
    [allFieldMandatoryLabel setBackgroundColor:[UIColor clearColor]];
    [allFieldMandatoryLabel setTextColor:RGB(125, 136, 149)];
    [allFieldMandatoryLabel setFont:[UIFont SingPostLightItalicFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [searchTermsView addSubview:allFieldMandatoryLabel];
    
    FlatBlueButton *findButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, 159, contentScrollView.bounds.size.width - 30, 48)];
    [findButton addTarget:self action:@selector(findButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [findButton setTitle:@"FIND" forState:UIControlStateNormal];
    [searchTermsView addSubview:findButton];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 224, contentScrollView.width, 0.5f)];
    [separatorView setBackgroundColor:RGB(196, 197, 200)];
    [searchTermsView addSubview:separatorView];
    
    searchResultsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.bounds.size.width, contentScrollView.bounds.size.height - 64)];
    [contentScrollView addSubview:searchResultsContainerView];
    
    resultsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.bounds.size.width, contentScrollView.bounds.size.height - 118) style:UITableViewStylePlain];
    [resultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [resultsTableView setSeparatorColor:[UIColor clearColor]];
    [resultsTableView setDelegate:self];
    [resultsTableView setDataSource:self];
    [resultsTableView setBackgroundColor:[UIColor whiteColor]];
    [resultsTableView setBackgroundView:nil];
    [searchResultsContainerView addSubview:resultsTableView];
    
    self.view = contentScrollView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Postcode - PO Box"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSearchTermsView:YES];
}

#pragma mark - IBActions

- (IBAction)findButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    if ([[postOfficeTextField.text trimWhiteSpaces] length] < 3 || [[windowDeliveryNoTextField.text trimWhiteSpaces] length] == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:INCOMPLETE_FIELDS_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:INCOMPLETE_FIELDS_ERROR preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"warmHasInternet"];
    
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        _searchResults = nil;
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@"Please wait"];
//        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeClear];
        [PostalCode API_findPostalCodeForWindowsDeliveryNo:windowDeliveryNoTextField.text andType:typeDropDownList.selectedValue andPostOffice:postOfficeTextField.text onCompletion:^(NSArray *results, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"An error has occurred"];
            }
            else {
                _searchResults = results;
                [SVProgressHUD dismiss];
            }
            
            [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Postcode Result - PO Box"];
            
            if (results.count == 0) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NO_RESULTS_ERROR delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//                [alertView show];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NO_RESULTS_ERROR preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            if (results.count > 20) {
                _searchResults = nil;
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Your enquiry matches a lot of addresses, Please make your enquiry as detailed as possible." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Your enquiry matches a lot of addresses, Please make your enquiry as detailed as possible." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
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
    
    //CGSize labelSize = [result[@"postoffice"] sizeWithFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans] constrainedToSize:LOCATION_LABEL_SIZE];
    
    CGSize labelSize = [result[@"postoffice"] sizeWithAttributes:@{NSFontAttributeName:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]}];
    
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
            
            CGFloat width;
            if (INTERFACE_IS_IPAD)
                width = 768;
            else
                width = 320;
            
            UIView *titleContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 35)];
            [titleContentView setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:titleContentView];
            
            UILabel *postOfficeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 170, 16)];
            [postOfficeLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
            [postOfficeLabel setText:@"Post Office"];
            [postOfficeLabel setTextColor:RGB(125, 136, 149)];
            [postOfficeLabel setBackgroundColor:[UIColor clearColor]];
            [titleContentView addSubview:postOfficeLabel];
            
            UILabel *postalCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(232, 9, 75, 16)];
            postalCodeLabel.right = width - 15;
            [postalCodeLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
            [postalCodeLabel setText:@"Postal Code"];
            [postalCodeLabel setTextColor:RGB(125, 136, 149)];
            [postalCodeLabel setBackgroundColor:[UIColor clearColor]];
            [titleContentView addSubview:postalCodeLabel];
            
            UIView *headerViewSeparator = [[UIView alloc] initWithFrame:CGRectMake(15, titleContentView.bounds.size.height - 1, width - 30, 0.5f)];
            [headerViewSeparator setBackgroundColor:RGB(196, 197, 200)];
            [titleContentView addSubview:headerViewSeparator];
        }
        
        return cell;
    }
    
    else {
        PostalCodePoBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[PostalCodePoBoxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
}

- (void)configureCell:(PostalCodePoBoxTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell setResult:_searchResults[indexPath.row - 1]];
}

#define ANIMATION_DURATION 0.5f

- (void)showSearchTermsView:(BOOL)shouldShowSearchTermsView
{
    if ((shouldShowSearchTermsView && isSearchTermViewShown) || (!shouldShowSearchTermsView && !isSearchTermViewShown)) {
        return;
    }
    
    if (!isAnimating) {
        isAnimating = YES;
        [self.view endEditing:YES];
        [resultsTableView setBounces:NO];
        if (!shouldShowSearchTermsView)
            [resultsTableView setScrollEnabled:NO];
        
        if (shouldShowSearchTermsView) {
            [searchResultsContainerView showOrigamiTransitionWith:searchTermsView NumberOfFolds:1 Duration:ANIMATION_DURATION Direction:XYOrigamiDirectionFromTop completion:^(BOOL finished) {
                [resultsTableView setBounces:YES];
                
                isSearchTermViewShown = YES;
                isAnimating = NO;
            }];
        }
        else {
            [resultsTableView setContentOffset:CGPointZero];
            [searchResultsContainerView hideOrigamiTransitionWith:searchTermsView NumberOfFolds:1 Duration:ANIMATION_DURATION Direction:XYOrigamiDirectionFromTop completion:^(BOOL finished) {
                [resultsTableView setBounces:YES];
                [resultsTableView setScrollEnabled:YES];
                
                isSearchTermViewShown = NO;
                isAnimating = NO;
            }];
        }
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isTracking) {
        if (scrollView.contentOffset.y < 0)
            [self showSearchTermsView:YES];
        else if (scrollView.contentOffset.y >= 0)
            [self showSearchTermsView:NO];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == windowDeliveryNoTextField) {
        [postOfficeTextField becomeFirstResponder];
        return YES;
    }
    else {
        [textField resignFirstResponder];
        return NO;
    }
}

@end
