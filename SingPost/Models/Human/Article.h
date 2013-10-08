#import "_Article.h"

@interface Article : _Article {}

+ (NSFetchedResultsController *)frcSendReceiveArticlesWithDelegate:(id)delegate;
+ (NSFetchedResultsController *)frcPaymentArticlesWithDelegate:(id)delegate;

//Apis
+ (void)API_getSendReceiveItemsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock;

@end
