//
//  AppDelegate.h
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedAppDelegate;
- (BOOL)hasInternetConnectionWarnIfNoConnection:(BOOL)warnIfNoConnection;
- (void)toggleSideBarVisiblity;

@end
