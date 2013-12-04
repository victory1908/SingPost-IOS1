#import "EntityLocation.h"
#import "ApiClient.h"

@interface EntityLocation ()

@end

@implementation EntityLocation

static NSString *LOCATIONS_LOCK = @"LOCATIONS_LOCK";

- (void)updateWithCsvRepresentation:(NSArray *)csv
{
    self.name = csv[0];
    self.type = csv[1];
    self.address = csv[2];
    self.latitude = csv[3];
    self.longitude = csv[4];
    self.notification = csv[5];
    self.mon_opening = csv[6];
    self.mon_closing = csv[7];
    self.tue_opening = csv[8];
    self.tue_closing = csv[9];
    self.wed_opening = csv[10];
    self.wed_closing = csv[11];
    self.thu_opening = csv[12];
    self.thu_closing = csv[13];
    self.fri_opening = csv[14];
    self.fri_closing = csv[15];
    self.sat_opening = csv[16];
    self.sat_closing = csv[17];
    self.sun_opening = csv[18];
    self.sun_closing = csv[19];
    self.ph_opening = csv[20];
    self.ph_closing = csv[21];
    self.services = csv[22];
    self.postingbox = csv[23];
}

- (void)updateWithApiRepresentation:(NSDictionary *)json
{
    self.name = json[@"name"];
    self.type = json[@"type"];
    self.address = json[@"address"];
    self.latitude = json[@"latitude"];
    self.longitude = json[@"longitude"];
    self.notification = json[@"notification"];
    self.mon_opening = json[@"mon_opening_1stcollection_time"];
    self.mon_closing = json[@"mon_closing_2ndcollection_time"];
    self.tue_opening = json[@"tue_opening_1stcollection_time"];
    self.tue_closing = json[@"tue_closing_2ndcollection_time"];
    self.wed_opening = json[@"wed_opening_1stcollection_time"];
    self.wed_closing = json[@"wed_closing_2ndcollection_time"];
    self.thu_opening = json[@"thu_opening_1stcollection_time"];
    self.thu_closing = json[@"thu_closing_2ndcollection_time"];
    self.fri_opening = json[@"fri_opening_1stcollection_time"];
    self.fri_closing = json[@"fri_closing_2ndcollection_time"];
    self.sat_opening = json[@"sat_opening_1stcollection_time"];
    self.sat_closing = json[@"sat_closing_2ndcollection_time"];
    self.sun_opening = json[@"sun_opening_1stcollection_time"];
    self.sun_closing = json[@"sun_closing_2ndcollection_time"];
    self.ph_opening = json[@"ph_opening_1stcollection_time"];
    self.ph_closing = json[@"ph_closing_2ndcollection_time"];
    self.services = [json[@"services"] isKindOfClass:[NSArray class]] ? [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:json[@"services"] options:0 error:nil] encoding:NSUTF8StringEncoding] : @"";
    self.postingbox = json[@"posting_box"];
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue);
}

- (NSString *)openingHoursForOpenTime:(NSString *)openTime andCloseTime:(NSString *)closeTime
{
    if ([self.type isEqualToString:LOCATION_TYPE_SAM]) {
        if ([self isNullOpeningHours:openTime])
            return @"24 hours";
    }
    else if ([self.type isEqualToString:LOCATION_TYPE_POSTING_BOX]) {
        return openTime;
    }
    return [openTime isEqualToString:@"Closed"] ? @"Closed" : [NSString stringWithFormat:@"%04d - %04d", openTime.integerValue, closeTime.integerValue];
}

- (NSString *)monOpeningHours
{
    return [self openingHoursForOpenTime:self.mon_opening andCloseTime:self.mon_closing];
}

- (NSString *)tuesOpeningHours
{
    return [self openingHoursForOpenTime:self.tue_opening andCloseTime:self.tue_closing];
}

- (NSString *)wedOpeningHours
{
    return [self openingHoursForOpenTime:self.wed_opening andCloseTime:self.wed_closing];
}

- (NSString *)thursOpeningHours
{
    return [self openingHoursForOpenTime:self.thu_opening andCloseTime:self.thu_closing];
}

- (NSString *)friOpeningHours
{
    return [self openingHoursForOpenTime:self.fri_opening andCloseTime:self.fri_closing];
}

- (NSString *)satOpeningHours
{
    return [self openingHoursForOpenTime:self.sat_opening andCloseTime:self.sat_closing];
}

- (NSString *)sunOpeningHours
{
    return [self openingHoursForOpenTime:self.sun_opening andCloseTime:self.sun_closing];
}

