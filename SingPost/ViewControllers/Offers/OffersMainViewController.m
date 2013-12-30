//
//  OffersMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 30/12/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "OffersMainViewController.h"
#import <SVProgressHUD.h>
#import "Article.h"

@interface OffersMainViewController ()

@end

@implementation OffersMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"Offers"];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    __weak OffersMainViewController *weakSelf = self;
    [Article API_getOffersOnCompletion:^(NSArray *items) {
        [weakSelf setItems:items];
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
