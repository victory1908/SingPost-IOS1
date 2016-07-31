#import "EntityLocation.h"
#import "ApiClient.h"
#import "NSDictionary+Additions.h"

@interface EntityLocation ()

@end

@implementation EntityLocation

static NSString *LOCATIONS_LOCK = @"LOCATIONS_LOCK";

- (void)updateWithApiRepresentation:(NSDictionary *)json
{
    self.name = json[@"name"];
    self.type = json[@"type"];
    self.address = [json objectForKeyOrNil:@"address"];
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
    self.town = [json objectForKeyOrNil:@"town"];
    self.contactNumber = [json objectForKeyOrNil:@"contact_number"];
    self.postal_code = [json objectForKeyOrNil:@"postal_code"];
    self.identity = [[json objectForKeyOrNil:@"id"]stringValue];
    self.last_modified = json[@"last_modified"];
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue);
}

- (NSString *)openingHoursForOpenTime:(NSString *)openTime andCloseTime:(NSString *)closeTime
{
    if ([openTime isEqualToString:@""] && [closeTime isEqualToString:@""])
        return @"Closed";
    
    if ([openTime isEqualToString:@"Closed"])
        return @"Closed";
    
    if ([openTime isEqualToString:@"No collection"])
        return @"No collection";
    
    if ([openTime isEqualToString:@"24 hours"])
        return @"24 hours";
    
    if ([self isNullOpeningHours:openTime])
        return @"24 hours";
    
    else if ([self.type isEqualToString:LOCATION_TYPE_POSTING_BOX]) {
        if(openTime.length < 2)
            return @"Closed";
        
        BOOL isOpenPM = NO;
        NSInteger openHour = [[openTime substringWithRange:NSMakeRange(0, 2)] integerValue];
        NSInteger openMin = [[openTime substringWithRange:NSMakeRange(2, 2)] integerValue];
        
        if(openHour > 12){
            openHour -= 12;
            isOpenPM = YES;
        }
        
        NSString * openTimeStr = [NSString stringWithFormat:@"%02ld:%02ld %@",(long)openHour,(long)openMin, (isOpenPM?@"pm":@"am")];
        
        return openTimeStr;
    }
    
    BOOL isOpenPM = NO;
    NSInteger openHour = [[openTime substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger openMin = [[openTime substringWithRange:NSMakeRange(2, 2)] integerValue];
    
    if(openHour > 12){
        openHour -= 12;
        isOpenPM = YES;
    }
    
    BOOL isClosePM = NO;
    NSInteger closeHour = [[closeTime substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger closeMin = [[closeTime substringWithRange:NSMakeRange(2, 2)] integerValue];
    
    if(closeHour > 12){
        closeHour -= 12;
        isClosePM = YES;
    }
    
    NSString * openTimeStr = [NSString stringWithFormat:@"%02ld:%02ld %@",(long)openHour,(long)openMin, (isOpenPM?@"pm":@"am")];
    NSString * closeTimeStr = [NSString stringWithFormat:@"%02ld:%02ld %@",(long)closeHour,(long)closeMin, (isClosePM?@"pm":@"am")];
    
    return [openTime isEqualToString:@"Closed"] ? @"Closed" : [NSString stringWithFormat:@"%@ - %@", openTimeStr, closeTimeStr];
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
    NSInteger weekDay = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]] weekday];
    
    if ([self.sunOpeningHours isEqualToString:@"24 hours"])
        return YES;
    
    // Sunday = 1, Saturday = 7
    BOOL isLocationOpen;
    switch (weekDay) {
        case 1: {
            isLocationOpen = [self isOpenedRelativeToTimeDigits:timeDigits andOpeningHours:self.sun_opening andClosingHours:self.sun_closing];
            break;
        }
        case 2: {
            isLocationOpen = [self isOpenedRelativeToTimeDigits:timeDigits andOpeningHours:self.mon_opening andClosingHours:self.mon_closing];
            break;
        }
        case 3: {
            isLocationOpen = [self isOpenedRelativeToTimeDigits:timeDigits andOpeningHours:self.tue_opening andClosingHours:self.tue_closing];
            break;
        }
        case 4: {
            isLocationOpen = [self isOpenedRelativeToTimeDigits:timeDigits andOpeningHours:self.wed_opening andClosingHours:self.wed_closing];
            break;
        }
        case 5: {
            isLocationOpen = [self isOpenedRelativeToTimeDigits:timeDigits andOpeningHours:self.thu_opening andClosingHours:self.thu_closing];
            break;
        }
        case 6: {
            isLocationOpen = [self isOpenedRelativeToTimeDigits:timeDigits andOpeningHours:self.fri_opening andClosingHours:self.fri_closing];
            break;
        }
        case 7: {
            isLocationOpen = [self isOpenedRelativeToTimeDigits:timeDigits andOpeningHours:self.sat_opening andClosingHours:self.sat_closing];
            break;
        }
    }
    return isLocationOpen;
}

- (BOOL)isOpenedRelativeToTimeDigits:(NSInteger)timeDigits andOpeningHours:(NSString *)openingHours andClosingHours:(NSString *)closingHours
{
    if ([self.type isEqualToString:LOCATION_TYPE_POSTING_BOX])
    return ![self isNullOpeningHours:openingHours];
    else if ([self.type isEqualToString:LOCATION_TYPE_SAM]) {
        if ([self isNullOpeningHours:openingHours])
        return YES;
    }
    if([closingHours integerValue] > [openingHours integerValue])
        return (timeDigits < [closingHours integerValue] && timeDigits > [openingHours integerValue]);
    else
        return (timeDigits < [closingHours integerValue]+2400 && timeDigits > [openingHours integerValue]);
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

#pragma mark - Parser

+ (void)updateLocationsOfType:(NSString *)locationType jsonData:(id)json onCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(LOCATIONS_LOCK) {
            
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_context];
            [EntityLocation MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"type == %@", locationType] inContext:localContext];
            
            if ([json[@"root"] isKindOfClass:[NSArray class]]) {
                [json[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                    EntityLocation *location = [EntityLocation MR_createEntityInContext:localContext];
                    [location updateWithApiRepresentation:attributes];
                }];
            }
            
            [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(!error, error);
                    });
                }
            }];
            
