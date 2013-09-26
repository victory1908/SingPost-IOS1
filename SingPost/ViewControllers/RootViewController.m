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

@interface RootViewController ()

@end

#define SIDEBAR_WIDTH (INTERFACE_IS_IPAD ? 300.0f : 150.0f)

@implementation RootViewController
{
    SidebarMenuViewController *sideBarMenuViewController;
    BOOL isSideBarMenuOpened;
    UIView *appContentView, *activeViewControllerView;
}

#pragma mark - View lifecycle

- (id)initWithContainerViewControllers:(NSArray *)inContainerViewControllers
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _containerViewControllers = inContainerViewControllers;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    appContentView = [[UIView alloc] initWithFrame:CGRectMake(0, appFrame.origin.y, appFrame.size.width + SIDEBAR_WIDTH, appFrame.size.height)];
    [self.view addSubview:appContentView];
    
    activeViewControllerView = [[UIView alloc] initWithFrame:CGRectMake(SIDEBAR_WIDTH, 0, appFrame.size.width, appFrame.size.height)];
    [activeViewControllerView setBackgroundColor:[UIColor orangeColor]];
    [appContentView addSubview:activeViewControllerView];
    
    [self loadSideBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LandingPageViewController *landingPageViewController = [[LandingPageViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:landingPageViewController];
    [activeViewControllerView addSubview:landingPageViewController.view];
    [landingPageViewController didMoveToParentViewController:self];
    
//    UIButton *clickMeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [clickMeButton setTitle:@"click for side bar" forState:UIControlStateNormal];
//    [clickMeButton addTarget:self action:@selector(toggleSideBarClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [clickMeButton setBackgroundColor:[UIColor darkGrayColor]];
//    [clickMeButton setFrame:CGRectMake(0, 40, 250, 100)];
//    [activeViewControllerView addSubview:clickMeButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

#pragma mark - UI

- (void)loadSideBar
{
    sideBarMenuViewController = [[SidebarMenuViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:sideBarMenuViewController];
    
    sideBarMenuViewController.view.frame = CGRectMake(SIDEBAR_WIDTH / 2.0f, 0, SIDEBAR_WIDTH, appContentView.bounds.size.height);
    [appContentView addSubview:sideBarMenuViewController.view];
    [sideBarMenuViewController didMoveToParentViewController:self];
    
    [self toggleSideBarVisible:NO withAnimation:NO];
}

#pragma mark - IBActions

- (IBAction)toggleSideBarClicked:(id)sender
{
    [self toggleSideBarVisiblity];
}

#pragma mark - Side bar

- (void)toggleSideBarVisiblity
{
    isSideBarMenuOpened = !isSideBarMenuOpened;
    [self toggleSideBarVisible:isSideBarMenuOpened withAnimation:YES];
}

- (void)toggleSideBarVisible:(BOOL)shouldShowSideBar withAnimation:(BOOL)shouldAnimate
{
    double animationDuration = shouldAnimate ? 0.5f : 0.0f;

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
    
    if (shouldAnimate)
        [sideBarMenuViewController.view.layer addAnimation:rotationAnimation forKey:shouldShowSideBar ? @"rotationAnimation" : @"transform"];
    else
        [sideBarMenuViewController.view.layer setTransform:transform];

    [UIView animateWithDuration:animationDuration animations:^{
        [appContentView setX:shouldShowSideBar ? 0.0f : -SIDEBAR_WIDTH];
    }];
    
    [CATransaction commit];
}

@end
