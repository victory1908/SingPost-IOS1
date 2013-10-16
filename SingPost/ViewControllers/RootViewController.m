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
#import "SendReceiveMainViewController.h"
#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>
#import <MHNatGeoViewControllerTransition.h>

@interface RootViewController ()

@end

@implementation RootViewController
{
    SidebarMenuViewController *sideBarMenuViewController;
    UIView *appContentView, *activeViewControllerContainerView;
    UIButton *closeSidebarButton;
    UIViewController *activeViewController;
    
    UIPanGestureRecognizer *sideBarPanGesture;
    
    CATransform3D originalTransformation;
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSideBar];
    
    activeViewController = [[LandingPageViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:activeViewController];
    [activeViewControllerContainerView addSubview:activeViewController.view];
    [activeViewController didMoveToParentViewController:self];
    
    sideBarPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [sideBarPanGesture setEnabled:NO];
    [activeViewControllerContainerView addGestureRecognizer:sideBarPanGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    if (sideBarMenuViewController.isVisible) {
        CGPoint translation = [panGesture translationInView:panGesture.view];
        double percentageOfWidth = MAX(-1.0f, MIN(0.0f, translation.x) / sideBarMenuViewController.view.bounds.size.width);
        
        if (panGesture.state == UIGestureRecognizerStateBegan) {
            originalTransformation = sideBarMenuViewController.view.layer.transform;
            originalTransformation.m34 = -0.001f;
        }
        else if (panGesture.state == UIGestureRecognizerStateEnded) {
            if (sideBarMenuViewController.view.frame.origin.x > 0.0f) {
                sideBarMenuViewController.isVisible = !sideBarMenuViewController.isVisible;
                [self showSideBar:sideBarMenuViewController.isVisible step:(1.0f - fabsf(percentageOfWidth)) animate:YES preserveTransform:YES];
            }
            
        }
        else {
            [appContentView setX:(percentageOfWidth * SIDEBAR_WIDTH)];
            
            CATransform3D transform = originalTransformation;
            transform = CATransform3DRotate(originalTransformation, fabsf(percentageOfWidth) * -M_PI_2, 0, 1, 0);
            sideBarMenuViewController.view.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
            sideBarMenuViewController.view.layer.transform = transform;
        }
    }
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
    [self showSideBar:sideBarMenuViewController.isVisible step:1.0f animate:YES preserveTransform:NO];
    
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
    
    destinationView.layer.zPosition = activeViewControllerContainerView.layer.zPosition + 10;
    
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

    activeViewController.view.layer.zPosition = sourceView.layer.zPosition - 1;
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
    
    closeSidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeSidebarButton setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.2f]];
    [closeSidebarButton addTarget:self action:@selector(closeSidebarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self showSideBar:NO step:1.0f animate:NO preserveTransform:NO];
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
    [self showSideBar:sideBarMenuViewController.isVisible step:1.0f animate:YES preserveTransform:NO];
}

#pragma mark - Side bar

- (void)toggleSideBarVisiblity
{
    sideBarMenuViewController.isVisible = !sideBarMenuViewController.isVisible;
    [self showSideBar:sideBarMenuViewController.isVisible step:1.0f animate:YES preserveTransform:NO];
}

- (void)showSideBar:(BOOL)shouldShowSideBar step:(CGFloat)stepRatio animate:(BOOL)shouldAnimate preserveTransform:(BOOL)shouldPreserveTransform
{
    double animationDuration = shouldAnimate ? 0.5f : 0.00001f;
    
    if (shouldShowSideBar) {
        [closeSidebarButton setFrame:activeViewController.view.frame];
        [activeViewController.view endEditing:YES];
        [activeViewController.view addSubview:closeSidebarButton];
    }
    
    closeSidebarButton.alpha = shouldShowSideBar ? 0.0f : 1.0f;
    
    [CATransaction begin];
    [CATransaction setValue:@(animationDuration) forKey:kCATransactionAnimationDuration];
    
    CATransform3D transform;
    if (shouldPreserveTransform) {
        transform = sideBarMenuViewController.view.layer.transform;
    }
    else {
        transform = CATransform3DIdentity;
        if (!shouldShowSideBar)
            transform.m34 = -0.001f;
    }
    
    transform = CATransform3DRotate(transform, stepRatio * (shouldShowSideBar ? 0 : -M_PI_2), 0, 1, 0);
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:transform];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    sideBarMenuViewController.view.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
    [sideBarMenuViewController.view.layer addAnimation:rotationAnimation forKey:@"transform"];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [appContentView setX:shouldShowSideBar ? 0.0f : -SIDEBAR_WIDTH];
        closeSidebarButton.alpha = shouldShowSideBar ? 1.0f : 0.0f;
    } completion:^(BOOL finished) {
        sideBarMenuViewController.view.layer.transform = transform;
        [sideBarMenuViewController.view.layer removeAllAnimations];
        if (!shouldShowSideBar)
            [closeSidebarButton removeFromSuperview];
        
        [sideBarPanGesture setEnabled:shouldShowSideBar];
    }];
    
    [CATransaction commit];
}

@end
