//
//  ShopContentViewController.m
//  SingPost
//
//  Created by Wei Guang on 23/7/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "ShopContentViewController.h"
#import "NavigationBarView.h"
#import "FlatBlueButton.h"
#import "UIView+Position.h"
#import "LocateUsMainViewController.h"
#import "CalculatePostageMainViewController.h"
#import "Article.h"
#import "SVProgressHUD.h"
#import "UIAlertView+Blocks.h"
#import "MaintanancePageViewController.h"
#import "NSDictionary+Additions.h"

@interface ShopContentViewController ()
<
UIWebViewDelegate
>
@end

@implementation ShopContentViewController
{
    UIScrollView *contentScrollView;
    UIWebView *contentWebView;
    FlatBlueButton *locateUsButton;
    FlatBlueButton *calculateButton;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitleFontSize:14.0f];
    [navigationBarView setTitle:[self.item objectForKeyOrNil:@"SubCategoryName"]];
    [navigationBarView setShowBackButton:YES];
    [contentView addSubview:navigationBarView];
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navigationBarView.bounds.size.height, contentView.bounds.size.width, contentView.bounds.size.height - navigationBarView.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [contentView addSubview:contentScrollView];
    
    contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.bounds.size.width, 10)];
    [contentWebView setDelegate:self];
    [contentWebView.scrollView setScrollEnabled:NO];
    [contentScrollView addSubview:contentWebView];
    
    NSString *btnTypeString = [self.item objectForKeyOrNil:@"ButtonType"];
    NSInteger buttonType;
    
    if (btnTypeString == nil)
        buttonType = 2;
    else
        buttonType = [btnTypeString integerValue];
    
    switch (buttonType) {
        case 2: {
            locateUsButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15,-100,contentScrollView.bounds.size.width - 30,48)];
            [locateUsButton setTitle:@"LOCATE US" forState:UIControlStateNormal];
            [locateUsButton addTarget:self action:@selector(locateUsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [contentScrollView addSubview:locateUsButton];
            break;
        }
        case 3: {
            calculateButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15,-100,contentScrollView.bounds.size.width - 30,48)];
            [calculateButton setTitle:@"CALCULATE POSTAGE" forState:UIControlStateNormal];
            [calculateButton addTarget:self action:@selector(calculateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [contentScrollView addSubview:calculateButton];
            break;
        }
        case 4: {
            CGFloat btnWidth = (contentScrollView.width - 40)/2;
            locateUsButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15,-100,btnWidth,48)];
            [locateUsButton setTitle:@"LOCATE US" forState:UIControlStateNormal];
            [locateUsButton addTarget:self action:@selector(locateUsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [contentScrollView addSubview:locateUsButton];
            
            calculateButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(locateUsButton.right + 10,-100,btnWidth,48)];
            [calculateButton setTitle:@"CALCULATE POSTAGE" forState:UIControlStateNormal];
            calculateButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            calculateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [calculateButton addTarget:self action:@selector(calculateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [contentScrollView addSubview:calculateButton];
            break;
        }
        default:
            break;
    }
    
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    if ([maintananceStatuses[@"LocateUs"] isEqualToString:@"on"] && locateUsButton != nil)
        locateUsButton.alpha = 0.5;
    if ([maintananceStatuses[@"CalculatePostage"] isEqualToString:@"on"] && calculateButton != nil)
        calculateButton.alpha = 0.5;
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[self.item objectForKeyOrNil:@"Description"]length] > 0) {
        NSString *htmlContentWithThumbnail = [NSString stringWithFormat:@"<div align=\"center\" ><img style=\"width:%.0fpx;\" src=\"%@\"></img></div>%@", 300.0f, [self.item objectForKeyOrNil:@"Thumbnail"], [self.item objectForKeyOrNil:@"Description"]];
        [contentWebView loadHTMLString:htmlContentWithThumbnail baseURL:nil];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@"Please wait..."];
//        [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
    }
}

#pragma mark - IBActions

- (IBAction)locateUsButtonClicked:(id)sender
{
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    if ([maintananceStatuses[@"LocateUs"] isEqualToString:@"on"]) {
        MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Locate Us" andMessage:maintananceStatuses[@"Comment"]];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else {
        LocateUsMainViewController *viewController = [[LocateUsMainViewController alloc] initWithNibName:nil bundle:nil];
        viewController.showNavBarBackButton = YES;
        [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
    }
}

- (IBAction)calculateButtonClicked:(id)sender
{
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    if ([maintananceStatuses[@"CalculatePostage"] isEqualToString:@"on"]) {
        MaintanancePageViewController *viewController = [[MaintanancePageViewController alloc] initWithModuleName:@"Locate Us" andMessage:maintananceStatuses[@"Comment"]];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else {
        CalculatePostageMainViewController *viewController = [[CalculatePostageMainViewController alloc] initWithNibName:nil bundle:nil];
        viewController.showNavBarBackButton = YES;
        [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
    }
}

#pragma mark - UIWebView Delegates

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat pageHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.height"] floatValue];
    [webView setHeight:pageHeight];
    
    if (locateUsButton != nil)
        [locateUsButton setY:pageHeight];
    
    if (calculateButton != nil)
        [calculateButton setY:pageHeight];
    
    [contentScrollView setContentSize:CGSizeMake(contentScrollView.bounds.size.width, pageHeight + 65.0f)];
    
    [SVProgressHUD dismiss];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlScheme = request.URL.scheme;
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([urlScheme hasPrefix:@"http"]) {
//            [UIAlertView showWithTitle:nil message:@"Open link in Safari?"
//                     cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"OK"]
//                              tapBlock:^(UIAlertView *alert, NSInteger buttonIndex) {
//                                  if (buttonIndex == 1) {
//                                      NSString *category = [NSString stringWithFormat:@"Shop - %@",[self.item objectForKeyOrNil:@"Name"]];
//                                      NSMutableDictionary *params = [[GAIDictionaryBuilder createEventWithCategory:category
//                                                                                                            action:@"Link clicked"
//                                                                                                             label:request.URL.absoluteString
//                                                                                                             value:nil] build];
//                                      [[[GAI sharedInstance] defaultTracker]send:params];
//                                      [[UIApplication sharedApplication]openURL:request.URL];
//                                  }
//                              }];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Open link in Safari?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *category = [NSString stringWithFormat:@"Shop - %@",[self.item objectForKeyOrNil:@"Name"]];
                NSMutableDictionary *params = [[GAIDictionaryBuilder createEventWithCategory:category
                                                                                      action:@"Link clicked"
                                                                                       label:request.URL.absoluteString
                                                                                       value:nil] build];
                [[[GAI sharedInstance] defaultTracker]send:params];
                [[UIApplication sharedApplication]openURL:request.URL];
                }];
            [alert addAction:cancel];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        return NO;
    }
    return YES;
}

@end
