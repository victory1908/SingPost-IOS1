//
//  ApiClient.h/Users/edwardsoetiono/Desktop/SingPost/SingPost/ViewControllers/Sidebar/SidebarMenuViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 8/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <AFNetworking.h>
#import <AFRaptureXMLRequestOperation.h>
#import <RXMLElement.h>

@interface ApiClient : AFHTTPClient

typedef void (^ApiClientSuccess)(id responseObject);
typedef void (^ApiClientFailure)(NSError *error);
typedef void (^ApiClientProgressCompletion)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations);

+ (ApiClient *)sharedInstance;

- (void)getSingpostServicesArticlesOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;

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

//tracking
- (void)getItemTrackingDetailsForTrackingNumber:(NSString *)trackingNumber onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)batchUpdateTrackedItems:(NSArray *)trackedItems onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure withProgressCompletion:(ApiClientProgressCompletion)progressCompletion;

//notifications
- (void)registerAPNSToken:(NSString *)apnsToken onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)subscribeNotificationForTrackingNumber:(NSString *)trackingNumber onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;
- (void)unsubscribeNotificationForTrackingNumber:(NSString *)trackingNumber onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;

@property (nonatomic, readonly) BOOL hasRegisteredProfileId;
@property (nonatomic) NSString *notificationProfileID;
@property (nonatomic) NSMutableSet *failedNotificationTrackingNumbers;

@end
