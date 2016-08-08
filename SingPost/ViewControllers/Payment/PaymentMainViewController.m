//
//  PaymentMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "PaymentMainViewController.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import "Article.h"
#import "ArticleCategory.h"


@implementation PaymentMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"Pay"];
    
    __weak PaymentMainViewController *weakSelf = self;
    [weakSelf setItems:[ArticleCategory MR_findByAttribute:@"module" withValue:@"Pay" andOrderBy:@"category" ascending:NO]];
    
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        [SVProgressHUD showWithStatus:@"Please wait.."];
        [Article API_getPayItemsOnCompletion:^(NSArray *items) {
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
