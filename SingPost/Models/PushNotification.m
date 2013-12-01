
//
//  PushNotification.m
//  SingPost
//
//  Created by Edward Soetiono on 1/12/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "PushNotification.h"
#import "ApiClient.h"

@implementation PushNotification

+ (void)API_registerAPNSToken:(NSString *)apnsToken onCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] registerAPNSToken:apnsToken onSuccess:^(RXMLElement *rootXML) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[ApiClient sharedInstance] setNotificationProfileID:[rootXML child:@"ProfileID"].text];
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(YES, nil);
                });
            }
        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error);
            });
        }
    }];
}

+ (void)API_subscribeNotificationForTrackingNumber:(NSString *)trackingNumber onCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    if ([[ApiClient sharedInstance] hasRegisteredProfileId]) {
        [[ApiClient sharedInstance] subscribeNotificationForTrackingNumber:trackingNumber onSuccess:^(RXMLElement *rootXML) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(YES, nil);
                    });
                }
            });
        } onFailure:^(NSError *error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error);
                });
            }
        }];
    }
    else {
        if (completionBlock) {
            completionBlock(NO, [NSError errorWithDomain:ERROR_DOMAIN code:1 userInfo:@{NSLocalizedDescriptionKey: @"No registered profile ID"}]);
        }
    }
}

+ (void)API_unsubscribeNotificationForTrackingNumber:(NSString *)trackingNumber onCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    if ([[ApiClient sharedInstance] hasRegisteredProfileId]) {
        [[ApiClient sharedInstance] unsubscribeNotificationForTrackingNumber:trackingNumber onSuccess:^(RXMLElement *rootXML) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(YES, nil);
                    });
                }
            });
        } onFailure:^(NSError *error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error);
                });
            }
        }];
    }
    else {
        if (completionBlock) {
            completionBlock(NO, [NSError errorWithDomain:ERROR_DOMAIN code:1 userInfo:@{NSLocalizedDescriptionKey: @"No registered profile ID"}]);
        }
    }
}

@end
