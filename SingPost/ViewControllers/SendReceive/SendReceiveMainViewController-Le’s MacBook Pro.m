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
#import "ArticleCategory.h"
#import "SVProgressHUD.h"
#import "UIAlertController+Showable.h"

@implementation SendReceiveMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"Send & Receive"];
    
    __weak SendReceiveMainViewController *weakSelf = self;


//    [weakSelf setItems:[ArticleCategory MR_findByAttribute:@"module" withValue:@"Send and Receive" andOrderBy:@"category" ascending:NO]];

    
    if ([ArticleCategory MR_findAll] !=nil) {
        [weakSelf setItems:[ArticleCategory MR_findByAttribute:@"module" withValue:@"Send and Receive" andOrderBy:@"category" ascending:NO]];
    }
    

    
    
    if ([UIAlertController hasInternetConnectionWarnIfNoConnection:[AppDelegate sharedAppDelegate].rootViewController shouldWarn:YES]) {
        [SVProgressHUD showWithStatus:@"Please wait.."];
        [Article API_getSendReceiveItemsOnCompletion:^(NSArray *items) {
            
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
