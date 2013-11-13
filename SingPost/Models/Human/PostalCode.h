//
//  PostalCode.h
//  SingPost
//
//  Created by Edward Soetiono on 14/11/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostalCode : NSObject

+ (void)API_findPostalCodeForBuildingNo:(NSString *)buildingNo andStreetName:(NSString *)streetName onCompletion:(void(^)(NSString *postalCode, NSError *error))completionBlock;
+ (void)API_findPostalCodeForLandmark:(NSString *)landmark onCompletion:(void(^)(NSString *postalCode, NSError *error))completionBlock;
+ (void)API_findPostalCodeForWindowsDeliveryNo:(NSString *)windowsDeliveryNo andType:(NSString *)type andPostOffice:(NSString *)postOffice onCompletion:(void(^)(NSString *postalCode, NSError *error))completionBlock;

@end
