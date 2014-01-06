
//
//  MoreAppsViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 16/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "MoreAppsViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "ArticleTableViewCell.h"
#import "Article.h"
#import <SVProgressHUD.h>

@interface MoreAppsViewController () <UITableViewDataSource, UITableViewDelegate>


@end

@implementation MoreAppsViewController
{
    NavigationBarView *navigationBarView;
    UITableView *moreAppsTableView;
    NSArray *appsItems;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setShowSidebarToggleButton:YES];
    [navigationBarView setTitle:@"More Apps"];
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
    
    moreAppsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 144, contentView.bounds.size.width, contentView.bounds.size.height - 144 - [UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    [moreAppsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [moreAppsTableView setSeparatorColor:[UIColor clearColor]];
    [moreAppsTableView setBackgroundView:nil];
    [moreAppsTableView setDelegate:self];
    [moreAppsTableView setDataSource:self];
    [moreAppsTableView setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:moreAppsTableView];
    
    self.view = contentView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"More Apps"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [Article API_getSingPostAppsOnCompletion:^(NSArray *apps) {
        [SVProgressHUD dismiss];
        appsItems = apps;
        [moreAppsTableView reloadData];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - Accessors

- (void)setPageTitle:(NSString *)pageTitle
{
    [navigationBarView setTitle:pageTitle];
}

#pragma mark - UITableView DataSource & Delegate

- (void)configureCell:(ArticleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.title = appsItems[indexPath.row][@"Name"];
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
    return appsItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const itemCellIdentifier = @"MoreAppsItemTableViewCell";
    
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
    if (!cell)
        cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
    NSLog(@"%@",appsItems);
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *urlSchemeString = appsItems[indexPath.row][@"IOSSCHEME"];
    
    if (![urlSchemeString length] < 0 || urlSchemeString == nil)
        return;
    
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:urlSchemeString]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlSchemeString]];
    
    else {
        NSURL *urlToOpen = nil;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            NSString *appStoreURL = appsItems[indexPath.row][@"IPADURL"];
            if (![appStoreURL length] < 0 || appStoreURL == nil)
                return;
            
            urlToOpen = [NSURL URLWithString:appStoreURL];
        }
        else {
            NSString *appStoreURL = appsItems[indexPath.row][@"IOSURL"];
            if (![appStoreURL length] < 0 || appStoreURL == nil)
                return;
            
            urlToOpen = [NSURL URLWithString:appStoreURL];
        }
        if([[UIApplication sharedApplication]canOpenURL:urlToOpen])
            [[UIApplication sharedApplication] openURL:urlToOpen];
    }
}

@end
