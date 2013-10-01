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

- (BOOL)isOpened
{
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HHmm"];
    NSInteger currentTimeDigits = [[timeFormatter stringFromDate:[NSDate date]] integerValue];
    return [self isOpenedRelativeToTimeDigits:currentTimeDigits];
}

- (BOOL)isOpenedRelativeToTimeDigits:(NSInteger)timeDigits
{
    int weekDay = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]] weekday];
    
    // Sunday = 1, Saturday = 7
    if (weekDay == 1)
        return (timeDigits < [self.sun_closing integerValue]);
    else if (weekDay == 7)
        return (timeDigits < [self.sat_closing integerValue]);
  
    return (timeDigits < [self.mon_closing integerValue]);
}

- (CGFloat)distanceInKmToLocation:(CLLocation *)toLocation
{
    CLLocation *fromLocation = [[CLLocation alloc] initWithLatitude:self.latitude.floatValue longitude:self.longitude.floatValue];
    return [toLocation distanceFromLocation:fromLocation] / 1000;
}

@end
