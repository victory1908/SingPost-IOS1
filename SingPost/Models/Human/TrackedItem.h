#import "_TrackedItem.h"

@interface TrackedItem : _TrackedItem {}

@property (nonatomic, readonly) NSString *status;

//+ (void)saveLastEnteredTrackingNumber:(NSString *)lastKnownTrackingNumber;
//+ (NSString *)lastEnteredTrackingNumber;

+ (void)deleteTrackedItem:(TrackedItem *)trackedItemToDelete onCompletion:(void(^)(BOOL success, NSError *error))completionBlock;

+ (void)API_getItemTrackingDetailsForTrackingNumber:(NSString *)trackingNumber notification:(BOOL)pushOn onCompletion:(void(^)(BOOL success, NSError *error))completionBlock;

@end
