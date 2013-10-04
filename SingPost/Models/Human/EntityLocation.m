#import "EntityLocation.h"


@interface EntityLocation ()

@end

@implementation EntityLocation

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

- (NSString *)monFriOpeningHours
{
    return [self openingHoursForOpenTime:self.mon_opening andCloseTime:self.mon_closing];
}

- (NSString *)monThuOpeningHours
{
    return [self monFriOpeningHours];
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

#pragma mark - Utilities

- (BOOL)isNullOpeningHours:(NSString *)openingHour
{
    return ([openingHour isEqualToString:@"-"] || [openingHour isEqualToString:@""]);
}

@end
