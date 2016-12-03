//
//  UIAlertController+Showable.h
//  SingPost
//
//  Created by Le Khanh Vinh on 15/11/16.
//  Copyright © 2016 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Showable)

- (void)show;

- (void)presentAnimated:(BOOL)animated
             completion:(void (^)(void))completion;

- (void)presentFromController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion;

+ (void)openSettingsFromController:(UIViewController *)viewController
                             title:(NSString *) titleString
                           message:(NSString *) messageString;

+ (BOOL)hasInternetConnectionWarnIfNoConnection:(UIViewController *)viewController shouldWarn: (BOOL)warnIfNoConnection;


@end
