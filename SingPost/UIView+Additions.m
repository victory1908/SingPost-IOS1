//
//  UIView+Additions.m
//  GNC
//
//  Created by Wei Guang on 28/1/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "UIView+Additions.h"

static GADBannerView *bannerView;
static UIView *senderView;
static UIView *containerView;
static UIView *bannerContainerView;
static float bannerHeight;

@implementation UIView (Additions)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.bounds.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.bounds.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)contentCenter {
    return CGPointMake(floorf(self.width/2.0f), floorf(self.height/2.0f));
}

- (UIImage *)capture {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - Animation
- (void)fadeInWithDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.alpha = 1;
    }];
}

- (void)fadeOutWithDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.alpha = 0;
    }];
}

- (void)fadeInWithDuration:(CGFloat)duration delay:(CGFloat)delay {
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.alpha = 1;
    }];
}

- (void)fadeOutWithDuration:(CGFloat)duration delay:(CGFloat)delay {
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.alpha = 0;
    }];
}

- (void)fadeToAlpha:(CGFloat)alpha withDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = alpha;
    } completion:^(BOOL finished) {
        self.alpha = alpha;
    }];
}

- (UIView *)findAndResignFirstResponder {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return self;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return self;
    }
    return nil;
}

+ (void)createBanner:(UIViewController *)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        bannerHeight = 50;
    }
    else
    {
        bannerHeight = 90;
    }
    
    GADRequest *request = [GADRequest request];
//    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    bannerView.adUnitID = AdMobUnitId;
    bannerView.rootViewController = (id)self;
    bannerView.delegate = (id<GADBannerViewDelegate>)self;
    
    senderView = sender.view;
    
    bannerView.frame = CGRectMake(0, 0, senderView.frame.size.width, bannerHeight);
    
    [bannerView loadRequest:request];
    
    containerView = [[UIView alloc] initWithFrame:senderView.frame];
    
    bannerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, senderView.frame.size.height, senderView.frame.size.width, bannerHeight)];
    
    for (id object in sender.view.subviews) {
        
        [object removeFromSuperview];
        [containerView addSubview:object];
        
    }
    
    [senderView addSubview:containerView];
    [senderView addSubview:bannerContainerView];
    
    [self adViewDidReceiveAd:bannerView];
    
}

+ (void)adViewDidReceiveAd:(GADBannerView *)view
{
    [UIView animateWithDuration:0.5 animations:^{
        
        containerView.frame = CGRectMake(0, 0, senderView.frame.size.width, senderView.frame.size.height - bannerHeight);
        bannerContainerView.frame = CGRectMake(0, senderView.frame.size.height - bannerHeight, senderView.frame.size.width, bannerHeight);
        [bannerContainerView addSubview:bannerView];
        
    }];
    
}

@end
