#import "_Article.h"

@interface Article : _Article {}

+ (NSFetchedResultsController *)frcSendReceiveArticlesWithDelegate:(id)delegate;
+ (NSFetchedResultsController *)frcPaymentArticlesWithDelegate:(id)delegate;
+ (NSFetchedResultsController *)frcShopArticlesWithDelegate:(id)delegate;
+ (NSFetchedResultsController *)frcMoreServicesArticlesWithDelegate:(id)delegate;

//Apis
+ (void)API_getSendReceiveItemsOnCompletion:(void(^)(NSDictionary *items))completionBlock;
+ (void)API_getShopItemsOnCompletion:(void(^)(NSDictionary *items))completionBlock;
+ (void)API_getPayItemsOnCompletion:(void(^)(NSDictionary *items))completionBlock;
+ (void)API_getServicesOnCompletion:(void(^)(NSDictionary *items))completionBlock;
+ (void)API_getAboutThisAppOnCompletion:(void(^)(NSString *aboutThisApp))completionBlock;
+ (void)API_getTermsOfUseOnCompletion:(void(^)(NSString *termsOfUse))completionBlock;
+ (void)API_getFaqOnCompletion:(void(^)(NSString *termsOfUse))completionBlock;

@end
