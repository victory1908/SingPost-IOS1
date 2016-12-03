//
//  MoreServicesMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "MoreServicesMainViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "Article.h"
#import "ArticleCategory.h"
#import "UIAlertController+Showable.h"

@implementation MoreServicesMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"More Services"];
    
    __weak MoreServicesMainViewController *weakSelf = self;
    [weakSelf setItems:[ArticleCategory MR_findByAttribute:@"module" withValue:@"More Services"]];
    
    if ([UIAlertController hasInternetConnectionWarnIfNoConnection:[AppDelegate sharedAppDelegate].rootViewController shouldWarn:YES]) {
    
        [SVProgressHUD showWithStatus:@"Please wait.."];
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
