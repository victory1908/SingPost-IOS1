#import "_ItemTracking.h"

@interface ItemTracking : _ItemTracking {}

@property (nonatomic, readonly) NSString *status;

+ (void)API_getItemTrackingDetailsForTrackingNumber:(NSString *)trackingNumber onCompletion:(void(^)(BOOL success, NSError *error))completionBlock;
+ (void)API_batchUpdateTrackedItems:(NSArray *)trackedItems onCompletion:(void(^)(BOOL success, NSError *error))completionBlock withProgressCompletion:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressCompletion;

@end
