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
#import "NSDictionary+Additions.h"
#import "Article.h"
#import "UILabel+VerticalAlign.h"

@interface ShopViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIImageView *background;
@end

@implementation ShopViewController

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    self.background = [[UIImageView alloc]initWithFrame:contentView.frame];
    self.background.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:self.background];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Shop"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, navigationBarView.bottom, contentView.width, contentView.height - navigationBarView.height)];
    [contentView addSubview:self.scrollView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, contentView.width - 30, 35)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.titleLabel.bottom + 8, contentView.width - 30, 35)];
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.subTitleLabel];
    
    self.view = contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        [SVProgressHUD showWithStatus:@"Please wait.."];
        [Article API_getShopItemsOnCompletion:^(NSArray *items, NSDictionary *root) {
            self.titleLabel.text = [root objectForKeyOrNil:@"BackgroundText"];
            self.subTitleLabel.text = [root objectForKeyOrNil:@"BackgroundSubText"];
            
            [self relayoutSubviews:root];
            
            NSString *backgroundImage = [root objectForKeyOrNil:@"BackgroundImage"];
            [self.background setImageWithURL:[NSURL URLWithString:backgroundImage]
                 usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)relayoutSubviews:(NSDictionary *)dictionary {
    [self.titleLabel sizeToFitKeepWidth];
    [self.subTitleLabel sizeToFitKeepWidth];
    
    self.subTitleLabel.top = self.titleLabel.bottom + 8;
}

@end
