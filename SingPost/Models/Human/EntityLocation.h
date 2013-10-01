#import "_EntityLocation.h"
#import <MapKit/MapKit.h>

@interface EntityLocation : _EntityLocation {}

@property (nonatomic, readonly) BOOL isOpened;

- (CGFloat)distanceInKmToLocation:(CLLocation *)toLocation;
- (BOOL)isOpenedRelativeToTimeDigits:(NSInteger)timeDigits;
- (void)updateWithCsvRepresentation:(NSArray *)csv;

@end
