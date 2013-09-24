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

@interface RootViewController ()

@end

#define SIDEBAR_WIDTH (INTERFACE_IS_IPAD ? 300.0f : 150.0f)

@implementation RootViewController
{
    SidebarMenuViewController *sideBarMenuViewController;
    BOOL isSideBarMenuOpened;
    UIButton *clickMeButton;
    UIView *containerView;
}

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
    
    [self.view setBackgroundColor:[UIColor purpleColor]];
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    containerView = [[UIView alloc] initWithFrame:appFrame];
    [containerView setWidth:containerView.bounds.size.width + SIDEBAR_WIDTH];
    [self.view addSubview:containerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    clickMeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clickMeButton setTitle:@"click for side bar" forState:UIControlStateNormal];
    [clickMeButton addTarget:self action:@selector(toggleSideBarClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clickMeButton setBackgroundColor:[UIColor darkGrayColor]];
    [clickMeButton setFrame:CGRectMake(SIDEBAR_WIDTH, 40, 250, 100)];
    [containerView addSubview:clickMeButton];
    
    [self loadSideBar];
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
    
    sideBarMenuViewController.view.frame = CGRectMake(SIDEBAR_WIDTH / 2.0f, 0, SIDEBAR_WIDTH, containerView.bounds.size.height);
    [containerView addSubview:sideBarMenuViewController.view];
    [sideBarMenuViewController didMoveToParentViewController:self];
    
    [self toggleSideBarVisible:NO withAnimation:NO];
}

#pragma mark - IBActions

- (IBAction)toggleSideBarClicked:(id)sender
{
    isSideBarMenuOpened = !isSideBarMenuOpened;
    [self toggleSideBarVisible:isSideBarMenuOpened withAnimation:YES];
}

#pragma mark - Animations

- (void)toggleSideBarVisible:(BOOL)shouldShowSideBar withAnimation:(BOOL)shouldAnimate
{
    double animationDuration = shouldAnimate ? 0.5f : 0.0f;
    double angle = -M_PI_2;
    
    [CATransaction begin];
    [CATransaction setValue:@(animationDuration) forKey:kCATransactionAnimationDuration];
    
    CATransform3D transform = CATransform3DIdentity;
    
    if (!shouldShowSideBar) {
        transform.m34 = -0.001f;
        transform = CATransform3DRotate(transform, angle, 0, 1, 0);
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
        [containerView setX:shouldShowSideBar ? 0.0f : -SIDEBAR_WIDTH];
    }];
    
    [CATransaction commit];
}

@end
