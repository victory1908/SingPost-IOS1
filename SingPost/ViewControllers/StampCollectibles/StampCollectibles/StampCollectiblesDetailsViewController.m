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

@interface StampCollectiblesDetailsViewController () <UIScrollViewDelegate>

@end

@implementation StampCollectiblesDetailsViewController
{
    UIView *contentView;
    UIScrollView *contentScrollView, *imagesScrollView;
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
    contentScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentScrollView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:_stamp.title];
    [navigationBarView setTitleFontSize:14.0f];
    [navigationBarView setShowBackButton:YES];
    [contentScrollView addSubview:navigationBarView];
    
    UIImageView *imagesScrollerBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 185)];
    [imagesScrollerBackgroundImageView setImage:[UIImage imageNamed:@"image_scrolller_background"]];
    [contentScrollView addSubview:imagesScrollerBackgroundImageView];
    
    imagesScrollView = [[UIScrollView alloc] initWithFrame:imagesScrollerBackgroundImageView.frame];
    [imagesScrollView setDelegate:self];
    [imagesScrollView setBackgroundColor:[UIColor clearColor]];
    [imagesScrollView setShowsHorizontalScrollIndicator:NO];
    [imagesScrollView setContentSize:CGSizeMake(imagesScrollView.bounds.size.width * 3, imagesScrollView.bounds.size.height)];
    [imagesScrollView setPagingEnabled:YES];
    [contentScrollView addSubview:imagesScrollView];
    
    self.view = contentScrollView;
}

@end
