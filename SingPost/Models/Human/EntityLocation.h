#import "_EntityLocation.h"
#import <MapKit/MapKit.h>

#define LOCATION_TYPE_POST_OFFICE @"Post Office"
#define LOCATION_TYPE_SAM @"SAM"
#define LOCATION_TYPE_POSTING_BOX @"Posting Box"

@interface EntityLocation : _EntityLocation {}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) BOOL isOpened;
@property (nonatomic, readonly) NSString *monOpeningHours;
@property (nonatomic, readonly) NSString *tuesOpeningHours;
@property (nonatomic, readonly) NSString *wedOpeningHours;
@property (nonatomic, readonly) NSString *thursOpeningHours;
@property (nonatomic, readonly) NSString *friOpeningHours;
@property (nonatomic, readonly) NSString *satOpeningHours;
@property (nonatomic, readonly) NSString *sunOpeningHours;
@property (nonatomic, readonly) NSString *publicHolidayOpeningHours;
@property (nonatomic, readonly) NSArray *servicesArray;
@property (nonatomic, readonly) EntityLocation *relatedPostingBox;

- (CGFloat)distanceInKmToLocation:(CLLocation *)toLocation;
- (BOOL)isOpenedAtCurrentTimeDigits:(NSInteger)timeDigits;

- (void)updateWithCsvRepresentation:(NSArray *)csv;
- (void)updateWithApiRepresentation:(NSArray *)json;

+ (void)API_updatePostOfficeLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock;
+ (void)API_updatePostingBoxLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock;
+ (void)API_updateSamLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock;

@end
