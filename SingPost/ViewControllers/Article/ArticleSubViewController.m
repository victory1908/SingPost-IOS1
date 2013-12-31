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

@interface ArticleSubViewController ()

@end

@implementation ArticleSubViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setPageTitle:_articleCategory.category];
    [navigationBarView setShowSidebarToggleButton:NO];
    [navigationBarView setShowBackButton:YES];
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
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:[NSString stringWithFormat:@"%@ - %@ - %@", _articleCategory.module, _articleCategory.category, article.name]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
