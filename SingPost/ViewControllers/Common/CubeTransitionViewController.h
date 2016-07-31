//
//  CubeTransitionViewController.h
//  WanBao
//
//  Created by Edward Soetiono on 15/3/13.
//  Copyright (c) 2013 SPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CubeTransitionViewController : UIViewController

- (id)initWithViewControllers:(NSArray *)viewControllers;
- (void)animateFromCurrent:(UIViewController *)current toNext:(UIViewController *)next forward:(BOOL)forward onCompletion:(void(^)())completion;

@end
