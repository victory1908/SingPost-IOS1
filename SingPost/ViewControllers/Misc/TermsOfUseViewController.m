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
#import "UIAlertView+Blocks.h"
#import "Content.h"

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
    [navigationBarView setTitle:@"Terms of Use"];
    
    if (!self.isFirstLaunch)
        [navigationBarView setShowSidebarToggleButton:YES];
    
    [contentView addSubview:navigationBarView];
    
    termsOfUseWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navigationBarView.bounds.size.height, contentView.bounds.size.width, contentView.bounds.size.height - navigationBarView.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [termsOfUseWebView setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview:termsOfUseWebView];
    
    if (self.isFirstLaunch) {
        [termsOfUseWebView setHeight:termsOfUseWebView.frame.size.height - 78];
        agreeButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15,termsOfUseWebView.frame.size.height + 59,contentView.bounds.size.width - 30,48)];
        [agreeButton setTitle:@"Agree" forState:UIControlStateNormal];
        [agreeButton addTarget:self action:@selector(agreeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:agreeButton];
    }
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    Content *content = [Content MR_findFirstByAttribute:@"name" withValue:@"Terms of Use"];
    [termsOfUseWebView loadHTMLString:[NSString stringWithFormat:@"<!DOCTYPE html><html><body style=\"font-family:OpenSans;\">%@</body></html>", content.content] baseURL:nil];
    
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:NO]) {
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//        [SVProgressHUD setForegroundColor:[UIColor blueColor]];
        
        [SVProgressHUD showWithStatus:@"Please wait..."];
        [Content API_SingPostContentOnCompletion:^(BOOL success) {
            if (success){
                [SVProgressHUD dismiss];
                Content *content = [Content MR_findFirstByAttribute:@"name" withValue:@"Terms of Use"];
                [termsOfUseWebView loadHTMLString:[NSString stringWithFormat:@"<!DOCTYPE html><html><body style=\"font-family:OpenSans;\">%@</body></html>", content.content] baseURL:nil];
            }else{
                [SVProgressHUD showErrorWithStatus:@"Error Synchronise with server"];
            }
        }];        agreeButton.enabled = YES;
    }
    else {
//        [UIAlertView showWithTitle:nil
//                           message:@"Your device does not seem to have internet access.\nKindly restart the app when you device has internet access."
//                 cancelButtonTitle:@"OK"
//                 otherButtonTitles:nil
//                          tapBlock:nil];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Your device does not seem to have internet access.\nKindly restart the app when you device has internet access." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        agreeButton.enabled = NO;
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
