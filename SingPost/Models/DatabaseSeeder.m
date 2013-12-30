//
//  DatabaseSeeder.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "DatabaseSeeder.h"
#import "EntityLocation.h"
#import <SVProgressHUD.h>

@implementation DatabaseSeeder

#define SETTINGS_LOCATIONS_IS_SEEDED @"DB_IS_SEEDED"

+ (void)seedLocationsDataIfRequired
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_LOCATIONS_IS_SEEDED]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [EntityLocation seedLocationsOfType:LOCATION_TYPE_POST_OFFICE onCompletion:^(BOOL success, NSError *error) {
                [EntityLocation seedLocationsOfType:LOCATION_TYPE_SAM onCompletion:^(BOOL success, NSError *error) {
                    [EntityLocation seedLocationsOfType:LOCATION_TYPE_POSTING_BOX onCompletion:^(BOOL success, NSError *error) {
                        [EntityLocation seedLocationsOfType:LOCATION_TYPE_AGENT onCompletion:^(BOOL success, NSError *error) {
                            [EntityLocation seedLocationsOfType:LOCATION_TYPE_POPSTATION onCompletion:^(BOOL success, NSError *error) {
                                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:SETTINGS_LOCATIONS_IS_SEEDED];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                [SVProgressHUD dismiss];
                            }];
                        }];
                    }];
                }];
            }];
        });
    }
}

@end
