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
#import "ProceedViewController.h"

#import "TrackingMainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSFetchedResultsControllerDelegate> {
    ProceedViewController *proceedVC;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, readonly) RootViewController *rootViewController;
@property (nonatomic, readonly) NSDictionary *maintenanceStatuses;
@property (nonatomic, retain) TrackingMainViewController * trackingMainViewController;

@property (nonatomic, assign) BOOL isFirstTime;
@property (nonatomic, assign) BOOL isNewUser;
@property (nonatomic, assign) BOOL isLoginFromSideBar;
@property (nonatomic, assign) BOOL isLoginFromDetailPage;
@property (nonatomic, assign) int isJustForRefresh;
@property (nonatomic, assign) BOOL isPrevAnnouncementNew;
@property (nonatomic, assign) NSString * detailPageTrackNum;

@property (nonatomic, assign) NSString * trackingNumberTappedBeforeSignin;

+ (AppDelegate *)sharedAppDelegate;
- (void)updateMaintananceStatuses;
- (BOOL)hasInternetConnectionWarnIfNoConnection:(BOOL)warnIfNoConnection;

//Google analytics
- (void)trackGoogleAnalyticsWithScreenName:(NSString *)screenName;

- (void)saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

- (void)LoginFacebook;
- (void)firstTimeLoginFacebook;

- (void)GotoTrackingDetail;
- (void)GotoTrackingMain;

- (void)updateTrackItemInfo:(NSString *)num Info:(NSDictionary *)dic Date:(NSDate *)lastModifiedDate;

@end
