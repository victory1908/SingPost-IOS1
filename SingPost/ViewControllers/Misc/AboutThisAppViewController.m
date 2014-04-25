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
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, navigationBarView.bounds.size.height + 5, navigationBarView.bounds.size.width - 10, 20)];
    versionLabel.font = [UIFont SingPostRegularFontOfSize:15.0f fontKey:kSingPostFontOpenSans];
    versionLabel.text = [NSString stringWithFormat:@"SingPost Mobile App – Ver %@",[NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]];
    [contentView addSubview:versionLabel];
    
    aboutThisAppWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navigationBarView.bounds.size.height + versionLabel.height + 5, contentView.bounds.size.width, contentView.bounds.size.height - navigationBarView.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - versionLabel.height - 5)];
    [aboutThisAppWebView.scrollView setScrollEnabled:NO];
    [aboutThisAppWebView setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview:aboutThisAppWebView];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        [SVProgressHUD showWithStatus:@"Please wait..."];
        [Article API_getAboutThisAppOnCompletion:^(NSString *aboutThisApp) {
            [SVProgressHUD dismiss];
            [aboutThisAppWebView loadHTMLString:[NSString stringWithFormat:@"<!DOCTYPE html><html><body style=\"font-family:OpenSans;\">%@</body></html>", aboutThisApp] baseURL:nil];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"About"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
