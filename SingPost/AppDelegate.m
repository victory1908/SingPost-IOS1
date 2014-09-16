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
#import "AnnouncementViewController.h"
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
    [DatabaseSeeder seedLocationsDataIfRequired];
    
    [Crashlytics startWithAPIKey:@"fb5017e08feeb7069b1c5d7b664775e80e3e30da"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    [self.window setRootViewController:_rootViewController];
    [self.window makeKeyAndVisible];
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification)
        [self handleRemoteNotification:remoteNotification shouldPrompt:NO];
    
    //[FBLoginView class];
    //Facebook
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
    
    return YES;
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self hasInternetConnectionWarnIfNoConnection:YES];
    [self updateMaintananceStatuses];
    [self checkAppAndOSVersion];
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

- (void)setupGoogleAnalytics {
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    [GAI sharedInstance].dispatchInterval = 15;
    [[GAI sharedInstance] trackerWithTrackingId:GAI_ID];
    [[GAI sharedInstance] trackerWithTrackingId:GAI_SINGPOST_ID];
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


- (void)goToAnnouncementView
{
    if ([self.rootViewController isSideBarVisible])
        [self.rootViewController toggleSideBarVisiblity];
    
    AnnouncementViewController *announcementViewController = [[AnnouncementViewController alloc] initWithNibName:nil bundle:nil];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:announcementViewController];
    
    
}

#pragma mark - Facebook

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // Note this handler block should be the exact same as   handler passed to any open calls.
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
     }];
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        //[self userLoggedIn];
        [self.trackingMainViewController refreshTableView];
        
        
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // Success! Include your code to handle the results here
                NSLog(@"user info: %@", result);
                
                [ApiClient sharedInstance].fbToken = [FBSession.activeSession.accessTokenData accessToken];
                
                [[ApiClient sharedInstance] facebookLoginOnSuccess:^(id responseObject)
                 {
                     NSLog(@"FacebookLogin success");
                     NSString * temp = [[responseObject objectForKey:@"data"] objectForKey:@"server_token"];
                     
                     if(temp != nil && ![temp isKindOfClass:[NSNull class]])
                         [ApiClient sharedInstance].serverToken = temp;
                     
                     
                 } onFailure:^(NSError *error)
                 {
                     
                 }];
            } else {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
            }
        }];
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        //[self userLoggedOut];
        
        [self.trackingMainViewController refreshTableView];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            //[self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                //[self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //[self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}


#pragma mark - APNS

- (void)handleRemoteNotification:(NSDictionary *)payloadInfo shouldPrompt:(BOOL)shouldPrompt
{
    NSDictionary *aps = [payloadInfo objectForKey:@"aps"];
    
    NSString *alert = aps[@"alert"];
    if (alert.length > 0) {
        if (shouldPrompt) {
            [UIAlertView showWithTitle:@"SingPost"
                               message:aps[@"alert"]
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@[@"View"]
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  if (buttonIndex != [alertView cancelButtonIndex]) {
                                      [self goToAnnouncementView];
                                  }
                              }];
        } else {
            [self goToAnnouncementView];
            
        }
        return;
    }
    
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
    
    //UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"deviceToken" message:sanitizedDeviceToken delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //[view show];
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",sanitizedDeviceToken]]];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
    //[self goToAnnouncementView];
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
