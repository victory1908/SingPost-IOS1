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
#import "UIAlertView+Blocks.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface AnnouncementDetailViewController ()
<
UIWebViewDelegate
>
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation AnnouncementDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:[NSString stringWithFormat:@"Announcement-%@",
                                                                         [self.info objectForKeyOrNil:@"Name"]]];
}

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
    [imageView setImageWithURL:[NSURL URLWithString:[self.info objectForKeyOrNil:@"CoverImage"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.scrollView addSubview:imageView];
    
    NSString *issueDateString = [self.info objectForKeyOrNil:@"Date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *issueDate = [dateFormatter dateFromString:issueDateString];
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc]init];
    newDateFormatter.dateFormat = @"dd MMMM yyyy";
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, imageView.bottom + 15, imageView.width - 30, 20)];
    label.text = [newDateFormatter stringFromDate:issueDate];
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
//    [webView setHeight:[[webView stringByEvaluatingJavaScriptFromString: @"document.height"] floatValue]];
    
    CGFloat pageHeight = webView.scrollView.contentSize.height;
    
    NSLog(@"page height %f",pageHeight) ;
    
    [webView setHeight:pageHeight];
    
    [self.scrollView autoAdjustScrollViewContentSize];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlScheme = request.URL.scheme;
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([urlScheme hasPrefix:@"http"]) {

            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Open link in Safari?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
