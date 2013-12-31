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
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    __weak ShopMainViewController *weakSelf = self;
    [Article API_getShopItemsOnCompletion:^(NSArray *items) {
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
