//
//  APIManager.h
//  SingPost
//
//  Created by Wei Guang Heng on 07/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parcel.h"
#import "RXMLElement.h"

@interface APIManager : NSObject

typedef void (^APIManagerSuccess)(id responseObject);
typedef void (^APIManagerFailure)(NSError *error);

@property (nonatomic) NSString * serverToken;
@property (nonatomic,retain) RLMResults * allTrackingItem;
@property (nonatomic,retain) NSString * fbToken;
@property (nonatomic,retain) NSString * fbID;

@property (nonatomic, readonly) BOOL hasRegisteredProfileId;
@property (nonatomic) NSString *notificationProfileID;

+ (instancetype)sharedInstance;

- (void)reportAPIIssueURL:(NSString *)url payload:(NSString *)payload message:(NSString *)message;

//Tracking numbers
- (void)getTrackingNumberDetails:(NSString *)trackingNumber
                       completed:(void (^)(Parcel *parcel, NSError *error))completed;

//calculate postage
- (void)calculateSingaporePostageForFromPostalCode:(NSString *)fromPostalCode andToPostalCode:(NSString *)toPostalCode andWeight:(NSString *)weightInGrams onSuccess:(APIManagerSuccess)success onFailure:(APIManagerFailure)failure;
- (void)calculateOverseasPostageForCountryCode:(NSString *)countryCode andWeight:(NSString *)weightInGrams andItemTypeCode:(NSString *)itemTypeCode andDeliveryCode:(NSString *)deliveryCode onSuccess:(APIManagerSuccess)success onFailure:(APIManagerFailure)failure;

//postal codes
- (void)findPostalCodeForBuildingNo:(NSString *)buildingNo andStreetName:(NSString *)streetName onSuccess:(APIManagerSuccess)success onFailure:(APIManagerFailure)failure;
- (void)findPostalCodeForLandmark:(NSString *)landmark onSuccess:(APIManagerSuccess)success onFailure:(APIManagerFailure)failure;
- (void)findPostalCodeForWindowsDeliveryNo:(NSString *)windowsDeliveryNo andType:(NSString *)type andPostOffice:(NSString *)postOffice onSuccess:(APIManagerSuccess)success onFailure:(APIManagerFailure)failure;


//notifications
- (void)registerAPNSToken:(NSString *)apnsToken onSuccess:(APIManagerSuccess)success onFailure:(APIManagerFailure)failure;
- (void)subscribeNotificationForTrackingNumber:(NSString *)trackingNumber onSuccess:(APIManagerSuccess)success onFailure:(APIManagerFailure)failure;
- (void)subscribeNotificationForTrackingNumberArray:(NSArray *)trackingNumberArray onSuccess:(APIManagerSuccess)success onFailure:(APIManagerFailure)failure;
- (void)unsubscribeNotificationForTrackingNumber:(NSString *)trackingNumber onSuccess:(APIManagerSuccess)success onFailure:(APIManagerFailure)failure;
- (void)unsubscribeNotificationForTrackingNumberArray:(NSArray *)trackingNumberArray onSuccess:(APIManagerSuccess)success onFailure:(APIManagerFailure)failure;

@end
