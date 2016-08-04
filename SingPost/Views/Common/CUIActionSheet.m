//
//  FlatBlueButton.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CUIActionSheet.h"

#define _height 250
#define APP_FRAME                                   [[UIScreen mainScreen] applicationFrame].size
#define STATUSBAR_FRAME                             [UIApplication sharedApplication].statusBarFrame
#define STATUSBAR_HEIGHT                            MIN(STATUSBAR_FRAME.size.height, STATUSBAR_FRAME.size.width)
//#define APPFRAME_HEIGHT_PORTRAIT                    ([[UIScreen mainScreen] applicationFrame].size.height) + STATUSBAR_HEIGHT
#define APPFRAME_HEIGHT_PORTRAIT                    ([[UIScreen mainScreen] bounds].size.height) + STATUSBAR_HEIGHT

@implementation CUIActionSheet



- (void)showInView:(UIView *)view
{
    CGFloat _y = APPFRAME_HEIGHT_PORTRAIT - _height;

    UIViewController *vc = [self topViewController];
    
    // Background to block
    self.blockBackground = [[UIView alloc] initWithFrame:vc.view.frame];
    self.blockBackground.backgroundColor = [UIColor blackColor];
    self.blockBackground.alpha = 0;
    
    // self view
    self.hidden = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, APPFRAME_HEIGHT_PORTRAIT, self.width, _height);
    
    // show animation
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = CGRectMake(0, _y, self.width, self.height);
                         self.blockBackground.alpha = 0.4;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    // add blocker view and pop into `top most` VC
    [vc.view addSubview:self.blockBackground];
    [vc.view addSubview:self];

}

- (void)dismissView
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                          self.frame = CGRectMake(0, APPFRAME_HEIGHT_PORTRAIT, self.width,  self.height);
                          self.blockBackground.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [self.blockBackground removeFromSuperview];
                     }];
}

#pragma mark - finding TopView

- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}


@end
