//
//  AppDelegate.m
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <Reachability.h>
#import <UIAlertView+Blocks.h>
#import <SVProgressHUD.h>
#import "DatabaseSeeder.h"
#import "PushNotification.h"
#import "TrackedItem.h"
#import "ApiClient.h"
#import "TrackingMainViewController.h"
#import "TrackingDetailsViewController.h"
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [self setupGoogleAnalytics];
    [MagicalRecord setupAutoMigratingCoreDataStack];
    //[DatabaseSeeder seedLocationsDataIfRequired];
    
    [Crashlytics startWithAPIKey:@"fb5017e08feeb7069b1c5d7b664775e80e3e30da"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    [self.window setRootViewController:_rootViewController];
    [self.window makeKeyAndVisible];
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification)
        [self handleRemoteNotification:remoteNotification shouldPrompt:NO];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self hasInternetConnectionWarnIfNoConnection:YES];
    [self updateMaintananceStatuses];
    [self checkAppAndOSVersion];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

- (void)setupGoogleAnalytics {
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    [GAI sharedInstance].dispatchInterval = 15;
    [[GAI sharedInstance] trackerWithTrackingId:GAI_ID];
    //[[GAI sharedInstance] trackerWithTrackingId:GAI_SINGPOST_ID];
}

#pragma mark - Maintanance

- (void)updateMaintananceStatuses
{
    [[ApiClient sharedInstance] getMaintananceStatusOnSuccess:^(id responseJSON) {
        _maintenanceStatuses = responseJSON[@"root"];
        [_rootViewController updateMaintananceStatusUIs];
    } onFailure:^(NSError *error) {
        _maintenanceStatuses = nil;
    }];
}

#pragma mark - Utilities

- (BOOL)hasInternetConnectionWarnIfNoConnection:(BOOL)warnIfNoConnection
{
    BOOL hasInternetConnection = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
    if (!hasInternetConnection && warnIfNoConnection) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NO_INTERNET_ERROR_TITLE message:NO_INTERNET_ERROR delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    
    return hasInternetConnection;
}

- (void)checkAppAndOSVersion {
    NSString *deviceOS = [[UIDevice currentDevice] systemVersion];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    [[ApiClient sharedInstance]checkAppUpdateWithAppVer:appVersion andOSVer:deviceOS];
}

#pragma mark - Tracking

- (void)goToTrackingDetailsPageForTrackingNumber:(NSString *)trackingNumber
{
    if ([self.rootViewController isSideBarVisible])
        [self.rootViewController toggleSideBarVisiblity];
    
    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
    trackingMainViewController.isPushNotification = YES;
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:trackingMainViewController];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [trackingMainViewController addTrackingNumber:trackingNumber];
    });
}

#pragma mark - APNS

- (void)handleRemoteNotification:(NSDictionary *)payloadInfo shouldPrompt:(BOOL)shouldPrompt
{
    NSDictionary *aps = [payloadInfo objectForKey:@"aps"];
    NSDictionary *data = [payloadInfo objectForKey:@"data"];
    NSString *trackingNumber = data[@"i"];
    if (trackingNumber.length > 0) {
        //it's a tracking item apns
        if (shouldPrompt) {
            [UIAlertView showWithTitle:@"SingPost"
                               message:aps[@"alert"]
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@[@"View"]
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  if (buttonIndex != [alertView cancelButtonIndex]) {
                                      [self goToTrackingDetailsPageForTrackingNumber:trackingNumber];
                                  }
                              }];
        }
        else {
            [self goToTrackingDetailsPageForTrackingNumber:trackingNumber];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleRemoteNotification:userInfo shouldPrompt:([application applicationState] == UIApplicationStateActive)];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"device push token %@",[deviceToken description]);
    NSString *sanitizedDeviceToken = [[[[deviceToken description]
                                        stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                       stringByReplacingOccurrencesOfString: @">" withString: @""]
                                      stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"sanitized device token: %@", sanitizedDeviceToken);
    [PushNotificationManager API_registerAPNSToken:sanitizedDeviceToken onCompletion:^(BOOL success, NSError *error) {
        //do nothing
    }];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

#pragma mark - Google Analytics

- (void)trackGoogleAnalyticsWithScreenName:(NSString *)screenName {
    [[[GAI sharedInstance] trackerWithTrackingId:GAI_ID] set:kGAIScreenName value:screenName];
    [[[GAI sharedInstance] trackerWithTrackingId:GAI_ID] send:[[GAIDictionaryBuilder createAppView] build]];
    
    [[[GAI sharedInstance] trackerWithTrackingId:GAI_SINGPOST_ID] set:kGAIScreenName value:screenName];
    [[[GAI sharedInstance] trackerWithTrackingId:GAI_SINGPOST_ID] send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - Core data

- (void)saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion
{
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
        if(!success)
            DLog(@"%@", error);
        if (completion)
            completion(success, error);
    }];
}

@end
