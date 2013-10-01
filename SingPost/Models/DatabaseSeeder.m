//
//  DatabaseSeeder.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "DatabaseSeeder.h"
#import "EntityLocation.h"
#import <CHCSVParser.h>
#import <SVProgressHUD.h>

@implementation DatabaseSeeder

#define SETTINGS_DB_IS_SEEDED @"DB_IS_SEEDED"

+ (void)seedIfRequired
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_DB_IS_SEEDED]) {
        [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
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
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:SETTINGS_DB_IS_SEEDED];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                [SVProgressHUD dismiss];
            }];
        });
    }
}

@end
