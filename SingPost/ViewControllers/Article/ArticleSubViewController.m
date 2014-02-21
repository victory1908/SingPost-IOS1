//
//  ArticleSubViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 2/12/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ArticleSubViewController.h"
#import "AppDelegate.h"
#import "ArticleContentViewController.h"
#import "ArticleCategory.h"
#import "Article.h"
#import "ArticleTableViewCell.h"
#import "UIFont+SingPost.h"

@interface ArticleSubViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *contentsTableView;
}

@end

@implementation ArticleSubViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setPageTitle:_articleCategory.category];
    [navigationBarView setShowSidebarToggleButton:NO];
    [navigationBarView setShowBackButton:YES];
}

- (void)setPageTitle:(NSString *)inPageTitle
{
    _pageTitle = inPageTitle;
    [navigationBarView setTitle:_pageTitle];
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:_pageTitle];
    [contentView addSubview:navigationBarView];
    
    contentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarView.bottom, contentView.bounds.size.width, contentView.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    [contentsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [contentsTableView setSeparatorColor:[UIColor clearColor]];
    [contentsTableView setBackgroundView:nil];
    [contentsTableView setDelegate:self];
    [contentsTableView setDataSource:self];
    [contentsTableView setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:contentsTableView];
    
    self.view = contentView;
}

- (void)setArticleCategory:(ArticleCategory *)inArticleCategory
{
    _articleCategory = inArticleCategory;
    self.items = [_articleCategory.articles array];
}

- (void)setShowAsRootViewController:(BOOL)showAsRootViewController
{
    [navigationBarView setShowSidebarToggleButton:showAsRootViewController];
    [navigationBarView setShowBackButton:!showAsRootViewController];
}

#pragma mark - UITableView DataSource & Delegate
- (void)configureCell:(ArticleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Article *article = self.items[indexPath.row];
    cell.title = article.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = self.items[indexPath.row];
    ArticleContentViewController *viewController = [[ArticleContentViewController alloc] initWithNibName:nil bundle:nil];
    [viewController setArticle:article];
    
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
    if (_articleCategory) {
        [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:[NSString stringWithFormat:@"%@ - %@ - %@", _articleCategory.module, _articleCategory.category, article.name]];
    }
    else {
        [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:[NSString stringWithFormat:@"%@ - %@", self.pageTitle, article.name]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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

@end
