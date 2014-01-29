//
//  MoreServicesMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "MoreServicesMainViewController.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import "Article.h"

@implementation MoreServicesMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"More Services"];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    __weak MoreServicesMainViewController *weakSelf = self;
    
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        [Article API_getServicesOnCompletion:^(NSArray *items) {
            [weakSelf setItems:items];
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
