//
//  SendReceiveMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SendReceiveMainViewController.h"
#import "AppDelegate.h"
#import "Article.h"
#import <SVProgressHUD.h>

@implementation SendReceiveMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"Send & Receive"];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    __weak SendReceiveMainViewController *weakSelf = self;
    [Article API_getSendReceiveItemsOnCompletion:^(NSArray *items) {
        [weakSelf setItems:items];
        [SVProgressHUD dismiss];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
