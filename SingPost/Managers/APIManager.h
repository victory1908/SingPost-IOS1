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

+ (instancetype)sharedInstance;

//Tracking numbers
- (void)getTrackingNumberDetails:(NSString *)trackingNumber
                       completed:(void (^)(Parcel *parcel, NSError *error))completed;

//Push notifications
- (void)registerAPNSToken:(NSString *)token
                completed:(void (^)(NSError *error))completed;

- (void)subscribeTrackingNumberNotification:(NSString *)trackingNumber
                                  completed:(void (^)(NSError *error))completed;
- (void)unsubscribeTrackingNumberNotification:(NSString *)trackingNumber
                                    completed:(void (^)(NSError *error))completed;

- (void)subscribeActiveTrackingNotifications:(void (^)(NSError *error))completed;
- (void)unsubscribeActiveTrackingNotifications:(void (^)(NSError *error))completed;

@end
