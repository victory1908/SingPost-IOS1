//
//  StampCollectiblesDetailsViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 14/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "StampCollectiblesDetailsViewController.h"
#import "NavigationBarView.h"
#import "Stamp.h"
#import "StampImage.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"
#import "UIImage+Extensions.h"
#import <QuartzCore/QuartzCore.h>
#import <SVProgressHUD.h>
#import "ColoredPageControl.h"
#import "FlatBlueButton.h"
#import "AppDelegate.h"
#import "LocateUsMainViewController.h"
#import "StampImagesBrowserViewController.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "StampCollectibleDetailExpandableView.h"
#import "UIAlertView+Blocks.h"

@interface StampCollectiblesDetailsViewController () <UIScrollViewDelegate, StampImageBrowserDelegate ,UIWebViewDelegate>

@property CGFloat pageHeight;
@property BOOL isExpanded;

@end

@implementation StampCollectiblesDetailsViewController
{
    UIView *contentView;
    UIImageView *imagesScrollerBackgroundImageView;
    UIScrollView *contentScrollView, *imagesScrollView;
    ColoredPageControl *pageControl;
    UIButton *moreButton;
    UIWebView *contentWebView,*pricingWebView;
    FlatBlueButton *locateUsButton;
    
    BOOL isAnimating;
}

//designated initializer
- (id)initWithStamp:(Stamp *)inStamp
{
    NSParameterAssert(inStamp);
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _stamp = inStamp;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStamp:nil];
}

