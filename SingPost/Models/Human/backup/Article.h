//#import "_Article.h"
#import "Article+CoreDataProperties.h"
//@interface Article : _Article {}
@class ArticleCategory;
@interface Article : NSManagedObject;

//Apis
+ (void)API_getSendReceiveItemsOnCompletion:(void(^)(NSArray *items))completionBlock;
+ (void)API_getShopItemsOnCompletion:(void(^)(NSArray *items, NSDictionary *root))completionBlock;
+ (void)API_getPayItemsOnCompletion:(void(^)(NSArray *items))completionBlock;
+ (void)API_getServicesOnCompletion:(void(^)(NSArray *items))completionBlock;
+ (void)API_getAboutThisAppOnCompletion:(void(^)(NSString *aboutThisApp))completionBlock;
+ (void)API_getTermsOfUseOnCompletion:(void(^)(NSString *termsOfUse))completionBlock;
+ (void)API_getFaqOnCompletion:(void(^)(NSString *termsOfUse))completionBlock;
+ (void)API_getTrackIOnCompletion:(void(^)(NSString *trackI))completionBlock;
+ (void)API_getTrackIIOnCompletion:(void(^)(NSString *trackII))completionBlock;
+ (void)API_getSingPostAppsOnCompletion:(void(^)(NSArray *apps))completionBlock;
+ (void)API_getOffersOnCompletion:(void(^)(NSArray *items))completionBlock;

@end
