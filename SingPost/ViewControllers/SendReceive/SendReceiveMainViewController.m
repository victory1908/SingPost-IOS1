//
//  SendReceiveMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SendReceiveMainViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "AppDelegate.h"
#import "SendReceiveMainTableViewCell.h"
#import "AMMailViewController.h"

@interface SendReceiveMainViewController () <UITableViewDataSource, UITableViewDelegate>

@end

typedef enum  {
    SENDRECEIVE_MENU_AMMAIL,
    SENDRECEIVE_MENU_LOCALORDINARYMAIL,
    SENDRECEIVE_MENU_LOCALREGISTEREDARTICLES,
    
    SENDRECEIVE_MENU_TOTAL
} tSendReceiveMenus;

@implementation SendReceiveMainViewController
{
    UITableView *menusTableView;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Send & Receive"];
    [navigationBarView setShowSidebarToggleButton:YES];
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

#pragma mark - UITableView DataSource & Delegate

- (void)configureCell:(SendReceiveMainTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    int dataRow = floorf(indexPath.row / 2.0f);
    switch ((tSendReceiveMenus)dataRow) {
        case SENDRECEIVE_MENU_AMMAIL:
        {
            cell.title = @"AM Mail";
            break;
        }
        case SENDRECEIVE_MENU_LOCALORDINARYMAIL:
        {
            cell.title = @"Local Ordinary Mail";
            break;
        }
        case SENDRECEIVE_MENU_LOCALREGISTEREDARTICLES:
        {
            cell.title = @"Local Registered Articles";
            break;
        }
        default:
        {
            NSAssert(NO, @"unsupported tSendReceiveMenus");
            break;
        }
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
    return SENDRECEIVE_MENU_TOTAL * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const itemCellIdentifier = @"SendReceiveMainTableViewCell";
    static NSString *const separatorCellIdentifier = @"SeparatorTableViewCell";
    
    if ((indexPath.row % 2) == 0) {
        SendReceiveMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
        if (!cell)
            cell = [[SendReceiveMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
        
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
    switch ((tSendReceiveMenus)dataRow) {
        case SENDRECEIVE_MENU_AMMAIL:
        {
            AMMailViewController *viewController = [[AMMailViewController alloc] initWithNibName:nil bundle:nil];
            [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
            break;
        }
        case SENDRECEIVE_MENU_LOCALORDINARYMAIL:
        {
//            cell.title = @"Local Ordinary Mail";
            break;
        }
        case SENDRECEIVE_MENU_LOCALREGISTEREDARTICLES:
        {
//            cell.title = @"Local Registered Articles";
            break;
        }
        default:
        {
            NSAssert(NO, @"unsupported tSendReceiveMenus");
            break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
