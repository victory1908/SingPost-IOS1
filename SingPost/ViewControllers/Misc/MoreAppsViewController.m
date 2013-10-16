
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

@interface MoreAppsViewController () <UITableViewDataSource, UITableViewDelegate>


@end

@implementation MoreAppsViewController
{
    NavigationBarView *navigationBarView;
    UITableView *moreAppsTableView;
    NSArray *moreAppsDisplayTexts, *moreAppsURLs;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        moreAppsDisplayTexts = @[@"SingPost vBOX", @"Post-a-Card"];
        moreAppsURLs = @[@"https://itunes.apple.com/sg/app/singpost-vbox/id494837008", @"https://itunes.apple.com/sg/app/post-a-card/id530061954?mt=8"];
    }
    
    return self;
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

#pragma mark - Accessors

- (void)setPageTitle:(NSString *)pageTitle
{
    [navigationBarView setTitle:pageTitle];
}

#pragma mark - UITableView DataSource & Delegate

- (void)configureCell:(ArticleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //only process if an item cell (not a separator cell!)
    if (indexPath.row % 2 == 0) {
        int dataRow = floorf(indexPath.row / 2.0f);
        cell.title = moreAppsDisplayTexts[dataRow];
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
    return moreAppsDisplayTexts.count * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const itemCellIdentifier = @"MoreAppsItemTableViewCell";
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:moreAppsURLs[dataRow]]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end