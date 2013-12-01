//
//  FAQViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 17/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "FAQViewController.h"
#import "NavigationBarView.h"
#import "Article.h"
#import <SVProgressHUD.h>

@interface FAQViewController ()

@end

@implementation FAQViewController
{
    UIWebView *faqWebView;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"FAQs"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    faqWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navigationBarView.bounds.size.height, contentView.bounds.size.width, contentView.bounds.size.height - navigationBarView.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [faqWebView setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview:faqWebView];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [Article API_getFaqOnCompletion:^(NSString *faqs) {
        [SVProgressHUD dismiss];
        [faqWebView loadHTMLString:faqs baseURL:nil];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
