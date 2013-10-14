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

@interface StampImagesBrowserViewController () <UIScrollViewDelegate>

@end

@implementation StampImagesBrowserViewController
{
    UIScrollView *imagesScrollView;
    ColoredPageControl *pageControl;
}

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
    
    imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height - 50)];
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
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(270, 20, 38, 38)];
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeButton];

    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [pageControl setNumberOfPages:_stampImages.count];
    [pageControl setCurrentPage:_currentIndex];
    imagesScrollView.contentSize = CGSizeMake(imagesScrollView.bounds.size.width * _stampImages.count, imagesScrollView.bounds.size.height);
    imagesScrollView.contentOffset = CGPointMake(imagesScrollView.bounds.size.width * _currentIndex, 0);
    
    [_stampImages enumerateObjectsUsingBlock:^(StampImage *stampImage, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:stampImage.image]];
        [imageView setContentMode:UIViewContentModeCenter];
        [imageView setFrame:CGRectMake(idx * imagesScrollView.bounds.size.width, 0, imagesScrollView.bounds.size.width, imagesScrollView.bounds.size.height)];
        [imagesScrollView addSubview:imageView];
    }];
}

#pragma mark - IBActions

- (IBAction)closeButtonClicked:(id)sender
{
    [self.delegate stampImageBrowserDismissed:self];
}

#pragma mark - UIScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == imagesScrollView) {
        [pageControl setCurrentPage:floorf((imagesScrollView.contentOffset.x + 100) / imagesScrollView.bounds.size.width)];
        _currentIndex = pageControl.currentPage;
    }
}

@end
