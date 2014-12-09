//
//  StampImagesBrowserViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 14/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "StampImagesBrowserViewController.h"
#import "ColoredPageControl.h"
#import "StampImage.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface StampImagesBrowserViewController () <UIScrollViewDelegate>

@end

@implementation StampImagesBrowserViewController
{
    UIScrollView *imagesScrollView;
    UIButton *closeButton;
    ColoredPageControl *pageControl;
    
    BOOL isZooming;
}
@synthesize title;

//designated initializer
- (id)initWithStampImages:(NSArray *)inStampImages
{
    NSParameterAssert(inStampImages);
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _stampImages = inStampImages;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStampImages:nil];
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:contentView.bounds];
    [backgroundImageView setImage:[UIImage imageNamed:@"stamp_browser_bg"]];
    [contentView addSubview:backgroundImageView];
    
    imagesScrollView = [[UIScrollView alloc] initWithFrame:contentView.bounds];
    [imagesScrollView setBackgroundColor:[UIColor clearColor]];
    imagesScrollView.maximumZoomScale = 2.0f;
    imagesScrollView.minimumZoomScale = 1.0f;
    imagesScrollView.bouncesZoom = YES;
    imagesScrollView.delegate = self;
    imagesScrollView.showsVerticalScrollIndicator = NO;
    imagesScrollView.showsHorizontalScrollIndicator = NO;
    imagesScrollView.pagingEnabled = YES;
    [contentView addSubview:imagesScrollView];
    
    pageControl = [[ColoredPageControl alloc] initWithFrame:CGRectMake(0, contentView.bounds.size.height - 50, contentView.bounds.size.width, 20)];
    [pageControl setDotColorCurrentPage:RGB(102, 102, 102)];
    [pageControl setDotColorOtherPage:RGB(204, 204, 204)];
    [pageControl setCurrentPage:0];
    [contentView addSubview:pageControl];
    [pageControl setNeedsDisplay];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(contentView.width - 60, 20, 38, 38)];
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeButton];
    
    UITapGestureRecognizer *imageScrollViewDoubleTappedRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageScrollViewDoubleTapped:)];
    [imageScrollViewDoubleTappedRecognizer setNumberOfTapsRequired:2];
    [imagesScrollView addGestureRecognizer:imageScrollViewDoubleTappedRecognizer];

    self.view = contentView;
}

#define TAG_IMAGE_OFFSET 100

- (void)populateImagesScrollView
{
    for (UIView *childView in imagesScrollView.subviews) {
        if ([childView isKindOfClass:[UIImageView class]])
            [childView removeFromSuperview];
    }
    
    imagesScrollView.contentSize = CGSizeMake(imagesScrollView.bounds.size.width * _stampImages.count, imagesScrollView.bounds.size.height);
    imagesScrollView.contentOffset = CGPointMake(imagesScrollView.bounds.size.width * _currentIndex, 0);
    
    [_stampImages enumerateObjectsUsingBlock:^(StampImage *stampImage, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx * imagesScrollView.bounds.size.width, 0, imagesScrollView.bounds.size.width, imagesScrollView.bounds.size.height)];
        [imageView setImageWithURL:[NSURL URLWithString:stampImage.image] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setTag:TAG_IMAGE_OFFSET + idx];
        [imagesScrollView addSubview:imageView];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [pageControl setNumberOfPages:_stampImages.count];
    [pageControl setCurrentPage:_currentIndex];
    
    [self populateImagesScrollView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:[NSString stringWithFormat:@"Stamp Collectibles - %@ - Gallery", self.title]];
}


#pragma mark - IBActions

- (IBAction)closeButtonClicked:(id)sender
{
    [self.delegate stampImageBrowserDismissed:self];
}

#pragma mark - Zooming functions

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;

    zoomRect.size.height = imagesScrollView.frame.size.height / scale;
    zoomRect.size.width  = imagesScrollView.frame.size.width  / scale;
    zoomRect.origin.x  = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y  = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (IBAction)handleImageScrollViewDoubleTapped:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapLocation = [tapGesture locationInView:self.view];
    CGRect zoomRect;
    
    if (imagesScrollView.zoomScale > 1.0f)
        zoomRect = [self zoomRectForScale:1.0f withCenter:tapLocation];
    else
        zoomRect = [self zoomRectForScale:2.0f withCenter:tapLocation];
    
    [imagesScrollView zoomToRect:zoomRect animated:YES];
}

- (UIImageView *)currentDisplayedImageView
{
    return (UIImageView *)[imagesScrollView viewWithTag:TAG_IMAGE_OFFSET + _currentIndex];
}

- (void)startZoomForView:(UIView *)viewToZoom {
    if (viewToZoom && !isZooming) {
        isZooming = YES;
        [closeButton setHidden:YES];
        [pageControl setHidden:YES];
        for (UIView *childView in imagesScrollView.subviews) {
            if ([childView isKindOfClass:[UIImageView class]] && childView != viewToZoom)
                [childView removeFromSuperview];
        }
        viewToZoom.frame = CGRectMake(0, 0, imagesScrollView.bounds.size.width, imagesScrollView.bounds.size.height);
        [imagesScrollView setContentOffset:CGPointZero];
        imagesScrollView.contentSize = imagesScrollView.bounds.size;
        imagesScrollView.pagingEnabled = NO;
    }
}

- (void)stopZoom {
    
    if (isZooming) {
        isZooming = NO;
        [closeButton setHidden:NO];
        [pageControl setHidden:NO];
        [self populateImagesScrollView];
        imagesScrollView.pagingEnabled = YES;
    }
}


#pragma mark - UIScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == imagesScrollView && !isZooming) {
        [pageControl setCurrentPage:floorf((imagesScrollView.contentOffset.x + 100) / imagesScrollView.bounds.size.width)];
        _currentIndex = pageControl.currentPage;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
	return [self currentDisplayedImageView];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    [self startZoomForView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
	if (1.0f == scale)
		[self stopZoom];
}

@end
