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
    [self setIsRootLevel:YES];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    __weak SendReceiveMainViewController *weakSelf = self;
    [Article API_getSendReceiveItemsOnCompletion:^(NSDictionary *items) {
        [weakSelf setJsonData:items];
        [weakSelf setItems:items.allKeys];
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
