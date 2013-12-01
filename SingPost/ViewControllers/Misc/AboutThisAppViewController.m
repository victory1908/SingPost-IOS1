//
//  AboutThisAppViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "AboutThisAppViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "Article.h"
#import <SVProgressHUD.h>

@interface AboutThisAppViewController ()

@end

@implementation AboutThisAppViewController
{
    UIWebView *aboutThisAppWebView;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"About This App"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    aboutThisAppWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navigationBarView.bounds.size.height, contentView.bounds.size.width, contentView.bounds.size.height - navigationBarView.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [aboutThisAppWebView.scrollView setScrollEnabled:NO];
    [aboutThisAppWebView setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview:aboutThisAppWebView];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [Article API_getAboutThisAppOnCompletion:^(NSString *aboutThisApp) {
        [SVProgressHUD dismiss];
        [aboutThisAppWebView loadHTMLString:aboutThisApp baseURL:nil];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
