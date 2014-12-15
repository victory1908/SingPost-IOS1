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
#import "ProceedViewController.h"
#import "DeliveryStatus.h"
#import "CustomIOS7AlertView.h"
#import "UIFont+SingPost.h"


@implementation AppDelegate
@synthesize activeItemsFetchedResultsController = _activeItemsFetchedResultsController;
@synthesize isLoginFromSideBar;
@synthesize isLoginFromDetailPage;
@synthesize detailPageTrackNum;
@synthesize trackingNumberTappedBeforeSignin;


+ (AppDelegate *)sharedAppDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.applicationIconBadgeNumber = 0;
    
    //IOS 8 broke the registerForRemoteNotifications, as Apple always does.
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // use registerUserNotificationSettings
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    } else {
        // use registerForRemoteNotifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    
    
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
    
    //[self performSelector:@selector(test1) withObject:nil afterDelay:16.0f];
    
    self.isFirstTime = true;
    self.isJustForRefresh = 0;
    return YES;
}

- (void)test1 {
    
    return;
    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
    trackingMainViewController.isPushNotification = YES;
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:trackingMainViewController];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [trackingMainViewController addTrackingNumber:@"XZ00000043674"];
    });
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self hasInternetConnectionWarnIfNoConnection:YES];
    [self updateMaintananceStatuses];
    [self checkAppAndOSVersion];
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
    
    if(self.isFirstTime) {
        self.isFirstTime = false;
    } else {
        if([AppDelegate sharedAppDelegate].rootViewController.activeViewController == self.trackingMainViewController) {
            [self.trackingMainViewController syncLabelsWithTrackingNumbers];
        } else {
            if(!isLoginFromSideBar)
             [self getAllLabel];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

- (void)setupGoogleAnalytics {
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    [GAI sharedInstance].dispatchInterval = 15;
    [[GAI sharedInstance] trackerWithTrackingId:GAI_ID];
    [[GAI sharedInstance] trackerWithTrackingId:GAI_SINGPOST_ID];
    
    [[[GAI sharedInstance] defaultTracker] setAllowIDFACollection:YES];
    
    
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
    trackingMainViewController.isFirstTimeUser = self.isNewUser;
    self.isNewUser = false;
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
         AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
         
          appDelegate.isLoginFromSideBar = YES;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
     }];
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)LoginFacebook {
    [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
    
    [[ApiClient sharedInstance] facebookLoginOnSuccess:^(id responseObject)
     {
         NSLog(@"FacebookLogin success");
         
         int status = [[responseObject objectForKey:@"status"] intValue];
         
         if(status != 200) {
             UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Log in failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             
             [alert show];
             
             return;
         }
        
         NSString * temp = [[responseObject objectForKey:@"data"] objectForKey:@"server_token"];
         
         if(temp != nil && ![temp isKindOfClass:[NSNull class]])
             [ApiClient sharedInstance].serverToken = temp;
         
         NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
         NSString * lastUser = [defaults valueForKey:@"LAST_USER"];
         
         //If is not the lastuser
         if(![[ApiClient sharedInstance].fbID isEqualToString:lastUser] && lastUser != nil) {
             //1.Unsubscribe all lastuser's tracking ID
             //2.Clear local database
             [self unSubscribeAllActiveItem];
             
         }
         
         [defaults setValue:[ApiClient sharedInstance].fbID forKey:@"LAST_USER"];
         [defaults synchronize];
         
         [self getAllLabel];
         
         [self.rootViewController checkSignStatus];
         
         /*if(proceedVC != nil) {
             [[AppDelegate sharedAppDelegate].rootViewController cPopViewController ];
         }*/
         
         
     } onFailure:^(NSError *error)
     {
         [self.rootViewController checkSignStatus];
         [SVProgressHUD dismiss];
     }];


}

- (void)firstTimeLoginFacebook {
    [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
    
    [[ApiClient sharedInstance] facebookLoginOnSuccess:^(id responseObject)
     {
         NSLog(@"FacebookLogin success");
         
         int status = [[responseObject objectForKey:@"status"] intValue];
         
         if(status != 200) {
             UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Log in failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             
             [alert show];
             
             return;
         }
         
         NSString * temp = [[responseObject objectForKey:@"data"] objectForKey:@"server_token"];
         
         if(temp != nil && ![temp isKindOfClass:[NSNull class]])
         [ApiClient sharedInstance].serverToken = temp;
         
         NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
         NSString * lastUser = [defaults valueForKey:@"LAST_USER"];
         
         //If is not the lastuser
         if(![[ApiClient sharedInstance].fbID isEqualToString:lastUser] && lastUser != nil) {
             //1.Unsubscribe all lastuser's tracking ID
             //2.Clear local database
             [self unSubscribeAllActiveItem];
             
         }
         
         [defaults setValue:[ApiClient sharedInstance].fbID forKey:@"LAST_USER"];
         [defaults synchronize];
         
         [self getAllLabel];
         
         [self.rootViewController checkSignStatus];
         
         /*if(proceedVC != nil) {
          [[AppDelegate sharedAppDelegate].rootViewController cPopViewController ];
          }*/
         
         
     } onFailure:^(NSError *error)
     {
         [self.rootViewController checkSignStatus];
         [SVProgressHUD dismiss];
     }];
    
    
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self.trackingMainViewController refreshTableView];
        
        
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if (!error) {
                // Success! Include your code to handle the results here
                
                [ApiClient sharedInstance].fbToken = [FBSession.activeSession.accessTokenData accessToken];
                [ApiClient sharedInstance].fbID = user.objectID;
                
                [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
                [[ApiClient sharedInstance] isFirstTime:^(id responseObject){
                    int i = [[[responseObject objectForKey:@"data"] objectForKey:@"first_timer"] intValue];
                    
                    //New User
                    if(i == 1) {
                        self.isNewUser = true;
                        if ([self.rootViewController isSideBarVisible])
                            [self.rootViewController toggleSideBarVisiblity];
                        
                        proceedVC = [[ProceedViewController alloc] initWithNibName:nil bundle:nil];
                        [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:proceedVC];
                        
                        [SVProgressHUD dismiss];
                        return;
                    }
                    //Existing User
                    else {
                        [self LoginFacebook];
                    }
                    
                }onFailure:^(NSError *error)
                 {
                     [self.rootViewController checkSignStatus];
                     [SVProgressHUD dismiss];
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
        
        [self.rootViewController checkSignStatus];
 
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

- (NSFetchedResultsController *)activeItemsFetchedResultsController
{
    if (!_activeItemsFetchedResultsController) {
        _activeItemsFetchedResultsController = [TrackedItem MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"isActive == 'true'"] sortedBy:TrackedItemAttributes.addedOn ascending:NO delegate:self];
    }
    
    return _activeItemsFetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
}

- (void) unSubscribeAllActiveItem {
    NSArray * trackedArray = [self.activeItemsFetchedResultsController fetchedObjects];
    if ([trackedArray count] == 0)
        return;
    
    [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
    
    NSMutableArray * numberArray = [NSMutableArray array];
    for(TrackedItem *trackedItem in trackedArray){
        [numberArray addObject:trackedItem.trackingNumber];
    }
    
    [PushNotificationManager API_unsubscribeNotificationForTrackingNumberArray:numberArray onCompletion:^(BOOL success, NSError *error) {
        //[TrackedItem MR_truncateAll];
        
        //[SVProgressHUD dismiss];
    }];
}


- (void) getAllLabel {
    [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
    
    [[ApiClient sharedInstance] getAllTrackingNunmbersOnSuccess:^(id responseObject)
     {
         NSLog(@"getAllTrackingNunmbersOnSuccess success");
         
         NSArray * dataArray = (NSArray *)[responseObject objectForKey:@"data"];
         
         if(dataArray == nil) {
            [SVProgressHUD dismiss];
             return;
         }
         
         NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
         [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         
         NSMutableDictionary * tempDic2 = [NSMutableDictionary dictionary];
         
         for(NSDictionary * dic in dataArray) {
             NSString * trackingDetailsStr = [dic objectForKey:@"tracking_details"];
             NSError * e;
             NSDictionary * trackingJson = [NSJSONSerialization JSONObjectWithData: [trackingDetailsStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                           options: NSJSONReadingMutableContainers
                                                                             error: &e];
             NSDictionary * tempDic = [[trackingJson objectForKey:@"ItemsTrackingDetailList"] objectForKey:@"ItemTrackingDetail"];
             if(tempDic == nil)
             
                 tempDic = [trackingJson objectForKey:@"ItemTrackingDetail"];
             
             NSString * trackingNum = [tempDic objectForKey:@"TrackingNumber"];
             
             NSString * str = [dic objectForKey:@"tracking_last_modified"];
             NSDate * lastModifiedDate = [NSDate date];
             
             if(str != nil)
                 lastModifiedDate = [formatter dateFromString:str];
             
             [self updateTrackItemInfo:trackingNum Info:tempDic Date:lastModifiedDate];
             
             
             [tempDic2 setValue:[dic objectForKey:@"label"] forKey:trackingNum];
             
             
         }
         //[SVProgressHUD dismiss];
         
         //Go to tracking list page.
         
         if(isLoginFromDetailPage) {
             [self performSelector:@selector(GotoTrackingDetail) withObject:nil afterDelay:2.0f];
         } else if(isLoginFromSideBar) {
             [self performSelector:@selector(GotoTrackingMain) withObject:nil afterDelay:2.0f];
         } else {
             [SVProgressHUD dismiss];
         }
         
     } onFailure:^(NSError *error)
     {
         [SVProgressHUD dismiss];
     }];
}

- (void) GotoTrackingMain {
    [SVProgressHUD dismiss];
    
    isLoginFromDetailPage = false;
    if ([self.rootViewController isSideBarVisible])
        [self.rootViewController toggleSideBarVisiblity];
    
    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
    trackingMainViewController.isPushNotification = YES;
    trackingMainViewController.isFirstTimeUser = self.isNewUser;
    self.isNewUser = false;
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:trackingMainViewController];
}

- (void) GotoTrackingDetail {
    [SVProgressHUD dismiss];
    
    //isLoginFromSideBar = false;
    if ([self.rootViewController isSideBarVisible])
        [self.rootViewController toggleSideBarVisiblity];
    
    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
    trackingMainViewController.isPushNotification = YES;
    trackingMainViewController.isFirstTimeUser = self.isNewUser;
    self.isNewUser = false;
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:trackingMainViewController];
    
}

- (void) updateTrackItemInfo: (NSString *)num Info : (NSDictionary *)dic Date : (NSDate *)lastModifiedDate{
    //NSManagedObjectContext * context = [NSManagedObjectContext new];
    
    TrackedItem * item = [[TrackedItem MR_findByAttribute:@"trackingNumber" withValue:num] firstObject];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    if(item && ![item isKindOfClass:[NSNull class]]) {
        //return;
        
        if ([item.lastUpdatedOn compare:lastModifiedDate] == NSOrderedDescending) {
            return;
        }
        
        item.originalCountry = [dic objectForKey:@"OriginalCountry"];
        
        NSString * isFound = [dic objectForKey:@"TrackingNumberFound"];
        if(![isFound isKindOfClass:[NSString class]]) {
            item.isFoundValue = [[dic objectForKey:@"TrackingNumberFound"]boolValue]?true:false;
        }
        
        else
            item.isFoundValue = [[dic objectForKey:@"TrackingNumberFound"] isEqualToString:@"true"]?true:false;
        
        item.destinationCountry = [dic objectForKey:@"DestinationCountry"];
        
        
        item.isActive = ([[dic objectForKey:@"TrackingNumberActive"] boolValue] == 1 ? @"true" : @"false");
        
        item.addedOn = [NSDate date];
        item.isRead = false;
        item.lastUpdatedOn = [NSDate date];
        
        NSDictionary * tempDic = [dic objectForKey:@"DeliveryStatusDetails"];
        if(tempDic!= nil && ![tempDic isKindOfClass:[NSString class]]) {
        
        NSArray * statusArray = [[dic objectForKey:@"DeliveryStatusDetails"] objectForKey:@"DeliveryStatusDetail"];
        NSMutableOrderedSet *newStatus = [NSMutableOrderedSet orderedSet];
        if([statusArray isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dic = (NSDictionary *)statusArray;
            [newStatus addObject:[DeliveryStatus createFromDicElement:dic inContext:localContext]];
        } else {
            
            for(NSDictionary * dic in statusArray) {
                [newStatus addObject:[DeliveryStatus createFromDicElement:dic inContext:localContext]];
            }
        }
        
        
        for(DeliveryStatus * oldStatus in item.deliveryStatuses) {
            [oldStatus MR_deleteEntity];
        }
        
        item.deliveryStatuses = newStatus;
            
        }
        
    } else {
        item = [TrackedItem MR_createEntity];
        item.trackingNumber = num;
        item.originalCountry = [dic objectForKey:@"OriginalCountry"];
        NSString * isFound = [dic objectForKey:@"TrackingNumberFound"];
        if(![isFound isKindOfClass:[NSString class]]) {
            item.isFoundValue = [[dic objectForKey:@"TrackingNumberFound"]boolValue]?true:false;
        }
        
        else
            item.isFoundValue = [[dic objectForKey:@"TrackingNumberFound"] isEqualToString:@"true"]?true:false;
        item.destinationCountry = [dic objectForKey:@"DestinationCountry"];
        item.isActive = ([[dic objectForKey:@"TrackingNumberActive"] boolValue] == 1 ? @"true" : @"false");
        
        item.addedOn = [NSDate date];
        item.isRead = false;
        item.lastUpdatedOn = [NSDate date];
        
        NSDictionary * tempDic = [dic objectForKey:@"DeliveryStatusDetails"];
        if(tempDic!= nil && ![tempDic isKindOfClass:[NSString class]]) {
        
        NSArray * statusArray = [[dic objectForKey:@"DeliveryStatusDetails"] objectForKey:@"DeliveryStatusDetail"];
        
        
        NSMutableOrderedSet *newStatus = [NSMutableOrderedSet orderedSet];
        if([statusArray isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dic = (NSDictionary *)statusArray;
            [newStatus addObject:[DeliveryStatus createFromDicElement:dic inContext:localContext]];
        } else {
        
            for(NSDictionary * dic in statusArray) {
                [newStatus addObject:[DeliveryStatus createFromDicElement:dic inContext:localContext]];
            }
        }
            
        
        
        item.deliveryStatuses = newStatus;
            
        }
    }
    
    [localContext MR_saveToPersistentStoreAndWait];
    
    
}


#pragma mark - APNS

- (void)handleRemoteNotification:(NSDictionary *)payloadInfo shouldPrompt:(BOOL)shouldPrompt
{
    NSDictionary *aps = [payloadInfo objectForKey:@"aps"];
    
    NSDictionary *data = [payloadInfo objectForKey:@"data"];
    NSString *trackingNumber = data[@"i"];
    if (trackingNumber.length > 0) {
        //it's a tracking item apns
        [self getAllLabel];
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
        
        return;
    }
    
    
    
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
        /*if(success) {
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"Success" message:sanitizedDeviceToken delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [view show];
        } else {
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"Failed" message:sanitizedDeviceToken delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [view show];
        }*/
    }];
    
    /*UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"deviceToken" message:sanitizedDeviceToken delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [view show];*/
    
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
