//
//  SendReceiveMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SendReceiveMainViewController.h"
#import "AppDelegate.h"
#import "SendReceiveSubLevelViewController.h"
#import "ApiClient.h"
#import <SVProgressHUD.h>
#import "Article.h"

@implementation SendReceiveMainViewController
{
    NSArray *data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"Send & Receive"];
    [self setIsRootLevel:YES];
    
    data = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SendReceive" ofType:@"plist"]];
    [self setItems:[data valueForKey:@"category"]];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    
    __weak SendReceiveMainViewController *weakSelf = self;
    [Article API_getSendReceiveItemsOnCompletion:^(NSArray *items) {
        [weakSelf setJsonItems:items];
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int dataRow = floorf(indexPath.row / 2.0f);
    SendReceiveSubLevelViewController *subLevelViewController = [[SendReceiveSubLevelViewController alloc] initWithNibName:nil bundle:nil];
    [subLevelViewController setItems:data[dataRow][@"items"]];
    [subLevelViewController setJsonItems:self.jsonItems];
    [subLevelViewController setPageTitle:self.items[dataRow]];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:subLevelViewController];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
