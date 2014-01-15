#import "_EntityLocation.h"
#import <MapKit/MapKit.h>

#define LOCATION_TYPE_POST_OFFICE @"Post Office"
#define LOCATION_TYPE_SAM @"SAM"
#define LOCATION_TYPE_POSTING_BOX @"Posting Box"
#define LOCATION_TYPE_SINGPOST_AGENT @"Speedpost Agent"
#define LOCATION_TYPE_POSTAL_AGENT @"Postal Agent"
#define LOCATION_TYPE_POPSTATION @"POPStation"

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

- (void)updateWithApiRepresentation:(NSArray *)json;

+ (void)seedLocationsOfType:(NSString *)locationType onCompletion:(void(^)(BOOL success, NSError *error))completionBlock;

+ (void)API_updatePostOfficeLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock;
+ (void)API_updatePostingBoxLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock;
+ (void)API_updateSamLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock;
+ (void)API_updatePostalAgentLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock;
+ (void)API_updateSingPostAgentLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock;
+ (void)API_updatePopStationLocationsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock;

@end
