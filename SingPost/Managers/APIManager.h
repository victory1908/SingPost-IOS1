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

+ (instancetype)sharedInstance;

- (void)reportAPIIssueURL:(NSString *)url payload:(NSString *)payload message:(NSString *)message;

//Tracking numbers
- (void)getTrackingNumberDetails:(NSString *)trackingNumber
                       completed:(void (^)(Parcel *parcel, NSError *error))completed;

//calculate postage
- (void)calculateSingaporePostageForFromPostalCode:(NSString *)fromPostalCode andToPostalCode:(NSString *)toPostalCode andWeight:(NSString *)weightInGrams onSuccess:(APIManagerSuccess)success onFailure:(APIManagerFailure)failure;
- (void)calculateOverseasPostageForCountryCode:(NSString *)countryCode andWeight:(NSString *)weightInGrams andItemTypeCode:(NSString *)itemTypeCode andDeliveryCode:(NSString *)deliveryCode onSuccess:(APIManagerSuccess)success onFailure:(APIManagerFailure)failure;

@end
