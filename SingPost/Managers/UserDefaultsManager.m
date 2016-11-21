//
//  UserDefaultsManager.m
//  SingPost
//
//  Created by Wei Guang Heng on 09/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "UserDefaultsManager.h"

//#define APP_GROUP_ID @"group.sg.codigo.singpost"
#define APP_GROUP_ID @"group.com.SingPost.SingPostMobile"

#define LAST_TRACKING_NUMBER_KEY @"LAST_TRACKING_NUMBER"
#define NOTIFICATION_STATUS_KEY @"NOTIFICATION_STATUS"

@interface UserDefaultsManager()
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@end

@implementation UserDefaultsManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static id __singleton = nil;
    dispatch_once(&pred, ^{ __singleton = [[self alloc] init]; });
    return __singleton;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.userDefaults = [[NSUserDefaults alloc]initWithSuiteName:APP_GROUP_ID];
    }
    return self;
}

- (BOOL)setLastTrackingNumber:(NSString *)trackingNumber {
    [self.userDefaults setObject:trackingNumber forKey:LAST_TRACKING_NUMBER_KEY];
    return [self.userDefaults synchronize];
}

- (NSString *)getLastTrackingNumber {
    return [self.userDefaults objectForKey:LAST_TRACKING_NUMBER_KEY];
}

- (BOOL)setNotificationStatus:(BOOL)status {
    [self.userDefaults setBool:status forKey:NOTIFICATION_STATUS_KEY];
    return [self.userDefaults synchronize];
}

- (BOOL)getNotificationStatus {
    return [self.userDefaults boolForKey:NOTIFICATION_STATUS_KEY];
}

@end
