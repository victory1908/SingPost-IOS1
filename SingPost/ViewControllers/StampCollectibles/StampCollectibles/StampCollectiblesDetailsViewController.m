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
#import "UIImage+Extensions.h"
#import <QuartzCore/QuartzCore.h>
#import "ColoredPageControl.h"
#import "StampImagesBrowserViewController.h"

@interface StampCollectiblesDetailsViewController () <UIScrollViewDelegate, StampImageBrowserDelegate>

@end

@implementation StampCollectiblesDetailsViewController
{
    UIView *contentView;
    UIImageView *imagesScrollerBackgroundImageView;
    UIScrollView *contentScrollView, *imagesScrollView;
    ColoredPageControl *pageControl;
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
    contentView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:_stamp.title];
    [navigationBarView setTitleFontSize:14.0f];
    [navigationBarView setShowBackButton:YES];
    [contentView addSubview:navigationBarView];
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44)];
    [contentView addSubview:contentScrollView];
    
    CGFloat offsetY = 0;
    
    imagesScrollerBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, offsetY, 320, 185)];
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
    [enlargeButton setFrame:CGRectMake(275, offsetY, 44, 44)];
    [contentScrollView addSubview:enlargeButton];
    
    offsetY += 185.0f;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, contentScrollView.bounds.size.width, 0.5f)];
    [separatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentScrollView addSubview:separatorView];
    
    offsetY += 15.0f;
    
    UILabel *issueDateDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 100, 20)];
    [issueDateDisplayLabel setText:@"Date of issue"];
    [issueDateDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [issueDateDisplayLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [issueDateDisplayLabel setTextColor:RGB(125, 136, 149)];
    [contentScrollView addSubview:issueDateDisplayLabel];
    
    offsetY += 20.0f;
    
    UILabel *issueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 150, 20)];
    [issueDateLabel setBackgroundColor:[UIColor clearColor]];
    [issueDateLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [issueDateLabel setTextColor:RGB(125, 136, 149)];
    [contentScrollView addSubview:issueDateLabel];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    [issueDateLabel setText:[dateFormatter stringFromDate:_stamp.issueDate]];
    
    offsetY += 32.0f;
    
    UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, contentScrollView.bounds.size.width - 30, 30)];
    [detailsLabel setNumberOfLines:0];
    [detailsLabel setTextColor:RGB(51, 51, 51)];
    [detailsLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [detailsLabel setText:_stamp.details];
    [detailsLabel sizeToFit];
    [contentScrollView addSubview:detailsLabel];
    
    offsetY += detailsLabel.bounds.size.height + 15.0f;

    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton.layer setBorderWidth:1.0f];
    [moreButton.layer setBorderColor:RGB(36, 84, 157).CGColor];
    [moreButton setBackgroundImage:nil forState:UIControlStateNormal];
    [moreButton setBackgroundImage:[UIImage imageWithColor:RGB(76, 109, 166)] forState:UIControlStateHighlighted];
    [moreButton setTitle:@"More" forState:UIControlStateNormal];
    [moreButton setTitleColor:RGB(36, 84, 157) forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [moreButton.titleLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setFrame:CGRectMake(15, offsetY, 50, 30)];
    [contentScrollView addSubview:moreButton];
    
    [contentScrollView setContentSize:CGSizeMake(contentScrollView.bounds.size.width, 800)];

    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [pageControl setNumberOfPages:_stamp.images.count];
    [imagesScrollView setContentSize:CGSizeMake(imagesScrollView.bounds.size.width * _stamp.images.count, imagesScrollView.bounds.size.height)];
    
    [_stamp.images enumerateObjectsUsingBlock:^(StampImage *stampImage, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:stampImage.image]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setFrame:CGRectMake(idx * imagesScrollView.bounds.size.width, 0, imagesScrollView.bounds.size.width, imagesScrollView.bounds.size.height)];
        [imagesScrollView addSubview:imageView];
    }];
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
    NSLog(@"more button clicked");
}

- (IBAction)enlargeButtonClicked:(id)sender
{
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
    }];
}

#pragma mark - StampImageBrowserDelegate

- (void)stampImageBrowserDismissed:(StampImagesBrowserViewController *)browserViewController
{
    [imagesScrollView setContentOffset:CGPointMake(imagesScrollView.bounds.size.width * browserViewController.currentIndex, 0)];
    [browserViewController willMoveToParentViewController:nil];
    [UIView animateWithDuration:0.3f animations:^{
        browserViewController.view.alpha = 0.2f;
        browserViewController.view.center = [imagesScrollerBackgroundImageView convertPoint:imagesScrollView.center toView:self.view];
        [browserViewController.view.layer setAffineTransform:CGAffineTransformMakeScale(0.25, 0.25)];
    } completion:^(BOOL finished) {
        [browserViewController.view removeFromSuperview];
        [browserViewController removeFromParentViewController];
    }];
}

@end
