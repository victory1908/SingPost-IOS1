//
//  PushNotification.h
//  SingPost
//
//  Created by Edward Soetiono on 1/12/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushNotification : NSObject

+ (void)API_registerAPNSToken:(NSString *)apnsToken onCompletion:(void(^)(BOOL success, NSError *error))completionBlock;
+ (void)API_subscribeNotificationForTrackingNumber:(NSString *)trackingNumber onCompletion:(void(^)(BOOL success, NSError *error))completionBlock;
+ (void)API_unsubscribeNotificationForTrackingNumber:(NSString *)trackingNumber onCompletion:(void(^)(BOOL success, NSError *error))completionBlock;

@end