- (void)loadView
{
    contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:_stamp.title];
    [navigationBarView setTitleFontSize:14.0f];
    [navigationBarView setShowBackButton:YES];
    [contentView addSubview:navigationBarView];
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [contentView addSubview:contentScrollView];
    
    CGFloat offsetY = 0;
    
    imagesScrollerBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, offsetY, contentView.bounds.size.width, 185)];
    [imagesScrollerBackgroundImageView setImage:[UIImage imageNamed:@"image_scrolller_background"]];
    [contentScrollView addSubview:imagesScrollerBackgroundImageView];
    
    imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, imagesScrollerBackgroundImageView.bounds.size.width, imagesScrollerBackgroundImageView.bounds.size.height - 30)];
    [imagesScrollView setDelegate:self];
    [imagesScrollView setBackgroundColor:[UIColor clearColor]];
    [imagesScrollView setShowsHorizontalScrollIndicator:NO];
    [imagesScrollView setPagingEnabled:YES];
    [contentScrollView addSubview:imagesScrollView];
    
    pageControl = [[ColoredPageControl alloc] initWithFrame:CGRectMake(0, 165, contentView.bounds.size.width, 20)];
    [pageControl setDotColorCurrentPage:RGB(102, 102, 102)];
    [pageControl setDotColorOtherPage:RGB(204, 204, 204)];
    [pageControl setCurrentPage:0];
    [contentScrollView addSubview:pageControl];
    [pageControl setNeedsDisplay];
    
    UIButton *enlargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [enlargeButton setImage:[UIImage imageNamed:@"button_enlarge"] forState:UIControlStateNormal];
    [enlargeButton addTarget:self action:@selector(enlargeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [enlargeButton setFrame:CGRectMake(contentView.bounds.size.width - 44, offsetY, 44, 44)];
    [contentScrollView addSubview:enlargeButton];
    
    offsetY += 185.0f;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, contentScrollView.bounds.size.width, 0.5f)];
    [separatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentScrollView addSubview:separatorView];
    
    offsetY += 15.0f;
    
    UILabel *issueDateDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, offsetY, 100, 20)];
    [issueDateDisplayLabel setText:@"Date of issue"];
    [issueDateDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [issueDateDisplayLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [issueDateDisplayLabel setTextColor:RGB(125, 136, 149)];
    [contentScrollView addSubview:issueDateDisplayLabel];
    
    offsetY += 20.0f;
    
    UILabel *issueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, offsetY, 150, 20)];
    [issueDateLabel setBackgroundColor:[UIColor clearColor]];
    [issueDateLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [issueDateLabel setTextColor:RGB(125, 136, 149)];
    [issueDateLabel setText:[NSString stringWithFormat:@"%@ %@ %@", _stamp.day, _stamp.month, _stamp.year]];
    [contentScrollView addSubview:issueDateLabel];
    offsetY += 32.0f;
    
    contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, offsetY, contentScrollView.bounds.size.width, 90)];
    [contentWebView setBackgroundColor:[UIColor clearColor]];
    [contentWebView setOpaque:NO];
    [contentWebView loadHTMLString:_stamp.details baseURL:nil];
    [contentWebView setDelegate:self];
    [contentWebView.scrollView setScrollEnabled:NO];
    [contentScrollView addSubview:contentWebView];
    
    if (!INTERFACE_IS_IPAD) {
        moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreButton.layer setBorderWidth:1.0f];
        [moreButton.layer setBorderColor:RGB(36, 84, 157).CGColor];
        [moreButton setBackgroundImage:nil forState:UIControlStateNormal];
        [moreButton setBackgroundImage:[UIImage imageWithColor:RGB(76, 109, 166)] forState:UIControlStateHighlighted];
        [moreButton setTitle:@"More" forState:UIControlStateNormal];
        [moreButton setTitleColor:RGB(36, 84, 157) forState:UIControlStateNormal];
        [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [moreButton.titleLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [moreButton setFrame:CGRectMake(8, contentWebView.bottom + 15, 50, 30)];
        [contentScrollView addSubview:moreButton];
    }
    
    pricingWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, moreButton.bottom + 15, contentScrollView.bounds.size.width, 125)];
    [pricingWebView setBackgroundColor:[UIColor clearColor]];
    [pricingWebView setOpaque:NO];
    [pricingWebView loadHTMLString:_stamp.price baseURL:nil];
    [pricingWebView setDelegate:self];
    [pricingWebView.scrollView setScrollEnabled:NO];
    [contentScrollView addSubview:pricingWebView];
    
    locateUsButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, pricingWebView.bottom + 15, contentView.bounds.size.width - 30, 48)];
    [locateUsButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [locateUsButton addTarget:self action:@selector(locateUsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [locateUsButton setTitle:@"FIND OUR LOCATIONS NEAR YOU" forState:UIControlStateNormal];
    [contentScrollView addSubview:locateUsButton];
    
    [contentScrollView autoAdjustScrollViewContentSizeBottomInset:15];
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [Stamp API_getImagesOfStamps:_stamp onCompletion:^(BOOL success, NSError *error) {
        [SVProgressHUD dismiss];
        [pageControl setNumberOfPages:_stamp.images.count];
        [imagesScrollView setContentSize:CGSizeMake(imagesScrollView.bounds.size.width * _stamp.images.count, imagesScrollView.bounds.size.height)];
        [_stamp.images enumerateObjectsUsingBlock:^(StampImage *stampImage, NSUInteger idx, BOOL *stop) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx * imagesScrollView.bounds.size.width, 0, imagesScrollView.bounds.size.width, imagesScrollView.bounds.size.height)];
            [imageView setImageWithURL:[NSURL URLWithString:stampImage.image] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imagesScrollView addSubview:imageView];
        }];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - UIScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == imagesScrollView) {
        [pageControl setCurrentPage:floorf((imagesScrollView.contentOffset.x + 100) / imagesScrollView.bounds.size.width)];
    }
}

#pragma mark - IBActions

- (IBAction)moreButtonClicked:(id)sender
{
    if (!self.isExpanded) {
        [UIView animateWithDuration:0.2 animations:^{
            contentWebView.height = self.pageHeight + 15;
            moreButton.top = contentWebView.bottom;
            pricingWebView.top = moreButton.bottom + 15;
            locateUsButton.top = pricingWebView.bottom + 15;
            [contentScrollView autoAdjustScrollViewContentSizeBottomInset:15];
            
        } completion:^(BOOL finished) {
            [moreButton setTitle:@"Less" forState:UIControlStateNormal];
            self.isExpanded = YES;
        }];
    }
    else {
        [UIView animateWithDuration:0.2 animations:^{
            contentWebView.height = 90;
            moreButton.top = contentWebView.bottom + 15;
            pricingWebView.top = moreButton.bottom + 15;
            locateUsButton.top = pricingWebView.bottom + 15;
            [contentScrollView autoAdjustScrollViewContentSizeBottomInset:15];
            
        } completion:^(BOOL finished) {
            [moreButton setTitle:@"More" forState:UIControlStateNormal];
            self.isExpanded = NO;
        }];
    }
}

