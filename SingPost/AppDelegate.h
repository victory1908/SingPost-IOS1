//
//  AppDelegate.h
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, readonly) RootViewController *rootViewController;

+ (AppDelegate *)sharedAppDelegate;
- (BOOL)hasInternetConnectionWarnIfNoConnection:(BOOL)warnIfNoConnection;

@end
