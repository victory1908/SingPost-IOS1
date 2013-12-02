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

@implementation PaymentMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"Pay"];
    [self setIsRootLevel:YES];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    __weak PaymentMainViewController *weakSelf = self;
    [Article API_getPayItemsOnCompletion:^(NSDictionary *items) {
        [weakSelf setJsonData:items];
        if ([items isKindOfClass:[NSDictionary class]])
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
