//
//  ArticleViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ArticleViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "AppDelegate.h"
#import "ArticleTableViewCell.h"
#import "ArticleSubCategoryViewController.h"
#import "Article.h"
#import <SVProgressHUD.h>

@interface ArticleViewController () <UITableViewDataSource, UITableViewDelegate>


@end

@implementation ArticleViewController
{
    NavigationBarView *navigationBarView;
    UITableView *contentsTableView;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:_pageTitle];
    [contentView addSubview:navigationBarView];
    
    UIView *instructionsLabelBackgroundView = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, 100)];
    [instructionsLabelBackgroundView setBackgroundColor:RGB(240, 240, 240)];
    [contentView addSubview:instructionsLabelBackgroundView];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, instructionsLabelBackgroundView.bounds.size.width - 30, instructionsLabelBackgroundView.bounds.size.height)];
    [instructionsLabel setNumberOfLines:0];
    [instructionsLabel setText:@"Lorem ipstum dolor amet, consectetur adipiscing elit. Cras metus massa, lacinia et neque vel, feugiat condimentum odio."];
    [instructionsLabel setTextColor:RGB(58, 68, 81)];
    [instructionsLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [instructionsLabel setBackgroundColor:RGB(240, 240, 240)];
    [instructionsLabelBackgroundView addSubview:instructionsLabel];
    
    contentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 144, contentView.bounds.size.width, contentView.bounds.size.height - 144 - [UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    [contentsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [contentsTableView setSeparatorColor:[UIColor clearColor]];
    [contentsTableView setBackgroundView:nil];
    [contentsTableView setDelegate:self];
    [contentsTableView setDataSource:self];
    [contentsTableView setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:contentsTableView];
    
    self.view = contentView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:self.pageTitle];
}

#pragma mark - Accessors

- (void)setIsRootLevel:(BOOL)inIsRootLevel
{
    _isRootLevel = inIsRootLevel;
    [navigationBarView setShowSidebarToggleButton:_isRootLevel];
    [navigationBarView setShowBackButton:!_isRootLevel];
}

- (void)setPageTitle:(NSString *)inPageTitle
{
    _pageTitle = inPageTitle;
    [navigationBarView setTitle:_pageTitle];
}

- (void)setJsonItems:(NSDictionary *)inJsonData
{
    _jsonItems = inJsonData;
    [contentsTableView reloadData];
}

#pragma mark - UITableView DataSource & Delegate

- (void)configureCell:(ArticleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.title = _isRootLevel ? self.jsonItems[@"keys"][indexPath.row] : self.subJsonItems[indexPath.row][@"Name"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isRootLevel ? [self.jsonItems[@"keys"] count] : [self.subJsonItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const itemCellIdentifier = @"ArticleItemTableViewCell";
    
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
    if (!cell)
        cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleSubCategoryViewController *subCategoryViewController = [[ArticleSubCategoryViewController alloc] initWithNibName:nil bundle:nil];
    [subCategoryViewController setSubJsonItems:self.jsonItems[self.jsonItems[@"keys"][indexPath.row]]];
    [subCategoryViewController setPageTitle:self.jsonItems[@"keys"][indexPath.row]];
    [subCategoryViewController setParentPageTitle:self.pageTitle];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:subCategoryViewController];
    
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:[NSString stringWithFormat:@"%@ - %@", self.pageTitle, self.jsonItems[@"keys"][indexPath.row]]];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
