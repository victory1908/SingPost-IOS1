#import "_EntityLocation.h"
#import <MapKit/MapKit.h>

#define LOCATION_TYPE_POST_OFFICE @"Post Office"
#define LOCATION_TYPE_SAM @"SAM"
#define LOCATION_TYPE_POSTING_BOX @"Posting Box"

@interface EntityLocation : _EntityLocation {}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) BOOL isOpened;
@property (nonatomic, readonly) NSString *monFriOpeningHours;
@property (nonatomic, readonly) NSString *monThuOpeningHours;
@property (nonatomic, readonly) NSString *friOpeningHours;
@property (nonatomic, readonly) NSString *satOpeningHours;
@property (nonatomic, readonly) NSString *sunOpeningHours;
@property (nonatomic, readonly) NSString *publicHolidayOpeningHours;

- (CGFloat)distanceInKmToLocation:(CLLocation *)toLocation;
- (BOOL)isOpenedAtCurrentTimeDigits:(NSInteger)timeDigits;
- (void)updateWithCsvRepresentation:(NSArray *)csv;

@end
