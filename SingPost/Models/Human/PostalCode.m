//
//  PostalCode.m
//  SingPost
//
//  Created by Edward Soetiono on 14/11/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "PostalCode.h"
#import "ApiClient.h"

@implementation PostalCode

+ (void)API_findPostalCodeForBuildingNo:(NSString *)buildingNo andStreetName:(NSString *)streetName onCompletion:(void(^)(NSArray *results, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] findPostalCodeForBuildingNo:buildingNo andStreetName:streetName onSuccess:^(RXMLElement *rootXML) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *items = [NSMutableArray array];
            [rootXML iterate:@"PostalCodeByStreetDetailList.PostalCodeByStreetDetail" usingBlock:^(RXMLElement *e) {
                [items addObject:@{@"buildingno": [e child:@"BuildingNo"].text, @"streetname": [e child:@"StreetName"].text, @"postalcode": [e child:@"PostalCode"].text}];
            }];
            
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(items, nil);
                });
            }
        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
    }];
}

+ (void)API_findPostalCodeForLandmark:(NSString *)landmark onCompletion:(void(^)(NSArray *results, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] findPostalCodeForLandmark:landmark onSuccess:^(RXMLElement *rootXML) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block NSMutableArray *items = [NSMutableArray array];
            [rootXML iterate:@"PostalAddressByLandMarkDetailList.PostalAddressByLandMarkDetail" usingBlock:^(RXMLElement *e) {
                [items addObject:@{@"landmark": [e child:@"BuildingName"].text, @"postalcode": [e child:@"PostalCode"].text}];
            }];
            
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(items, nil);
                });
            }
        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
    }];
}

+ (void)API_findPostalCodeForWindowsDeliveryNo:(NSString *)windowsDeliveryNo andType:(NSString *)type andPostOffice:(NSString *)postOffice onCompletion:(void(^)(NSArray *results, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] findPostalCodeForWindowsDeliveryNo:windowsDeliveryNo andType:type andPostOffice:postOffice onSuccess:^(RXMLElement *rootXML) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *items = [NSMutableArray array];
            [rootXML iterate:@"PostalCodeByPOBoxDetailList.PostalCodeByPOBoxDetail" usingBlock:^(RXMLElement *e) {
                [items addObject:@{@"postoffice": [e child:@"PostOffice"].text, @"postalcode": [e child:@"PostalCode"].text}];
            }];
            
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(items, nil);
                });
            }
        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
    }];
}

@end