- (IBAction)enlargeButtonClicked:(id)sender
{
    if (isAnimating)
        return;
    
    isAnimating = YES;
    
    StampImagesBrowserViewController *imageBrowserViewController = [[StampImagesBrowserViewController alloc] initWithStampImages:[_stamp.images array]];
    imageBrowserViewController.currentIndex = pageControl.currentPage;
    [imageBrowserViewController setDelegate:self];
    imageBrowserViewController.view.center = [imagesScrollerBackgroundImageView convertPoint:imagesScrollView.center toView:self.view];
    [imageBrowserViewController.view.layer setAffineTransform:CGAffineTransformMakeScale(0.25, 0.25)];
    [self addChildViewController:imageBrowserViewController];
    [self.view addSubview:imageBrowserViewController.view];
    
    [UIView animateWithDuration:0.3f animations:^{
        imageBrowserViewController.view.center = self.view.center;
        [imageBrowserViewController.view.layer setAffineTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:^(BOOL finished) {
        [imageBrowserViewController didMoveToParentViewController:self];
        isAnimating = NO;
    }];
}

- (IBAction)locateUsButtonClicked:(id)sender
{
    LocateUsMainViewController *viewController = [[LocateUsMainViewController alloc] initWithNibName:nil bundle:nil];
    viewController.showNavBarBackButton = YES;
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
}

#pragma mark - StampImageBrowserDelegate

- (void)stampImageBrowserDismissed:(StampImagesBrowserViewController *)imageBrowserViewController
{
    if (isAnimating)
        return;
    
    isAnimating = YES;
    
    [imagesScrollView setContentOffset:CGPointMake(imagesScrollView.bounds.size.width * imageBrowserViewController.currentIndex, 0)];
    [imageBrowserViewController willMoveToParentViewController:nil];
    [UIView animateWithDuration:0.3f animations:^{
        imageBrowserViewController.view.alpha = 0.2f;
        imageBrowserViewController.view.center = [imagesScrollerBackgroundImageView convertPoint:imagesScrollView.center toView:self.view];
        [imageBrowserViewController.view.layer setAffineTransform:CGAffineTransformMakeScale(0.25, 0.25)];
    } completion:^(BOOL finished) {
        [imageBrowserViewController.view removeFromSuperview];
        [imageBrowserViewController removeFromParentViewController];
        isAnimating = NO;
    }];
}

#pragma mark - UIWebView Delegates
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView == contentWebView) {
        self.pageHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.height"] floatValue];
        if (self.pageHeight <= 90 || INTERFACE_IS_IPAD) {
            moreButton.hidden = YES;
            contentWebView.height = self.pageHeight + 15;
            pricingWebView.top = contentWebView.bottom + 15;
            locateUsButton.top = pricingWebView.bottom + 15;
        }
    }
    
    else if (webView == pricingWebView) {
        pricingWebView.height = [[webView stringByEvaluatingJavaScriptFromString: @"document.height"] floatValue];
        locateUsButton.top = pricingWebView.bottom + 15;
        [contentScrollView autoAdjustScrollViewContentSizeBottomInset:15];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlScheme = request.URL.scheme;
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([urlScheme hasPrefix:@"http"]) {
            [UIAlertView showWithTitle:nil message:@"Open link in Safari?"
                     cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"OK"]
                              tapBlock:^(UIAlertView *alert, NSInteger buttonIndex) {
                                  if (buttonIndex == 1) {
                                      [[UIApplication sharedApplication]openURL:request.URL];
                                  }
                              }];
        }
        return NO;
    }
    return YES;
}

@end