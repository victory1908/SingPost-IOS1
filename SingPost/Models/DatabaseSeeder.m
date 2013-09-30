//
//  DatabaseSeeder.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "DatabaseSeeder.h"
#import "PostingBox.h"
#import "PostOffice.h"
#import "Sam.h"
#import <CHCSVParser.h>
#import <SVProgressHUD.h>

@implementation DatabaseSeeder

#define SETTINGS_DB_IS_SEEDED @"DB_IS_SEEDED"

+ (void)seedIfRequired
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_DB_IS_SEEDED]) {
        [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeGradient];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            
            //seed posting boxes
            [PostingBox MR_truncateAllInContext:localContext];
            NSString *csvFile = [[NSBundle bundleForClass:[self class]] pathForResource:@"postingboxes" ofType:@"csv"];
            NSArray *parsedData = [NSArray arrayWithContentsOfCSVFile:csvFile options:CHCSVParserOptionsRecognizesBackslashesAsEscapes];
            
            for (id data in parsedData) {
                PostingBox *postingBox = [PostingBox MR_createInContext:localContext];
                [postingBox updateWithCsvRepresentation:data];
            }
            
            //seed post offices
            [PostOffice MR_truncateAllInContext:localContext];
            csvFile = [[NSBundle bundleForClass:[self class]] pathForResource:@"postoffices" ofType:@"csv"];
            parsedData = [NSArray arrayWithContentsOfCSVFile:csvFile options:CHCSVParserOptionsRecognizesBackslashesAsEscapes];
            
            for (id data in parsedData) {
                PostOffice *postOffice = [PostingBox MR_createInContext:localContext];
                [postOffice updateWithCsvRepresentation:data];
            }
            
            //seed sams
            [Sam MR_truncateAllInContext:localContext];
            csvFile = [[NSBundle bundleForClass:[self class]] pathForResource:@"sams" ofType:@"csv"];
            parsedData = [NSArray arrayWithContentsOfCSVFile:csvFile options:CHCSVParserOptionsRecognizesBackslashesAsEscapes];
            
            for (id data in parsedData) {
                Sam *sam = [Sam MR_createInContext:localContext];
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
