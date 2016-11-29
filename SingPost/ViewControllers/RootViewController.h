//
//  RootViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarScannerViewController.h"

@interface RootViewController : UIViewController <BarScannerViewControllerDelegate>{
    UIViewController *activeViewController;
}

@property (nonatomic,retain)UIViewController *activeViewController;

- (void)toggleSideBarVisiblity;
- (void)updateMaintananceStatusUIs;
- (void)switchToViewController:(UIViewController *)viewController;
- (void)newSwitchToViewController2:(UIViewController *)viewController;
- (void)cPushViewController:(UIViewController *)viewController;
- (void)cPopViewController;
- (void)cPopViewControllerOrSwitch :(UIViewController *)viewController;
- (BOOL)isSideBarVisible;

//- (void)cInteractivePopViewController : (double)offsetX;

- (void) checkSignStatus;

@end
