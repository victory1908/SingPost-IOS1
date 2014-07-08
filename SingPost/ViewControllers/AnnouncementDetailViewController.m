//
//  AnnouncementDetailViewController.m
//  SingPost
//
//  Created by Wei Guang on 8/7/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "AnnouncementDetailViewController.h"
#import "NavigationBarView.h"
#import "NSDictionary+Additions.h"
#import "UIView+Position.h"
#import "UIFont+SingPost.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface AnnouncementDetailViewController ()
<
UIWebViewDelegate
>
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation AnnouncementDetailViewController

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:[self.info objectForKeyOrNil:@"Name"]];
    [navigationBarView setTitleFontSize:14.0f];
    [navigationBarView setShowBackButton:YES];
    [contentView addSubview:navigationBarView];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, navigationBarView.bottom, contentView.width, contentView.height - navigationBarView.height - 20)];
    [contentView addSubview:self.scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, 185)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImageWithURL:[NSURL URLWithString:[self.info objectForKeyOrNil:@"Thumbnail"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.scrollView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, imageView.bottom, imageView.width - 15, 20)];
    label.text = [self.info objectForKeyOrNil:@"Date"];
    label.font = [UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans];
    label.textColor = RGB(125, 136, 149);
    [self.scrollView addSubview:label];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, label.bottom, imageView.width, contentView.height - imageView.height - label.height)];
    webView.delegate = self;
    [webView loadHTMLString:[self.info objectForKeyOrNil:@"Description"] baseURL:nil];
    [self.scrollView addSubview:webView];
    
    self.view = contentView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView setHeight:[[webView stringByEvaluatingJavaScriptFromString: @"document.height"] floatValue]];
    [self.scrollView autoAdjustScrollViewContentSize];
}

@end
