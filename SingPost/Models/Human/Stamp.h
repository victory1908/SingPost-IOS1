#import "_Stamp.h"

@interface Stamp : _Stamp

+ (Stamp *)featuredStamp;
+ (NSArray *)yearsDropDownValues;
+ (void)API_getStampsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock;
+ (void)API_getImagesOfStamps:(Stamp *)stamp onCompletion:(void(^)(BOOL success, NSError *error))completionBlock;

@end
