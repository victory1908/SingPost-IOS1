//
//  ShopMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ShopMainViewController.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import "Article.h"

@interface ShopMainViewController ()

@end

@implementation ShopMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"Shop"];
    [self setIsRootLevel:YES];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    __weak ShopMainViewController *weakSelf = self;
    [Article API_getShopItemsOnCompletion:^(NSDictionary *items) {
        [weakSelf setJsonItems:items];
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
