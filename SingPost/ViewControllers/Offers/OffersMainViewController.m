//
//  OffersMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 30/12/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "OffersMainViewController.h"
#import <SVProgressHUD.h>
#import "Article.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"
#import "DatabaseSeeder.h"
#import "OffersTableViewCell.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "ArticleContentViewController.h"

@interface OffersMainViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation OffersMainViewController
{
    UITableView *offersTableView;
    NSArray *itemsArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [Article API_getOffersOnCompletion:^(NSArray *items) {
        itemsArray = items;
        [SVProgressHUD dismiss];
        [offersTableView reloadData];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(240, 240, 240)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Offers"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    offersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    [offersTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [offersTableView setSeparatorColor:[UIColor clearColor]];
    [offersTableView setBackgroundView:nil];
    [offersTableView setDelegate:self];
    [offersTableView setDataSource:self];
    [offersTableView setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:offersTableView];
    
    self.view = contentView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const itemCellIdentifier = @"OffersTableViewCell";
    
    OffersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
    if (!cell) {
        cell = [[OffersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
    }
    
    cell.article = [itemsArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [itemsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = [itemsArray objectAtIndex:indexPath.row];
    ArticleContentViewController *viewController = [[ArticleContentViewController alloc] initWithNibName:nil bundle:nil];
    [viewController setArticle:article];
    
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
    
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:[NSString stringWithFormat:@"%@ - %@", @"Offers", article.name]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