//            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
//            [EntityLocation MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"type == %@", locationType] inContext:localContext];
//            
//            if ([json[@"root"] isKindOfClass:[NSArray class]]) {
//                [json[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
//                    EntityLocation *location = [EntityLocation MR_createInContext:localContext];
//                    [location updateWithApiRepresentation:attributes];
//                }];
//            }
//            
//            [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
//                if (completionBlock) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        completionBlock(!error, error);
//                    });
//                }
//            }];
        }
    });
}

#pragma mark - Seeders

+ (id)seedLocationsJsonOfType:(NSString *)locationType
{
    NSData *jsonData = [NSData dataWithContentsOfURL:[[NSBundle bundleForClass:self.class] URLForResource:locationType withExtension:@"json"]];
    
    return [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:kNilOptions
                                             error:nil];
}

+ (void)seedLocationsOfType:(NSString *)locationType onCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    [[self class] updateLocationsOfType:locationType jsonData:[[self class] seedLocationsJsonOfType:locationType] onCompletion:completionBlock];
}

#pragma mark - API

+ (void)API_updatePostingBoxLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCATION_TYPE_POSTING_BOX] == nil) {
        [[ApiClient sharedInstance] getPostingBoxLocationsOnSuccess:^(id responseJSON) {
            [[self class] updateLocationsOfType:LOCATION_TYPE_POSTING_BOX jsonData:responseJSON onCompletion:completionBlock];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LOCATION_TYPE_POSTING_BOX];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } onFailure:^(NSError *error) {
            if (completionBlock) {
                completionBlock(NO, error);
            }
        }];
    }
    else {
        [[self class] checkForLocationUpdatesCompletion:completionBlock];
    }
}

+ (void)API_updatePostOfficeLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    //if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCATION_TYPE_POST_OFFICE] == nil) {
    if (false) {
        [[ApiClient sharedInstance] getPostOfficeLocationsOnSuccess:^(id responseJSON) {
            [[self class] updateLocationsOfType:LOCATION_TYPE_POST_OFFICE jsonData:responseJSON onCompletion:completionBlock];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LOCATION_TYPE_POST_OFFICE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } onFailure:^(NSError *error) {
            if (completionBlock) {
                completionBlock(NO, error);
            }
        }];
    }
    else {
        [[self class] checkForLocationUpdatesCompletion:completionBlock];
    }
}

+ (void)API_updateSamLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCATION_TYPE_SAM] == nil) {
        [[ApiClient sharedInstance] getSamLocationsOnSuccess:^(id responseJSON) {
            [[self class] updateLocationsOfType:LOCATION_TYPE_SAM jsonData:responseJSON onCompletion:completionBlock];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LOCATION_TYPE_SAM];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } onFailure:^(NSError *error) {
            if (completionBlock) {
                completionBlock(NO, error);
            }
        }];
    }
    else {
        [[self class] checkForLocationUpdatesCompletion:completionBlock];
    }
}

