//
//  UIAlertController+Showable.m
//  SingPost
//
//  Created by Le Khanh Vinh on 15/11/16.
//  Copyright © 2016 Codigo. All rights reserved.
//

#import "UIAlertController+Showable.h"
#import "Reachability.h"
#import "UIAlertController+Blocks.h"

@implementation UIAlertController (Showable)

- (void)show
{
    [self presentAnimated:YES completion:nil];
}

- (void)presentAnimated:(BOOL)animated
             completion:(void (^)(void))completion
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootVC != nil) {
        [self presentFromController:rootVC animated:animated completion:completion];
    }
}

- (void)presentFromController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion
{
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *visibleVC = ((UINavigationController *)viewController).visibleViewController;
        [self presentFromController:visibleVC animated:animated completion:completion];
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedVC = ((UITabBarController *)viewController).selectedViewController;
        [self presentFromController:selectedVC animated:animated completion:completion];
    } else {
        [viewController presentViewController:self animated:animated completion:completion];
    }
}

+ (void)openSettingsFromController:(UIViewController *)viewController
                             title:(NSString *) titleString
                           message:(NSString *) messageString

{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleString message:messageString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [viewController dismissViewControllerAnimated:YES completion:nil];
        
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
            
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        
        }
        else{
            bool can = [[UIApplication sharedApplication] canOpenURL:url];
            if(can){
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (BOOL)hasInternetConnectionWarnIfNoConnection:(UIViewController *)viewController shouldWarn: (BOOL)warnIfNoConnection{
    bool hasInternetConnection = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
    
    if (!hasInternetConnection && warnIfNoConnection) {
        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NO_INTERNET_ERROR_TITLE message:NO_INTERNET_ERROR preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:ok];
//         [viewController presentViewController:alert animated:YES completion:nil];
    
        [UIAlertController showAlertInViewController:viewController withTitle:NO_INTERNET_ERROR_TITLE message:NO_INTERNET_ERROR cancelButtonTitle:nil destructiveButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
        
    }
    return hasInternetConnection;
}


@end
