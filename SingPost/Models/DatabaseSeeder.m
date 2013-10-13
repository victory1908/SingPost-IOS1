//
//  DatabaseSeeder.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "DatabaseSeeder.h"
#import "EntityLocation.h"
#import "Stamp.h"
#import "NSDate+Extensions.h"
#import <CHCSVParser.h>
#import <SVProgressHUD.h>

@implementation DatabaseSeeder

#define SETTINGS_LOCATIONS_IS_SEEDED @"DB_IS_SEEDED"
#define SETTINGS_STAMPS_IS_SEEDED @"STAMPS_IS_SEEDED"

+ (void)seedLocationsDataIfRequired
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_LOCATIONS_IS_SEEDED]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            
            [EntityLocation MR_truncateAllInContext:localContext];
            
            //seed posting boxes
            NSString *csvFile = [[NSBundle bundleForClass:[self class]] pathForResource:@"postingboxes" ofType:@"csv"];
            NSArray *parsedData = [NSArray arrayWithContentsOfCSVFile:csvFile options:CHCSVParserOptionsSanitizesFields];
            
            for (id data in parsedData) {
                EntityLocation *postingBox = [EntityLocation MR_createInContext:localContext];
                [postingBox updateWithCsvRepresentation:data];
            }
            
            //seed post offices
            csvFile = [[NSBundle bundleForClass:[self class]] pathForResource:@"postoffices" ofType:@"csv"];
            parsedData = [NSArray arrayWithContentsOfCSVFile:csvFile options:CHCSVParserOptionsSanitizesFields];
            
            for (id data in parsedData) {
                EntityLocation *postOffice = [EntityLocation MR_createInContext:localContext];
                [postOffice updateWithCsvRepresentation:data];
            }
            
            //seed sams
            csvFile = [[NSBundle bundleForClass:[self class]] pathForResource:@"sams" ofType:@"csv"];
            parsedData = [NSArray arrayWithContentsOfCSVFile:csvFile options:CHCSVParserOptionsSanitizesFields];
            
            for (id data in parsedData) {
                EntityLocation *sam = [EntityLocation MR_createInContext:localContext];
                [sam updateWithCsvRepresentation:data];
            }
            
            [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                if (!error) {
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:SETTINGS_LOCATIONS_IS_SEEDED];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                [SVProgressHUD dismiss];
            }];
        });
    }
}

//FIXME: temporary, to remove after api is implemented
+ (void)seedStampsDataIfRequired
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_STAMPS_IS_SEEDED]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            
            [Stamp MR_truncateAllInContext:localContext];
            
            Stamp *stamp1 = [Stamp MR_createInContext:localContext];
            stamp1.title = @"Marina Bay Skyline";
            stamp1.year = @"2013";
            stamp1.issueDate = [NSDate dateWithDaysBeforeNow:20];
            stamp1.image = @"sample_stamp01";
            stamp1.orderingValue = 1;
            
            Stamp *stamp2 = [Stamp MR_createInContext:localContext];
            stamp2.title = @"Definitives - Pond Life 2013";
            stamp2.year = @"2013";
            stamp2.issueDate = [NSDate dateWithDaysBeforeNow:30];
            stamp2.image = @"sample_stamp02";
            stamp2.orderingValue = 2;
            
            Stamp *stamp3 = [Stamp MR_createInContext:localContext];
            stamp3.title = @"Marina Bay Skyline B";
            stamp3.year = @"2013";
            stamp3.image = @"sample_stamp01";
            stamp3.issueDate = [NSDate dateWithDaysBeforeNow:40];
            stamp3.orderingValue = 3;
            
            Stamp *stamp4 = [Stamp MR_createInContext:localContext];
            stamp4.title = @"Definitives - Pond Life 2013 B";
            stamp4.year = @"2013";
            stamp4.image = @"sample_stamp02";
            stamp4.issueDate = [NSDate dateWithDaysBeforeNow:40];
            stamp4.orderingValue = 4;
            
            [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                if (!error) {
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:SETTINGS_STAMPS_IS_SEEDED];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                [SVProgressHUD dismiss];
            }];
        });
    }
}

@end
