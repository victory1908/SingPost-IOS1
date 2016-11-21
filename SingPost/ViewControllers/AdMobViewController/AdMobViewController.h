//
//  AdMobViewController.h
//  SingPost
//
//  Created by Le Khanh Vinh on 21/11/16.
//  Copyright © 2016 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface AdMobViewController : UIView

//+ (void)createBanner:(UIViewController *)sender;

+(GADBannerView *)createBanner: (UIViewController *)sender;

+ (void)adViewDidReceiveAd:(GADBannerView *)view;

@end



