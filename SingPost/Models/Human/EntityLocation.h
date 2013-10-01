#import "_EntityLocation.h"
#import <MapKit/MapKit.h>

@interface EntityLocation : _EntityLocation {}

- (CGFloat)distanceInKmToLocation:(CLLocation *)toLocation;
- (BOOL)isOpenedRelativeToTimeDigits:(NSInteger)timeDigits;
- (void)updateWithCsvRepresentation:(NSArray *)csv;

@end
