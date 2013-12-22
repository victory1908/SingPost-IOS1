//
//  ArticleContentViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ArticleContentViewController.h"
#import "NavigationBarView.h"
#import "FlatBlueButton.h"
#import "UIView+Position.h"
#import "LocateUsMainViewController.h"

@interface ArticleContentViewController () <UIWebViewDelegate>

@end

@implementation ArticleContentViewController
{
    UIScrollView *contentScrollView;
    UIWebView *contentWebView;
    FlatBlueButton *locateUsButton;
}

//designated initializer
- (id)initWithArticleJSON:(NSDictionary *)inArticleJSON
{
    NSParameterAssert(inArticleJSON);
    if  ((self = [super initWithNibName:nil bundle:nil])) {
        _articleJSON = inArticleJSON;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithArticleJSON:nil];
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitleFontSize:14.0f];
    [navigationBarView setTitle:_articleJSON[@"Name"]];
    [navigationBarView setShowBackButton:YES];
    [contentView addSubview:navigationBarView];
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navigationBarView.bounds.size.height, contentView.bounds.size.width, contentView.bounds.size.height - navigationBarView.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [contentView addSubview:contentScrollView];
    
    contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.bounds.size.width, 10)];
    [contentWebView setDelegate:self];
    [contentWebView.scrollView setScrollEnabled:NO];
    [contentScrollView addSubview:contentWebView];
    
    locateUsButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, -100, contentScrollView.bounds.size.width - 30, 48)];
    [locateUsButton setTitle:@"LOCATE US" forState:UIControlStateNormal];
    [locateUsButton addTarget:self action:@selector(locateUsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollView addSubview:locateUsButton];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([_articleJSON[@"Description"] length] > 0) {
        NSString *htmlContentWithThumbnail = [NSString stringWithFormat:@"<div><img style=\"width:%.0fpx;\" src=\"%@\"></img></div>%@", 300.0f, _articleJSON[@"Thumbnail"], _articleJSON[@"Description"]];
        [contentWebView loadHTMLString:htmlContentWithThumbnail baseURL:nil];
    }
}

#pragma mark - IBActions

- (IBAction)locateUsButtonClicked:(id)sender
{
    LocateUsMainViewController *viewController = [[LocateUsMainViewController alloc] initWithNibName:nil bundle:nil];
    viewController.showNavBarBackButton = YES;
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
}

#pragma mark - UIWebView Delegates

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat pageHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.height"] floatValue];
    [webView setHeight:pageHeight];
    [locateUsButton setY:pageHeight];
    [contentScrollView setContentSize:CGSizeMake(contentScrollView.bounds.size.width, pageHeight + 65.0f)];
}

@end
