//
//  TermsOfUseViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TermsOfUseViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "Article.h"
#import <SVProgressHUD.h>
#import "FlatBlueButton.h"
#import "LandingPageViewController.h"
#import "UIView+Position.h"

@interface TermsOfUseViewController ()

@end

@implementation TermsOfUseViewController
{
    UIWebView *termsOfUseWebView;
    FlatBlueButton *agreeButton;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Terms Of Use"];
    
    if (!self.isFirstLaunch)
    [navigationBarView setShowSidebarToggleButton:YES];
    
    [contentView addSubview:navigationBarView];
    
    termsOfUseWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navigationBarView.bounds.size.height, contentView.bounds.size.width, contentView.bounds.size.height - navigationBarView.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [termsOfUseWebView setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview:termsOfUseWebView];
    
    if (self.isFirstLaunch) {
        [termsOfUseWebView setHeight:termsOfUseWebView.frame.size.height - 78];
        agreeButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15,termsOfUseWebView.frame.size.height + 59,contentView.bounds.size.width - 30,48)];
        [agreeButton setTitle:@"AGREE" forState:UIControlStateNormal];
        [agreeButton addTarget:self action:@selector(agreeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:agreeButton];
    }
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL warnInternet = YES;
    
    if (self.isFirstLaunch)
    warnInternet = NO;
    
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:warnInternet]) {
        [SVProgressHUD showWithStatus:@"Please wait..."];
        [Article API_getTermsOfUseOnCompletion:^(NSString *termsOfUse) {
            [SVProgressHUD dismiss];
            [termsOfUseWebView loadHTMLString:[NSString stringWithFormat:@"<!DOCTYPE html><html><body style=\"font-family:OpenSans;\">%@</body></html>", termsOfUse] baseURL:nil];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Terms"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (IBAction)agreeButtonClicked:(id)sender {
    LandingPageViewController *landingPageViewController = [[LandingPageViewController alloc] initWithNibName:nil bundle:nil];
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:landingPageViewController];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"TNC_SHOWN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
