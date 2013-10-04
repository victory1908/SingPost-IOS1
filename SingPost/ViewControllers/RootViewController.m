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

#import <QuartzCore/QuartzCore.h>
#import <MHNatGeoViewControllerTransition.h>

@interface RootViewController ()

@end

#define SIDEBAR_WIDTH 245.0f

@implementation RootViewController
{
    SidebarMenuViewController *sideBarMenuViewController;
    UIView *appContentView, *activeViewControllerContainerView;
    UIButton *closeSidebarButton;
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

- (void)switchToViewController:(UIViewController *)viewController
{
    //close side bar
    sideBarMenuViewController.isVisible = NO;
    [self showSideBar:sideBarMenuViewController.isVisible withAnimation:YES];
    
    //kill existing child viewcontrollers except the sidebar
    for (UIViewController *childViewController in self.childViewControllers) {
        if (childViewController != sideBarMenuViewController) {
            [childViewController willMoveToParentViewController:nil];
            [childViewController.view removeFromSuperview];
            [childViewController removeFromParentViewController];
        }
    }
    
    //swap in new view controller
    activeViewController = viewController;
    [self addChildViewController:activeViewController];
    [activeViewControllerContainerView addSubview:activeViewController.view];
    [activeViewController didMoveToParentViewController:self];
}

#define PAGE_TRANSITION_DURATION 0.6f

- (void)cPushViewController:(UIViewController *)viewController
{
    __block UIView *destinationView = viewController.view;
    [destinationView setY:20];
    [self.view addSubview:destinationView];
    destinationView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    MHNatGeoViewControllerTransition *natGeoTransition = [[MHNatGeoViewControllerTransition alloc] initWithSourceView:activeViewController.view destinationView:destinationView duration:PAGE_TRANSITION_DURATION];
    
    activeViewControllerContainerView.layer.zPosition = 1;
    destinationView.layer.zPosition = 999;
    
    [activeViewController.view endEditing:YES];
    
    [natGeoTransition perform:^(BOOL finished) {
        if (finished) {
            [viewController setPresentedFromViewController:activeViewController];
            [destinationView removeFromSuperview];
            destinationView = nil;
            
            activeViewController = viewController;
            [activeViewController.view setY:0];
            [self addChildViewController:activeViewController];
            [activeViewControllerContainerView addSubview:activeViewController.view];
            [activeViewController didMoveToParentViewController:self];
        }
    }];
}

- (void)cPopViewController
{
    UIViewController *sourceViewController = activeViewController.presentedFromViewController;
    __block UIView *sourceView = sourceViewController.view;

    sourceView.layer.zPosition = 2;
    activeViewController.view.layer.zPosition = 1;
    [activeViewControllerContainerView addSubview:sourceView];
    
    MHNatGeoViewControllerTransition * natGeoTransition = [[MHNatGeoViewControllerTransition alloc]initWithSourceView:sourceView destinationView:[activeViewController view] duration:PAGE_TRANSITION_DURATION];
    [natGeoTransition setDismissing:YES];
    [natGeoTransition perform:^(BOOL finished) {
        if(finished) {
            [activeViewController setPresentedFromViewController:nil];
            
            [activeViewController willMoveToParentViewController:nil];
            [activeViewController.view removeFromSuperview];
            [activeViewController removeFromParentViewController];
            activeViewController = sourceViewController;
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
    
    //invisible close side bar button
    closeSidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeSidebarButton setFrame:activeViewControllerContainerView.frame];
    [closeSidebarButton setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.2f]];
    [closeSidebarButton setHidden:YES];
    [closeSidebarButton addTarget:self action:@selector(closeSidebarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [appContentView addSubview:closeSidebarButton];
}

#pragma mark - IBActions

- (IBAction)toggleSideBarButtonClicked:(id)sender
{
    [self toggleSideBarVisiblity];
}

- (IBAction)closeSidebarButtonClicked:(id)sender
{
    [sideBarMenuViewController.view endEditing:YES];
    sideBarMenuViewController.isVisible = NO;
    [self showSideBar:sideBarMenuViewController.isVisible withAnimation:YES];
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
    
    [appContentView bringSubviewToFront:closeSidebarButton];
    closeSidebarButton.hidden = NO;
    closeSidebarButton.alpha = shouldShowSideBar ? 0.0f : 1.0f;

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
        closeSidebarButton.alpha = shouldShowSideBar ? 1.0f : 0.0f;
    }];
    
    [CATransaction commit];
}

@end
