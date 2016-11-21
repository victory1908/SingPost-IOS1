//
//  AdMobViewController.m
//  SingPost
//
//  Created by Le Khanh Vinh on 21/11/16.
//  Copyright © 2016 Codigo. All rights reserved.
//

#import "AdMobViewController.h"
//#import "GADBannerView.h"


@interface AdMobViewController ()

@end

static GADBannerView *bannerView;
static UIView *senderView;
static UIView *containerView;
static UIView *bannerContainerView;
static float bannerHeight;

@implementation AdMobViewController

//+ (void)createBanner:(UIViewController *)sender
+ (GADBannerView *)createBanner:(UIViewController *)sender
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
    
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView.adUnitID = AdUnitID;
    bannerView.rootViewController = (id)self;
    bannerView.delegate = (id<GADBannerViewDelegate>)self;
//    bannerView.delegate = sender;
    
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
    
    
    return bannerView;
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
