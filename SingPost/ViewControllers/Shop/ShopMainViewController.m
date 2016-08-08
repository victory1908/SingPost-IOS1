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
#import "ArticleCategory.h"

@interface ShopMainViewController ()

@end

@implementation ShopMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"Shop"];
    
    __weak ShopMainViewController *weakSelf = self;
    [weakSelf setItems:[ArticleCategory MR_findByAttribute:@"module" withValue:@"Shop"]];
    
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        [SVProgressHUD showWithStatus:@"Please wait.."];
        [Article API_getShopItemsOnCompletion:^(NSArray *items, NSDictionary *responseObject) {
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
