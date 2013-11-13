//
//  CalculatePostageResultItem.h
//  SingPost
//
//  Created by Edward Soetiono on 14/11/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WEIGHT_G_CODE @"0"
#define WEIGHT_KG_CODE @"1"

#define WEIGHT_G_UNIT @"g"
#define WEIGHT_KG_UNIT @"kg"

@interface CalculatePostageResultItem : NSObject

@property (nonatomic) NSString *deliveryServiceName;
@property (nonatomic) NSString *netPostageCharges;
@property (nonatomic) NSString *deliveryTime;

+ (void)API_calculateSingaporePostageForFromPostalCode:(NSString *)fromPostalCode andToPostalCode:(NSString *)toPostalCode andWeight:(NSString *)weightInGrams onCompletion:(void(^)(NSArray *items, NSError *error))completionBlock;

+ (void)API_calculateOverseasPostageForCountryCode:(NSString *)countryCode andWeight:(NSString *)weightInGrams andItemTypeCode:(NSString *)itemTypeCode andDeliveryCode:(NSString *)deliveryCode onCompletion:(void(^)(NSArray *items, NSError *error))completionBlock;

@end