- (NSString *)publicHolidayOpeningHours
{
    return [self openingHoursForOpenTime:self.ph_opening andCloseTime:self.ph_closing];
}

- (BOOL)isOpened
{
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HHmm"];
    NSInteger currentTimeDigits = [[timeFormatter stringFromDate:[NSDate date]] integerValue];
    return [self isOpenedAtCurrentTimeDigits:currentTimeDigits];
}

- (BOOL)isOpenedAtCurrentTimeDigits:(NSInteger)timeDigits
{
    int weekDay = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]] weekday];
    
    // Sunday = 1, Saturday = 7
    if (weekDay == 1)
        return [self isOpenedRelativeToTimeDigits:timeDigits andOpeningHours:self.sun_opening andClosingHours:self.sun_closing];
    else if (weekDay == 7)
        return [self isOpenedRelativeToTimeDigits:timeDigits andOpeningHours:self.sat_opening andClosingHours:self.sat_closing];
    
    return [self isOpenedRelativeToTimeDigits:timeDigits andOpeningHours:self.mon_opening andClosingHours:self.mon_closing];
}

- (BOOL)isOpenedRelativeToTimeDigits:(NSInteger)timeDigits andOpeningHours:(NSString *)openingHours andClosingHours:(NSString *)closingHours
{
    if ([self.type isEqualToString:LOCATION_TYPE_POSTING_BOX])
        return ![self isNullOpeningHours:openingHours];
    else if ([self.type isEqualToString:LOCATION_TYPE_SAM]) {
        if ([self isNullOpeningHours:openingHours])
            return YES;
    }
    
    return (timeDigits < [closingHours integerValue] && timeDigits > [openingHours integerValue]);
}

- (CGFloat)distanceInKmToLocation:(CLLocation *)toLocation
{
    CLLocation *fromLocation = [[CLLocation alloc] initWithLatitude:self.latitude.floatValue longitude:self.longitude.floatValue];
    return [toLocation distanceFromLocation:fromLocation] / 1000;
}

- (NSArray *)servicesArray
{
    NSData *data = [self.services dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

- (EntityLocation *)relatedPostingBox
{
    if ([self.type isEqualToString:LOCATION_TYPE_POST_OFFICE] &&  self.postingbox.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@ AND name == %@", LOCATION_TYPE_POSTING_BOX, self.postingbox];
        return [EntityLocation MR_findFirstWithPredicate:predicate];
    }

    return nil;
}

#pragma mark - Utilities

- (BOOL)isNullOpeningHours:(NSString *)openingHour
{
    return ([openingHour isEqualToString:@"-"] || [openingHour isEqualToString:@""]);
}

#pragma mark - API

+ (void)API_updatePostingBoxLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] getPostingBoxLocationsOnSuccess:^(id responseJSON) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized(LOCATIONS_LOCK) {
                NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
                [EntityLocation MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"type == %@", LOCATION_TYPE_POSTING_BOX] inContext:localContext];
                
                [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                    EntityLocation *location = [EntityLocation MR_createInContext:localContext];
                    [location updateWithApiRepresentation:attributes];
                }];
                
                [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(!error, error);
                        });
                    }
                }];
            }
        });
        
        if (completionBlock) {
            completionBlock(YES, nil);
        }
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
}

+ (void)API_updatePostOfficeLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] getPostOfficeLocationsOnSuccess:^(id responseJSON) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized(LOCATIONS_LOCK) {
                NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
                [EntityLocation MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"type == %@", LOCATION_TYPE_POST_OFFICE] inContext:localContext];
                
                [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                    EntityLocation *location = [EntityLocation MR_createInContext:localContext];
                    [location updateWithApiRepresentation:attributes];
                }];
                
                [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(!error, error);
                        });
                    }
                }];
            }
        });
        
        if (completionBlock) {
            completionBlock(YES, nil);
        }
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
}

+ (void)API_updateSamLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] getSamLocationsOnSuccess:^(id responseJSON) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized(LOCATIONS_LOCK) {
                NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
                [EntityLocation MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"type == %@", LOCATION_TYPE_SAM] inContext:localContext];
                
                [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                    EntityLocation *location = [EntityLocation MR_createInContext:localContext];
                    [location updateWithApiRepresentation:attributes];
                }];
                
                [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(!error, error);
                        });
                    }
                }];
            }
        });
        
        if (completionBlock) {
            completionBlock(YES, nil);
        }
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
}

@end
