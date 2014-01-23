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
@property (nonatomic, readonly) NSDictionary *maintenanceStatuses;

+ (AppDelegate *)sharedAppDelegate;
- (BOOL)hasInternetConnectionWarnIfNoConnection:(BOOL)warnIfNoConnection;

//Google analytics
- (void)trackGoogleAnalyticsWithScreenName:(NSString *)screenName;

- (void)saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion;

@end
