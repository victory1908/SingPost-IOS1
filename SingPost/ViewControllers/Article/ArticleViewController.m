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
    UITableView *menusTableView;
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
    
    menusTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 144, contentView.bounds.size.width, contentView.bounds.size.height - 144 - [UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    [menusTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [menusTableView setSeparatorColor:[UIColor clearColor]];
    [menusTableView setBackgroundView:nil];
    [menusTableView setDelegate:self];
    [menusTableView setDataSource:self];
    [menusTableView setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:menusTableView];
    
    self.view = contentView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:self.pageTitle];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
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

- (void)setItems:(NSArray *)inItems
{
    _items = inItems;
    [menusTableView reloadData];
}

#pragma mark - UITableView DataSource & Delegate

- (void)configureCell:(ArticleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //only process if an item cell (not a separator cell!)
    if (indexPath.row % 2 == 0) {
        int dataRow = floorf(indexPath.row / 2.0f);
        cell.title = _items[dataRow];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2 == 0) ? 70.0f : 1.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const itemCellIdentifier = @"ArticleItemTableViewCell";
    static NSString *const separatorCellIdentifier = @"SeparatorTableViewCell";
    
    if ((indexPath.row % 2) == 0) {
        ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
        if (!cell)
            cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:separatorCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:separatorCellIdentifier];
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, 1)];
            [separatorView setBackgroundColor:RGB(196, 197, 200)];
            [cell.contentView addSubview:separatorView];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int dataRow = floorf(indexPath.row / 2.0f);
    ArticleSubCategoryViewController *subCategoryViewController = [[ArticleSubCategoryViewController alloc] initWithNibName:nil bundle:nil];
    [subCategoryViewController setJsonItems:self.jsonData[self.jsonData.allKeys[dataRow]]];
    [subCategoryViewController setPageTitle:self.items[dataRow]];
    [subCategoryViewController setParentPageTitle:self.pageTitle];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:subCategoryViewController];
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ - %@", self.pageTitle, self.items[dataRow]]];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end