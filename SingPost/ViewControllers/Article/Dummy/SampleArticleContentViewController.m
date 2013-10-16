//
//  AMMailViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SampleArticleContentViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "FlatBlueButton.h"
#import "ColoredPageControl.h"

@interface SampleArticleContentViewController () <UIScrollViewDelegate>

@end

@implementation SampleArticleContentViewController
{
    UIScrollView *imagesScrollView;
    ColoredPageControl *pageControl;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setShowBackButton:YES];
    [navigationBarView setTitle:_pageTitle];
    [navigationBarView setTitleFontSize:14.0f];
    [contentView addSubview:navigationBarView];
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [contentScrollView setBackgroundColor:[UIColor whiteColor]];
    [contentScrollView setContentSize:CGSizeMake(contentScrollView.bounds.size.width, 1015)];
    [contentView addSubview:contentScrollView];
    
    UIImageView *imagesScrollerBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 185)];
    [imagesScrollerBackgroundImageView setImage:[UIImage imageNamed:@"image_scrolller_background"]];
    [contentScrollView addSubview:imagesScrollerBackgroundImageView];
    
    imagesScrollView = [[UIScrollView alloc] initWithFrame:imagesScrollerBackgroundImageView.frame];
    [imagesScrollView setDelegate:self];
    [imagesScrollView setBackgroundColor:[UIColor clearColor]];
    [imagesScrollView setShowsHorizontalScrollIndicator:NO];
    [imagesScrollView setContentSize:CGSizeMake(imagesScrollView.bounds.size.width * 3, imagesScrollView.bounds.size.height)];
    [imagesScrollView setPagingEnabled:YES];
    [contentScrollView addSubview:imagesScrollView];
    
    UIImageView *sampleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sample_image_scroller"]];
    [sampleImageView setContentMode:UIViewContentModeScaleAspectFit];
    [sampleImageView setFrame:CGRectMake(0, 0, imagesScrollView.bounds.size.width, imagesScrollView.bounds.size.height - 20)];
    [imagesScrollView addSubview:sampleImageView];
    
    pageControl = [[ColoredPageControl alloc] initWithFrame:CGRectMake(0, 160, contentView.bounds.size.width, 20)];
    [pageControl setDotColorCurrentPage:RGB(102, 102, 102)];
    [pageControl setDotColorOtherPage:RGB(204, 204, 204)];
    [pageControl setNumberOfPages:3];
    [pageControl setCurrentPage:0];
    [contentScrollView addSubview:pageControl];
    [pageControl setNeedsDisplay];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 200, contentScrollView.bounds.size.width - 30, 150)];
    [descriptionLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [descriptionLabel setText:@"A.M. Mail is a time-certain postal delivery service within Singapore that delivers your mail by 11 am^ the next business day.\n\nIt is a hassle-free and a convenient way to send your urgent mail. The delivery is assured with time-stamped proof."];
    [descriptionLabel setNumberOfLines:0];
    [descriptionLabel setTextColor:RGB(51, 51, 51)];
    [descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [contentScrollView addSubview:descriptionLabel];
    
    UIView *topTitleSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 360, contentView.bounds.size.width, 1)];
    [topTitleSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [topTitleSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentScrollView addSubview:topTitleSeparatorView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 370, 200, 20)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [titleLabel setTextColor:RGB(125, 136, 149)];
    [titleLabel setText:@"How does it work?"];
    [contentScrollView addSubview:titleLabel];
    
    UIView *bottomTitleSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 400, contentView.bounds.size.width, 1)];
    [bottomTitleSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [bottomTitleSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentScrollView addSubview:bottomTitleSeparatorView];
    
    CGFloat offsetY = 435;
    UILabel *num1Label = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 10, 10)];
    [num1Label setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [num1Label setText:@"1."];
    [num1Label sizeToFit];
    [num1Label setTextColor:RGB(36, 84, 157)];
    [contentScrollView addSubview:num1Label];
    
    UILabel *text1Label = [[UILabel alloc] initWithFrame:CGRectMake(50, offsetY, 250, 100)];
    [text1Label setBackgroundColor:[UIColor clearColor]];
    [text1Label setNumberOfLines:0];
    [text1Label setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [text1Label setTextColor:RGB(58, 68, 81)];
    [text1Label setText:@"Choose from two delivery options\n(prices are inclusive of GST):"];
    [text1Label sizeToFit];
    [contentScrollView addSubview:text1Label];
    
    UIView *subText1Line1IndicatorView = [[UIView alloc] initWithFrame:CGRectMake(58, offsetY + 60, 4, 4)];
    [subText1Line1IndicatorView setBackgroundColor:RGB(125, 136, 149)];
    [contentScrollView addSubview:subText1Line1IndicatorView];
    
    UILabel *subText1Line1Label = [[UILabel alloc] initWithFrame:CGRectMake(68, offsetY + 52, 240, 100)];
    [subText1Line1Label setNumberOfLines:0];
    [subText1Line1Label setFont:[UIFont SingPostRegularFontOfSize:13.0f fontKey:kSingPostFontOpenSans]];
    [subText1Line1Label setTextColor:RGB(125, 136, 149)];
    [subText1Line1Label setText:@"Letterbox Delivery: S$2.60"];
    [subText1Line1Label sizeToFit];
    [contentScrollView addSubview:subText1Line1Label];
    
    UIView *subText1Line2IndicatorView = [[UIView alloc] initWithFrame:CGRectMake(58, offsetY + 80, 4, 4)];
    [subText1Line2IndicatorView setBackgroundColor:RGB(125, 136, 149)];
    [contentScrollView addSubview:subText1Line2IndicatorView];
    
    UILabel *subText1Line2Label = [[UILabel alloc] initWithFrame:CGRectMake(68, offsetY + 72, 240, 100)];
    [subText1Line2Label setNumberOfLines:0];
    [subText1Line2Label setFont:[UIFont SingPostRegularFontOfSize:13.0f fontKey:kSingPostFontOpenSans]];
    [subText1Line2Label setTextColor:RGB(125, 136, 149)];
    [subText1Line2Label setText:@"Doorstep Delivery: S$3.90"];
    [subText1Line2Label sizeToFit];
    [contentScrollView addSubview:subText1Line2Label];
    
    offsetY += 115.0f;
    UILabel *num2Label = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 10, 10)];
    [num2Label setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [num2Label setText:@"2."];
    [num2Label sizeToFit];
    [num2Label setTextColor:RGB(36, 84, 157)];
    [contentScrollView addSubview:num2Label];
    
    UILabel *text2Label = [[UILabel alloc] initWithFrame:CGRectMake(50, offsetY, 250, 100)];
    [text2Label setBackgroundColor:[UIColor clearColor]];
    [text2Label setNumberOfLines:0];
    [text2Label setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [text2Label setTextColor:RGB(58, 68, 81)];
    [text2Label setText:@"Purchase postage-paid A.M. Mail envelopes from any post office according to the preferred delivery option."];
    [text2Label sizeToFit];
    [contentScrollView addSubview:text2Label];
    
    offsetY += 110.0f;
    UILabel *num3Label = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 10, 10)];
    [num3Label setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [num3Label setText:@"3."];
    [num3Label sizeToFit];
    [num3Label setTextColor:RGB(36, 84, 157)];
    [contentScrollView addSubview:num3Label];
    
    UILabel *text3Label = [[UILabel alloc] initWithFrame:CGRectMake(50, offsetY, 250, 100)];
    [text3Label setBackgroundColor:[UIColor clearColor]];
    [text3Label setNumberOfLines:0];
    [text3Label setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [text3Label setTextColor:RGB(58, 68, 81)];
    [text3Label setText:@"Insert your urgent mail in the envelope and drop it in any SingPost posting box."];
    [text3Label sizeToFit];
    [contentScrollView addSubview:text3Label];
    
    offsetY += 99.0f;
    UILabel *num4Label = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 10, 10)];
    [num4Label setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [num4Label setText:@"4."];
    [num4Label sizeToFit];
    [num4Label setTextColor:RGB(36, 84, 157)];
    [contentScrollView addSubview:num4Label];
    
    UILabel *text4Label = [[UILabel alloc] initWithFrame:CGRectMake(50, offsetY, 250, 100)];
    [text4Label setBackgroundColor:[UIColor clearColor]];
    [text4Label setNumberOfLines:0];
    [text4Label setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [text4Label setTextColor:RGB(58, 68, 81)];
    [text4Label setText:@"Your A.M. Mail will be delivered to the addressees no later than 11 am the next working day if you post it:"];
    [text4Label sizeToFit];
    [contentScrollView addSubview:text4Label];
    
    UIView *subText4Line1IndicatorView = [[UIView alloc] initWithFrame:CGRectMake(58, offsetY + 80, 4, 4)];
    [subText4Line1IndicatorView setBackgroundColor:RGB(125, 136, 149)];
    [contentScrollView addSubview:subText4Line1IndicatorView];
    
    UILabel *subText4Line1Label = [[UILabel alloc] initWithFrame:CGRectMake(68, offsetY + 72, 230, 100)];
    [subText4Line1Label setNumberOfLines:0];
    [subText4Line1Label setFont:[UIFont SingPostRegularFontOfSize:13.0f fontKey:kSingPostFontOpenSans]];
    [subText4Line1Label setTextColor:RGB(125, 136, 149)];
    [subText4Line1Label setText:@"Within CBD – Mondays to Thursdays by 7pm and Fridays by 8pm."];
    [subText4Line1Label sizeToFit];
    [contentScrollView addSubview:subText4Line1Label];
    
    UIView *subText4Line2IndicatorView = [[UIView alloc] initWithFrame:CGRectMake(58, offsetY + 120, 4, 4)];
    [subText4Line2IndicatorView setBackgroundColor:RGB(125, 136, 149)];
    [contentScrollView addSubview:subText4Line2IndicatorView];
    
    UILabel *subText4Line2Label = [[UILabel alloc] initWithFrame:CGRectMake(68, offsetY + 113, 240, 100)];
    [subText4Line2Label setNumberOfLines:0];
    [subText4Line2Label setFont:[UIFont SingPostRegularFontOfSize:13.0f fontKey:kSingPostFontOpenSans]];
    [subText4Line2Label setTextColor:RGB(125, 136, 149)];
    [subText4Line2Label setText:@"Outside CDB – Mondays to Thursdays by 5pm and Fridays by 6pm"];
    [subText4Line2Label sizeToFit];
    [contentScrollView addSubview:subText4Line2Label];
    
    FlatBlueButton *callToActionButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, 945, contentScrollView.bounds.size.width - 30, 48)];
    [callToActionButton addTarget:self action:@selector(callToActionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [callToActionButton setTitle:@"CALL-TO-ACTION" forState:UIControlStateNormal];
    [contentScrollView addSubview:callToActionButton];
    
    self.view = contentView;
}

#pragma mark - IBActions

- (IBAction)callToActionButtonClicked:(id)sender
{
    NSLog(@"call to action button clicked");
}

#pragma mark - UIScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == imagesScrollView) {
        [pageControl setCurrentPage:floorf((imagesScrollView.contentOffset.x + 100) / imagesScrollView.bounds.size.width)];
    }
}

@end
