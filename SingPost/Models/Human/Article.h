//
//  Article.h
//  
//
//  Created by Le Khanh Vinh on 6/8/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ArticleCategory;

NS_ASSUME_NONNULL_BEGIN

@interface Article : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

//Apis
+ (void)API_getSendReceiveItemsOnCompletion:(void(^)(NSArray *items))completionBlock;
+ (void)API_getShopItemsOnCompletion:(void(^)(NSArray *items, NSDictionary *root))completionBlock;
+ (void)API_getPayItemsOnCompletion:(void(^)(NSArray *items))completionBlock;
+ (void)API_getServicesOnCompletion:(void(^)(NSArray *items))completionBlock;
//+ (void)API_getAboutThisAppOnCompletion:(void(^)(NSString *aboutThisApp))completionBlock;
//+ (void)API_getAboutThisAppOnCompletion:(void(^)(NSArray *aboutThisApp))completionBlock;

//+ (void)API_getTermsOfUseOnCompletion:(void(^)(NSString *termsOfUse))completionBlock;
//+ (void)API_getFaqOnCompletion:(void(^)(NSString *termsOfUse))completionBlock;
+ (void)API_getTrackIOnCompletion:(void(^)(NSString *trackI))completionBlock;
+ (void)API_getTrackIIOnCompletion:(void(^)(NSString *trackII))completionBlock;
+ (void)API_getSingPostAppsOnCompletion:(void(^)(NSArray *apps))completionBlock;
+ (void)API_getOffersOnCompletion:(void(^)(NSArray *items))completionBlock;

@end

NS_ASSUME_NONNULL_END

#import "Article+CoreDataProperties.h"
