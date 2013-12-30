//
//  ArticleViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ArticleViewController.h"
#import "UIFont+SingPost.h"
#import "AppDelegate.h"
#import "ArticleTableViewCell.h"
#import "ArticleSubViewController.h"
#import "ArticleCategory.h"
#import "Article.h"
#import <SVProgressHUD.h>

@interface ArticleViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ArticleViewController
{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [navigationBarView setShowSidebarToggleButton:YES];
}

#pragma mark - Accessors

- (void)setPageTitle:(NSString *)inPageTitle
{
    _pageTitle = inPageTitle;
    [navigationBarView setTitle:_pageTitle];
}

- (void)setItems:(NSArray *)inItems
{
    _items = inItems;
    [contentsTableView reloadData];
}

#pragma mark - UITableView DataSource & Delegate

- (void)configureCell:(ArticleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ArticleCategory *articleCategory = _items[indexPath.row];
    cell.title = articleCategory.category;
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
    return _items.count;
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
    ArticleCategory *articleCategory = _items[indexPath.row];
    
    ArticleSubViewController *subCategoryViewController = [[ArticleSubViewController alloc] initWithNibName:nil bundle:nil];
    [subCategoryViewController setArticleCategory:articleCategory];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:subCategoryViewController];
    
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:[NSString stringWithFormat:@"%@ - %@", self.pageTitle, articleCategory.category]];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
