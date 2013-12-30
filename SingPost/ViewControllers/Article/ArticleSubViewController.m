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
    _articleItems = [_articleCategory.articles array];
}

#pragma mark - UITableView DataSource & Delegate

- (void)configureCell:(ArticleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Article *article = _articleItems[indexPath.row];
    cell.title = article.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _articleItems.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = _articleItems[indexPath.row];
    ArticleContentViewController *viewController = [[ArticleContentViewController alloc] initWithNibName:nil bundle:nil];
    [viewController setArticle:_articleItems[indexPath.row]];

    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:[NSString stringWithFormat:@"%@ - %@ - %@", _articleCategory.module, _articleCategory.category, article.name]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
