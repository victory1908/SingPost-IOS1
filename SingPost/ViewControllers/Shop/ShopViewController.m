//
//  ShopViewController.m
//  SingPost
//
//  Created by Wei Guang on 17/7/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "ShopViewController.h"
#import "NavigationBarView.h"
#import "ApiClient.h"
#import "SVProgressHUD.h"
#import "UIAlertView+Blocks.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface ShopViewController ()
@property (strong, nonatomic) UIImageView *background;
@end

@implementation ShopViewController

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.background = [[UIImageView alloc]initWithFrame:contentView.frame];
    [contentView addSubview:self.background];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Shop"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    self.view = contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [[ApiClient sharedInstance] getShopItemsOnSuccess:^(id responseJSON) {
        if ([responseJSON isKindOfClass:[NSDictionary class]]) {
            
            
        }
        [SVProgressHUD dismiss];
    } onFailure:^(NSError *error) {
        [UIAlertView showWithTitle:NO_INTERNET_ERROR_TITLE
                           message:NO_INTERNET_ERROR
                 cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
        [SVProgressHUD dismiss];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}
@end
