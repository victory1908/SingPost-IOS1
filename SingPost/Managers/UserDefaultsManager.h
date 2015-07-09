//
//  UserDefaultsManager.h
//  SingPost
//
//  Created by Wei Guang Heng on 09/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)setLastTrackingNumber:(NSString *)trackingNumber;
- (NSString *)getLastTrackingNumber;

- (BOOL)setNotificationStatus:(BOOL)status;
- (BOOL)getNotificationStatus;

@end
