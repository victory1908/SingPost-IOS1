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
#import "Content.h"

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"FAQs"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Content *content = [Content MR_findFirstByAttribute:@"name" withValue:@"FAQ"];
    [faqWebView loadHTMLString:[NSString stringWithFormat:@"<!DOCTYPE html><html><body style=\"font-family:OpenSans;\">%@</body></html>", content.content] baseURL:nil];
    
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        [SVProgressHUD showWithStatus:@"Please wait..."];
//        [Article API_getFaqOnCompletion:^(NSString *faqs) {
//            [SVProgressHUD dismiss];
//            [faqWebView loadHTMLString:[NSString stringWithFormat:@"<!DOCTYPE html><html><body style=\"font-family:OpenSans;\">%@</body></html>", faqs] baseURL:nil];
//        }];
        [Content API_SingPostContentOnCompletion:^(BOOL success) {
            if (success){
                [SVProgressHUD dismiss];
                Content *content = [Content MR_findFirstByAttribute:@"name" withValue:@"FAQ"];
                [faqWebView loadHTMLString:[NSString stringWithFormat:@"<!DOCTYPE html><html><body style=\"font-family:OpenSans;\">%@</body></html>", content.content] baseURL:nil];
            }else{
                [SVProgressHUD showErrorWithStatus:@"Error Synchronise with server"];
            }
        }];
        
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
