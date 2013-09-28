//
//  RootViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "RootViewController.h"
#import "SidebarMenuViewController.h"
#import "UIView+Position.h"

#import "LandingPageViewController.h"
#import "TrackingMainViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()

@end

#define SIDEBAR_WIDTH (INTERFACE_IS_IPAD ? 300.0f : 200.0f)

@implementation RootViewController
{
    SidebarMenuViewController *sideBarMenuViewController;
    UIView *appContentView, *activeViewControllerContainerView;
    UIViewController *activeViewController;
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    CGRect appFrame = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? [UIScreen mainScreen].applicationFrame : [[UIScreen mainScreen] bounds];
    appContentView = [[UIView alloc] initWithFrame:CGRectMake(0, appFrame.origin.y, appFrame.size.width + SIDEBAR_WIDTH, appFrame.size.height)];
    [self.view addSubview:appContentView];
    
    activeViewControllerContainerView = [[UIView alloc] initWithFrame:CGRectMake(SIDEBAR_WIDTH, 0, appFrame.size.width, appFrame.size.height)];
    [activeViewControllerContainerView setBackgroundColor:[UIColor whiteColor]];
    [activeViewControllerContainerView setClipsToBounds:YES];
    [appContentView addSubview:activeViewControllerContainerView];
    
    [self loadSideBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activeViewController = [[LandingPageViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:activeViewController];
    [activeViewControllerContainerView addSubview:activeViewController.view];
    [activeViewController didMoveToParentViewController:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

#pragma mark - App Pages

- (void)goToAppPage:(tAppPages)targetPage
{
    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
    
    __block UIView * destinationView = [trackingMainViewController view];
    [destinationView setY:20];
    [self.view addSubview:destinationView];
    destinationView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    MHNatGeoViewControllerTransition *natGeoTransition = [[MHNatGeoViewControllerTransition alloc] initWithSourceView:activeViewController.view destinationView:trackingMainViewController.view duration:0.6f];
    
    activeViewControllerContainerView.layer.zPosition = 10;
    destinationView.layer.zPosition = 11;
    
    [natGeoTransition perform:^(BOOL finished) {
        [trackingMainViewController setPresentedFromViewController:activeViewController];
        [destinationView removeFromSuperview];
        destinationView = nil;

        activeViewController = trackingMainViewController;
        [activeViewController.view setY:0];
        [self addChildViewController:activeViewController];
        [activeViewControllerContainerView addSubview:activeViewController.view];
        [activeViewController didMoveToParentViewController:self];
    }];
}

- (void)wipBack
{
    UIViewController *sourceController = activeViewController.presentedFromViewController;
    __block UIView * sourceView = [activeViewController.presentedFromViewController view];
    NSLog(@"is kind of class: %@", NSStringFromClass(activeViewController.presentedFromViewController.class));
//    sourceView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [activeViewControllerContainerView addSubview:sourceView];
    
    
    sourceView.layer.zPosition = 11;
    activeViewController.view.layer.zPosition = 10;
    
    MHNatGeoViewControllerTransition * natGeoTransition = [[MHNatGeoViewControllerTransition alloc]initWithSourceView:sourceView destinationView:[activeViewController view] duration:0.6f];
    [natGeoTransition setDismissing:YES];
    [natGeoTransition perform:^(BOOL finished) {
        if(finished){
            [activeViewController setPresentedFromViewController:nil];
            
            [activeViewController willMoveToParentViewController:nil];
            [activeViewController.view removeFromSuperview];
            [activeViewController removeFromParentViewController];
            activeViewController = sourceController;
        }
    }];
}

#pragma mark - UI

- (void)loadSideBar
{
    sideBarMenuViewController = [[SidebarMenuViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:sideBarMenuViewController];
    
    sideBarMenuViewController.view.frame = CGRectMake(SIDEBAR_WIDTH / 2.0f, 0, SIDEBAR_WIDTH, appContentView.bounds.size.height);
    [appContentView addSubview:sideBarMenuViewController.view];
    [sideBarMenuViewController didMoveToParentViewController:self];
    
    [self showSideBar:NO withAnimation:NO];
}

#pragma mark - IBActions

- (IBAction)toggleSideBarButtonClicked:(id)sender
{
    [self toggleSideBarVisiblity];
}

#pragma mark - Side bar

- (void)toggleSideBarVisiblity
{
    sideBarMenuViewController.isVisible = !sideBarMenuViewController.isVisible;
    [self showSideBar:sideBarMenuViewController.isVisible withAnimation:YES];
}

- (void)showSideBar:(BOOL)shouldShowSideBar withAnimation:(BOOL)shouldAnimate
{
    double animationDuration = shouldAnimate ? 0.5f : 0.00001f;

    [CATransaction begin];
    [CATransaction setValue:@(animationDuration) forKey:kCATransactionAnimationDuration];
    
    CATransform3D transform = CATransform3DIdentity;
    
    if (!shouldShowSideBar) {
        transform.m34 = -0.001f;
        transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    }
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:transform];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    sideBarMenuViewController.view.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
    [sideBarMenuViewController.view.layer addAnimation:rotationAnimation forKey:shouldShowSideBar ? @"rotationAnimation" : @"transform"];

    [UIView animateWithDuration:animationDuration animations:^{
        [appContentView setX:shouldShowSideBar ? 0.0f : -SIDEBAR_WIDTH];
    }];
    
    [CATransaction commit];
}

@end