+ (void)API_updatePostalAgentLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCATION_TYPE_POSTAL_AGENT] == nil) {
        [[ApiClient sharedInstance] getPostalAgentLocationsOnSuccess:^(id responseJSON) {
            [[self class] updateLocationsOfType:LOCATION_TYPE_POSTAL_AGENT jsonData:responseJSON onCompletion:completionBlock];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LOCATION_TYPE_POSTAL_AGENT];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } onFailure:^(NSError *error) {
            if (completionBlock) {
                completionBlock(NO, error);
            }
        }];
    }
    else {
        [[self class] checkForLocationUpdatesCompletion:completionBlock];
    }
}

+ (void)API_updateSingPostAgentLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCATION_TYPE_SINGPOST_AGENT] == nil) {
        [[ApiClient sharedInstance] getSingPostAgentLocationsOnSuccess:^(id responseJSON) {
            [[self class] updateLocationsOfType:LOCATION_TYPE_SINGPOST_AGENT jsonData:responseJSON onCompletion:completionBlock];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LOCATION_TYPE_SINGPOST_AGENT];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } onFailure:^(NSError *error) {
            if (completionBlock) {
                completionBlock(NO, error);
            }
        }];
    }
    else {
        [[self class] checkForLocationUpdatesCompletion:completionBlock];
    }
}

+ (void)API_updatePopStationLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCATION_TYPE_POPSTATION] == nil) {
        [[ApiClient sharedInstance] getPopStationLocationsOnSuccess:^(id responseJSON) {
            [[self class] updateLocationsOfType:LOCATION_TYPE_POPSTATION jsonData:responseJSON onCompletion:completionBlock];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LOCATION_TYPE_POPSTATION];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } onFailure:^(NSError *error) {
            if (completionBlock) {
                completionBlock(NO, error);
            }
        }];
    }
    else {
        [[self class] checkForLocationUpdatesCompletion:completionBlock];
    }
}

+ (void)checkForLocationUpdatesCompletion:(void (^)(BOOL success, NSError *error))completed {
    NSMutableArray *itemsToUpdate = [NSMutableArray array];
    [[ApiClient sharedInstance]getLocationsUpdatesOnSuccess:^(id responseObject) {
        NSArray *root = [responseObject objectForKeyOrNil:@"root"];
        NSLog(@"response object %@",[responseObject objectForKey:@"root"]);
//        NSArray *root = [responseObject objectForKey:@"root"];
        [self removeExpiredLocations:root];
        
        for (NSDictionary *dic in root) {
            EntityLocation *location = [EntityLocation MR_findFirstByAttribute:EntityLocationAttributes.identity
                                                                     withValue:[dic objectForKeyOrNil:@"id"]];
            if (location == nil) {
                [itemsToUpdate addObject:[dic objectForKeyOrNil:@"id"]];
            }
            else {
                if (![location.last_modified isEqualToString:[dic objectForKeyOrNil:@"lm"]]) {
                    [location MR_deleteEntity];
                    [itemsToUpdate addObject:[dic objectForKeyOrNil:@"id"]];
                }
            }
        }
        if ([itemsToUpdate count] <= 0 && completed)
            completed (YES,nil);
        else
            [[self class]updateLocationDatabase:itemsToUpdate completed:completed];
    } onFailure:^(NSError *error) {
        if (completed)
            completed (NO,error);
    }];
}

+ (void)updateLocationDatabase:(NSArray *)array
                     completed:(void (^)(BOOL success, NSError *error))completed {
    [[ApiClient sharedInstance]getLocationsUpdatesDetails:array success:^(id responseObject) {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_context];
        if ([responseObject[@"root"] isKindOfClass:[NSArray class]]) {
            [responseObject[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                EntityLocation *location = [EntityLocation MR_createEntityInContext:localContext];
                [location updateWithApiRepresentation:attributes];
            }];
        }
        
        [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            if (completed) {
                completed(!error, error);
            }
        }];
    } failure:^(NSError *error) {
        if (completed)
            completed (NO,error);
    }];
}

+ (void)removeExpiredLocations:(NSArray *)array {
    NSMutableArray *locationArray = [[EntityLocation MR_findAll]mutableCopy];
    for (NSDictionary *dictionary in array) {
        EntityLocation *location = [EntityLocation MR_findFirstByAttribute:EntityLocationAttributes.identity
                                                                 withValue:[dictionary objectForKeyOrNil:@"id"]];
        [locationArray removeObject:location];
    }
    
    for (EntityLocation *expiryLocation in locationArray) {
        [expiryLocation MR_deleteEntity];
    }
}

@end
