//
//  RootViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

- (void)toggleSideBarVisiblity;
- (void)updateMaintananceStatusUIs;
- (void)switchToViewController:(UIViewController *)viewController;
- (void)cPushViewController:(UIViewController *)viewController;
- (void)cPopViewController;
- (BOOL)isSideBarVisible;

@end
