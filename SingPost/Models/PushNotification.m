
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

@end
