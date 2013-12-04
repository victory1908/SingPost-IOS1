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
#import "StampImage.h"
#import "Offer.h"
#import "OfferImage.h"
#import "NSDate+Extensions.h"
#import <CHCSVParser.h>
#import <SVProgressHUD.h>

@implementation DatabaseSeeder

#define SETTINGS_LOCATIONS_IS_SEEDED @"DB_IS_SEEDED"
#define SETTINGS_STAMPS_IS_SEEDED @"STAMPS_IS_SEEDED"
#define SETTINGS_OFFERS_IS_SEEDED @"OFFERS_IS_SEEDED"

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
+ (void)seedOffersDataIfRequired
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_OFFERS_IS_SEEDED]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            
            [Offer MR_truncateAllInContext:localContext];
            
            Offer *offer1 = [Offer MR_createInContext:localContext];
            offer1.title = @"Offer 1";
            offer1.year = @"2013";
            offer1.details = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
            offer1.offerDate = [NSDate dateWithDaysBeforeNow:20];
            offer1.orderingValue = 1;
            
            OfferImage *offer1Image1 = [OfferImage MR_createInContext:localContext];
            [offer1Image1 setImage:@"sample_stamp01"];
            OfferImage *offer1Image2 = [OfferImage MR_createInContext:localContext];
            [offer1Image2 setImage:@"sample_stamp02"];
            [offer1 setImages:[NSOrderedSet orderedSetWithArray:@[offer1Image1, offer1Image2]]];
            
            Offer *offer2 = [Offer MR_createInContext:localContext];
            offer2.title = @"Offer 2";
            offer2.year = @"2013";
            offer2.details = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
            offer2.offerDate = [NSDate dateWithDaysBeforeNow:30];
            offer2.orderingValue = 2;
            
            OfferImage *offer2Image1 = [OfferImage MR_createInContext:localContext];
            [offer2Image1 setImage:@"sample_stamp02"];
            [offer2 setImages:[NSOrderedSet orderedSetWithArray:@[offer2Image1]]];
            
            [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                if (!error) {
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:SETTINGS_OFFERS_IS_SEEDED];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                [SVProgressHUD dismiss];
            }];
        });
    }
}

@end
