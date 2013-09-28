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
- (void)cPushViewController:(UIViewController *)viewController;
- (void)cPopViewController;

@end
