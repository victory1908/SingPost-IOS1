////
////  UIViewController+Navigation.m
////  SingPost
////
////  Created by Le Khanh Vinh on 23/11/16.
////  Copyright © 2016 Codigo. All rights reserved.
////
//
//#import "UIViewController+Navigation.h"
//
//@implementation UIViewController (Navigation)
//
//- (void)switchToViewController:(UIViewController *)viewController
//{
////    //close side bar
////    sideBarMenuViewController.isVisible = NO;
////    [self showSideBar:sideBarMenuViewController.isVisible step:1.0f animate:YES preserveTransform:NO];
//    
//    //kill existing child viewcontrollers except the sidebar
//    for (UIViewController *childViewController in self.childViewControllers) {
////        if (childViewController != sideBarMenuViewController) {
//            [childViewController willMoveToParentViewController:nil];
//            [childViewController.view removeFromSuperview];
//            [childViewController removeFromParentViewController];
////        }
//    }
//    
//    //swap in new view controller
//    activeViewController = viewController;
//    [self addChildViewController:activeViewController];
//    [activeViewControllerContainerView addSubview:activeViewController.view];
//    [activeViewController didMoveToParentViewController:self];
//}
//
//- (void)newSwitchToViewController2:(UIViewController *)viewController
//{
//    //close side bar
//    sideBarMenuViewController.isVisible = NO;
//    [self showSideBar:sideBarMenuViewController.isVisible step:1.0f animate:YES preserveTransform:NO];
//    
//    //kill existing child viewcontrollers except the sidebar
//    for (UIViewController *childViewController in self.childViewControllers) {
//        if (childViewController != sideBarMenuViewController) {
//            [childViewController willMoveToParentViewController:nil];
//            [childViewController.view removeFromSuperview];
//            [childViewController removeFromParentViewController];
//        }
//    }
//    
//    //[self cPushViewControllerNew:viewController];
//    CGRect oldFrame = [[activeViewController.view layer]frame];
//    [[activeViewController.view layer]setAnchorPoint:CGPointMake(0.0,0.5f)];
//    [[activeViewController.view layer] setFrame:oldFrame];
//    sourceTransform(activeViewController.view.layer);
//    [viewController setPresentedFromViewController:activeViewController];
//    
//    activeViewController = viewController;
//    [activeViewController.view setY:0];
//    [self addChildViewController:activeViewController];
//    [activeViewControllerContainerView addSubview:activeViewController.view];
//    [activeViewController didMoveToParentViewController:self];
//}
//double radianFromDegree2(float degrees) {
//    return (degrees / 180) * M_PI;
//}
//
//void sourceTransform(CALayer *layer) {
//    CATransform3D t = CATransform3DIdentity;
//    t.m34 = 1.0/ -500;
//    t = CATransform3DRotate(t, radianFromDegree2(80), 0.0f,1.0f, 0.0f);
//    t = CATransform3DTranslate(t, 0.0f, 0.0f,  -30.0f);
//    t = CATransform3DTranslate(t,170.0f, 0.0f,  0.0f);
//    layer.transform = t;
//}
//
//void sourceFirstTransform2(CALayer *layer) {
//    CATransform3D t = CATransform3DIdentity;
//    t.m34 = 1.0/ -500;
//    t = CATransform3DTranslate(t, 0.0f, 0.0f,  0.0f);
//    layer.transform = t;
//}
//
//#define PAGE_TRANSITION_DURATION 0.6f
//
//- (void)cPushViewController:(UIViewController *)viewController
//{
//    __block UIView *destinationView = viewController.view;
//    [destinationView setY:20];
//    [self.view addSubview:destinationView];
//    destinationView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    
//    MHNatGeoViewControllerTransition *natGeoTransition = [[MHNatGeoViewControllerTransition alloc] initWithSourceView:activeViewController.view destinationView:destinationView duration:PAGE_TRANSITION_DURATION];
//    
//    destinationView.layer.zPosition = activeViewControllerContainerView.layer.zPosition + 10;
//    
//    [activeViewController.view endEditing:YES];
//    
//    [natGeoTransition perform:^(BOOL finished) {
//        if (finished) {
//            [viewController setPresentedFromViewController:activeViewController];
//            [destinationView removeFromSuperview];
//            destinationView = nil;
//            
//            activeViewController = viewController;
//            [activeViewController.view setY:0];
//            [self addChildViewController:activeViewController];
//            [activeViewControllerContainerView addSubview:activeViewController.view];
//            [activeViewController didMoveToParentViewController:self];
//        }
//    }];
//}
//
//- (void)cPopViewController
//{
//    UIViewController *sourceViewController = activeViewController.presentedFromViewController;
//    __block UIView *sourceView = sourceViewController.view;
//    
//    activeViewController.view.layer.zPosition = sourceView.layer.zPosition - 1;
//    [activeViewControllerContainerView addSubview:sourceView];
//    
//    MHNatGeoViewControllerTransition * natGeoTransition = [[MHNatGeoViewControllerTransition alloc]initWithSourceView:sourceView destinationView:[activeViewController view] duration:PAGE_TRANSITION_DURATION];
//    [natGeoTransition setDismissing:YES];
//    [natGeoTransition perform:^(BOOL finished) {
//        if(finished) {
//            [activeViewController setPresentedFromViewController:nil];
//            
//            [activeViewController willMoveToParentViewController:nil];
//            [activeViewController.view removeFromSuperview];
//            [activeViewController removeFromParentViewController];
//            activeViewController = sourceViewController;
//        }
//    }];
//}
//
//- (void)cPopViewControllerOrSwitch :(UIViewController *)viewController
//{
//    UIViewController *sourceViewController = activeViewController.presentedFromViewController;
//    __block UIView *sourceView = sourceViewController.view;
//    
//    if(!sourceViewController) {
//        sourceViewController = viewController;
//        sourceView = sourceViewController.view;
//        
//    }
//    
//    activeViewController.view.layer.zPosition = sourceView.layer.zPosition - 1;
//    [activeViewControllerContainerView addSubview:sourceView];
//    
//    MHNatGeoViewControllerTransition * natGeoTransition = [[MHNatGeoViewControllerTransition alloc]initWithSourceView:sourceView destinationView:[activeViewController view] duration:PAGE_TRANSITION_DURATION];
//    [natGeoTransition setDismissing:YES];
//    [natGeoTransition perform:^(BOOL finished) {
//        if(finished) {
//            [activeViewController setPresentedFromViewController:nil];
//            
//            [activeViewController willMoveToParentViewController:nil];
//            [activeViewController.view removeFromSuperview];
//            [activeViewController removeFromParentViewController];
//            activeViewController = sourceViewController;
//        }
//    }];
//}
//
//
//@end
