//
//  ApiClient.h
//  SingPost
//
//  Created by Edward Soetiono on 8/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <AFNetworking.h>
#import <AFRaptureXMLRequestOperation.h>
#import <RXMLElement.h>

@class Stamp;

@interface ApiClient : AFHTTPClient

typedef void (^ApiClientSuccess)(id responseObject);
typedef void (^ApiClientFailure)(NSError *error);
typedef void (^ApiClientProgressCompletion)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations);

+ (ApiClient *)sharedInstance;

//informations
- (void)getSingpostContentsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getSendReceiveItemsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getPayItemsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getShopItemsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getServicesItemsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getSingPostAppsItemsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getOffersItemsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getSingpostAnnouncementSuccess:(ApiClientSuccess)success failure:(ApiClientFailure)failure;

//calculate postage
- (void)calculateSingaporePostageForFromPostalCode:(NSString *)fromPostalCode andToPostalCode:(NSString *)toPostalCode andWeight:(NSString *)weightInGrams onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)calculateOverseasPostageForCountryCode:(NSString *)countryCode andWeight:(NSString *)weightInGrams andItemTypeCode:(NSString *)itemTypeCode andDeliveryCode:(NSString *)deliveryCode onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;

//postal codes
- (void)findPostalCodeForBuildingNo:(NSString *)buildingNo andStreetName:(NSString *)streetName onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)findPostalCodeForLandmark:(NSString *)landmark onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)findPostalCodeForWindowsDeliveryNo:(NSString *)windowsDeliveryNo andType:(NSString *)type andPostOffice:(NSString *)postOffice onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;

//locations
- (void)getPostOfficeLocationsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getSamLocationsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getPostingBoxLocationsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getPostalAgentLocationsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getSingPostAgentLocationsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getPopStationLocationsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;

- (void)getLocationsUpdatesOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getLocationsUpdatesDetails:(NSArray *)array
                           success:(ApiClientSuccess)success
                           failure:(ApiClientFailure)failure;

//tracking
- (void)getItemTrackingDetailsForTrackingNumber:(NSString *)trackingNumber onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)batchUpdateTrackedItems:(NSArray *)trackedItems onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure withProgressCompletion:(ApiClientProgressCompletion)progressCompletion;

//notifications
- (void)registerAPNSToken:(NSString *)apnsToken onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)subscribeNotificationForTrackingNumber:(NSString *)trackingNumber onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)subscribeNotificationForTrackingNumberArray:(NSArray *)trackingNumberArray onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)unsubscribeNotificationForTrackingNumber:(NSString *)trackingNumber onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)unsubscribeNotificationForTrackingNumberArray:(NSArray *)trackingNumberArray onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;

//philately
- (void)getStampsOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)getImagesOfStamp:(Stamp*)stamp onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;

//misc
- (void)getMaintananceStatusOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;

//feedback
- (void)postFeedbackMessage:(NSString *)message subject:(NSString *)subject onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;

//App update checking
- (void)checkAppUpdateWithAppVer:(NSString *)appVer andOSVer:(NSString *)osVer;

//Ad Banner
-(void) getAdvertisementWithId : (NSString *)locationMasterId Count:(NSString *)count onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
-(void) incrementClickCountWithId: (NSString *)locationId onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;

//Tracking Labeling
- (void) facebookLoginOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void) registerTrackingNunmbers: (NSArray *)numbers WithLabels : (NSArray *)labels TrackDetails : (NSArray *) details onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void) getAllTrackingNunmbersOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
@property (nonatomic) NSString * serverToken;
@property (nonatomic,retain) NSArray * allTrackingItem;
@property (nonatomic,retain) NSString * fbToken;

@property (nonatomic, readonly) BOOL hasRegisteredProfileId;
@property (nonatomic) NSString *notificationProfileID;

@end
