//
//  UIView+Additions.h
//  GNC
//
//  Created by Wei Guang on 28/1/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface UIView (Additions)

//frame.origin.x = left
@property (nonatomic) CGFloat left;
//frame.origin.x + frame.size.width = right
@property (nonatomic) CGFloat right;
//frame.origin.y = top
@property (nonatomic) CGFloat top;
//frame.origin.y + frame.size.height
@property (nonatomic) CGFloat bottom;
//bounds.size.width
@property (nonatomic) CGFloat width;
//bounds.size.width
@property (nonatomic) CGFloat height;
//frame.size
@property (nonatomic) CGSize size;
//View center point
@property (nonatomic, readonly) CGPoint contentCenter;


//Taking screenshot of the screen
- (UIImage *)capture;

//Animations
- (void)fadeInWithDuration:(CGFloat)duration;
- (void)fadeOutWithDuration:(CGFloat)duration;
- (void)fadeInWithDuration:(CGFloat)duration delay:(CGFloat)delay;
- (void)fadeOutWithDuration:(CGFloat)duration delay:(CGFloat)delay;
- (void)fadeToAlpha:(CGFloat)alpha withDuration:(CGFloat)duration;

- (UIView *)findAndResignFirstResponder;

//Create Ad
+ (void)createBanner:(UIViewController *)sender;
+ (void)adViewDidReceiveAd:(GADBannerView *)view;



@end
