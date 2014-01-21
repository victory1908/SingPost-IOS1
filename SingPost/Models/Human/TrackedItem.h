#import "_TrackedItem.h"

@interface TrackedItem : _TrackedItem {}

@property (nonatomic, readonly) NSString *status;
@property (nonatomic, readonly) BOOL shouldRefetchFromServer;

+ (void)saveLastEnteredTrackingNumber:(NSString *)lastKnownTrackingNumber;
+ (NSString *)lastEnteredTrackingNumber;

+ (NSArray *)itemsRequiringUpdates;

+ (void)deleteTrackedItem:(TrackedItem *)trackedItemToDelete onCompletion:(void(^)(BOOL success, NSError *error))completionBlock;

+ (void)API_getItemTrackingDetailsForTrackingNumber:(NSString *)trackingNumber notification:(BOOL)pushOn onCompletion:(void(^)(BOOL success, NSError *error))completionBlock;
+ (void)API_batchUpdateTrackedItems:(NSArray *)trackedItems onCompletion:(void(^)(BOOL success, NSError *error))completionBlock withProgressCompletion:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressCompletion;

@end
