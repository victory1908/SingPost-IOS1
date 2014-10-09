//
//  AppDelegate.h
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "TrackingMainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, readonly) RootViewController *rootViewController;
@property (nonatomic, readonly) NSDictionary *maintenanceStatuses;
@property (nonatomic) NSFetchedResultsController *activeItemsFetchedResultsController;
@property (nonatomic, retain) TrackingMainViewController * trackingMainViewController;

@property (nonatomic, assign) BOOL isFirstTime;
@property (nonatomic, assign) BOOL isLoginFromSideBar;

+ (AppDelegate *)sharedAppDelegate;
- (void)updateMaintananceStatuses;
- (BOOL)hasInternetConnectionWarnIfNoConnection:(BOOL)warnIfNoConnection;

//Google analytics
- (void)trackGoogleAnalyticsWithScreenName:(NSString *)screenName;

- (void)saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

- (void)LoginFacebook;
@end
