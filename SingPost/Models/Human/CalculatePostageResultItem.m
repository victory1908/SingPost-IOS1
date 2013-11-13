//
//  CalculatePostageResultItem.m
//  SingPost
//
//  Created by Edward Soetiono on 14/11/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CalculatePostageResultItem.h"
#import "ApiClient.h"

@implementation CalculatePostageResultItem

+ (CalculatePostageResultItem *)itemFromXMLElement:(RXMLElement *)el
{
    CalculatePostageResultItem *item = [[CalculatePostageResultItem alloc] init];
    [item setDeliveryServiceName:[el child:@"DeliveryServiceName"].text];
    [item setNetPostageCharges:[el child:@"NetPostageCharges"].text];
    [item setDeliveryTime:[el child:@"DeliveryTime"].text];
    return item;
}

+ (void)API_calculateOverseasPostageForCountryCode:(NSString *)countryCode andWeight:(NSString *)weightInGrams andItemTypeCode:(NSString *)itemTypeCode andDeliveryCode:(NSString *)deliveryCode onCompletion:(void(^)(NSArray *items, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] calculateOverseasPostageForCountryCode:countryCode andWeight:weightInGrams andItemTypeCode:itemTypeCode andDeliveryCode:deliveryCode onSuccess:^(RXMLElement *rootXML) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *items = [NSMutableArray array];
            [rootXML iterate:@"OverseasPostalInfoDetailList.OverseasPostalInfoDetail" usingBlock:^(RXMLElement *e) {
                [items addObject:[CalculatePostageResultItem itemFromXMLElement:e]];
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
