//
//  RootViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef double (^KeyframeParametricBlock)(double);

@interface RootViewController : UIViewController

@property (nonatomic, readonly) NSArray *containerViewControllers;

- (void)toggleSideBarVisiblity;

@end
