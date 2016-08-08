//
//  Article.m
//  
//
//  Created by Le Khanh Vinh on 6/8/16.
//
//

#import "Article.h"
#import "ArticleCategory.h"
#import "ApiClient.h"

@implementation Article

// Insert code here to add functionality to your managed object subclass



#pragma mark - Parsers

- (void)updateWithApiRepresentation:(NSDictionary *)attributes
{
    self.name = attributes[@"Name"];
    self.htmlContent = attributes[@"Description"];
    self.thumbnail = attributes[@"Thumbnail"];
    self.buttonType = attributes[@"ButtonType"];
    self.expireDate = attributes[@"expireDate"];
}

+ (NSArray *)articleItemsForJSON:(NSDictionary *)jsonItems module:(NSString *)moduleName
{
    NSArray *sortedCategories = jsonItems[@"keys"];
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_rootSavingContext];
    
    for (NSString *category in sortedCategories) {
        
        ArticleCategory *articleCategory = [ArticleCategory MR_findFirstOrCreateByAttribute:@"category" withValue:category inContext:localContext];
        articleCategory.module = moduleName;
        articleCategory.category = category;
        NSMutableArray *articles = [NSMutableArray array];
        [jsonItems[category] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
            Article *article = [Article MR_findFirstOrCreateByAttribute:@"name" withValue:articleJSON[@"Name"] inContext:localContext];
            [article updateWithApiRepresentation:articleJSON];
            [article setArticlecategory:articleCategory];
            [articles addObject:article];
        }];
        
        [articleCategory setArticles:[NSOrderedSet orderedSetWithArray:articles]];
        
        [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (error) NSLog(@"Fail to save to persistentStore");
        }];
        
    };
    return [ArticleCategory MR_findByAttribute:@"module" withValue:moduleName andOrderBy:@"category" ascending:NO inContext:localContext];
}

+ (NSArray *)articleForJSON:(NSDictionary *)jsonArticle module:(NSString *)moduleName
{
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_rootSavingContext];
    
    ArticleCategory *articleCategory = [ArticleCategory MR_findFirstOrCreateByAttribute:@"module" withValue:moduleName inContext:localContext];
    
    NSMutableArray *articles = [NSMutableArray array];
    [[jsonArticle[@"root"] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"Order" ascending:YES]]] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
        Article *article = [Article MR_findFirstOrCreateByAttribute:@"name" withValue:articleJSON[@"Name"] inContext:localContext];
        [article updateWithApiRepresentation:articleJSON];
        [article setArticlecategory:articleCategory];
        [articles addObject:article];
    }];
    
    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (error) NSLog(@"Fail to save to persistentStore");
    }];
    
//    return [Article MR_findByAttribute:@"articlecategory" withValue:articleCategory inContext:localContext];
    return [Article MR_findByAttribute:@"articlecategory" withValue:articleCategory andOrderBy:@"expireDate" ascending:NO inContext:localContext];
}





#pragma mark - APIs

+ (void)API_getSendReceiveItemsOnCompletion:(void(^)(NSArray *items))completionBlock
{
    [[ApiClient sharedInstance] getSendReceiveItemsOnSuccess:^(id responseJSON) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([[self class] articleItemsForJSON:responseJSON[@"root"] module:@"Send and Receive"]);
            });
        }
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    }];
}

+ (void)API_getShopItemsOnCompletion:(void(^)(NSArray *items, NSDictionary *root))completionBlock
{
    [[ApiClient sharedInstance] getShopItemsOnSuccess:^(id responseJSON) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *root = responseJSON[@"root"];
                completionBlock([[self class] articleItemsForJSON:responseJSON[@"root"] module:@"Shop"],root);
            });
        }
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil,nil);
            });
        }
    }];
}

+ (void)API_getServicesOnCompletion:(void(^)(NSArray *items))completionBlock
{
    [[ApiClient sharedInstance] getServicesItemsOnSuccess:^(id responseJSON) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([[self class] articleItemsForJSON:responseJSON[@"root"] module:@"More Services"]);
            });
        }
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    }];
}

+ (void)API_getPayItemsOnCompletion:(void(^)(NSArray *items))completionBlock
{
    [[ApiClient sharedInstance] getPayItemsOnSuccess:^(id responseJSON) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([[self class] articleItemsForJSON:responseJSON[@"root"] module:@"Pay"]);
            });
        }
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    }];
}

+ (void)API_getOffersOnCompletion:(void(^)(NSArray *items))completionBlock
{
    [[ApiClient sharedInstance] getOffersItemsOnSuccess:^(id responseJSON) {
        if (completionBlock) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //                    completionBlock(items);
                completionBlock([[self class] articleForJSON:responseJSON module:@"Order"]);;
            });
        }
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    }];
}


//+ (void)API_getOffersOnCompletion:(void(^)(NSArray *items))completionBlock
//{
//    [[ApiClient sharedInstance] getOffersItemsOnSuccess:^(id responseJSON) {
//        if (completionBlock) {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////                NSMutableArray *items = [NSMutableArray array];
//                NSManagedObjectContext *localContext = [NSManagedObjectContext MR_rootSavingContext];
//                
//                ArticleCategory *articleCategory = [ArticleCategory MR_findFirstOrCreateByAttribute:@"module" withValue:@"Order" inContext:localContext];
//                
//                [[responseJSON[@"root"] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"Order" ascending:YES]]] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
//
//                    Article *article = [Article MR_findFirstOrCreateByAttribute:@"name" withValue:articleJSON[@"Name"] inContext:localContext];
//
//                    [article updateWithApiRepresentation:articleJSON];
//                    [article setArticlecategory:articleCategory];
////                    [items addObject:article];
//                    
//                }];
//                
//                [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
//                    if (error) NSLog(@"Fail to save Offer to persistentStore");
//                }];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
////                    completionBlock(items);
//                    completionBlock([Article MR_findByAttribute:@"articlecategory" withValue:articleCategory andOrderBy:@"expireDate" ascending:NO inContext:localContext]);
//                });
//            });
//        }
//    } onFailure:^(NSError *error) {
//        if (completionBlock) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completionBlock(nil);
//            });
//        }
//    }];
//}

+ (void)API_getAboutThisAppOnCompletion:(void(^)(NSString *aboutThisApp))completionBlock
{
    [[ApiClient sharedInstance] getSingpostContentsOnSuccess:^(id responseJSON) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block NSString *aboutThisApp = nil;
            [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                if ([attributes[@"Name"] isEqualToString:@"About This App"]) {
                    aboutThisApp = attributes[@"content"];
                    *stop = YES;
                }
            }];
            
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(aboutThisApp);
                });
            }
        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    }];
}

//+ (void)API_getAboutThisAppOnCompletion:(void(^)(NSArray *aboutThisApp))completionBlock
//{
//    [[ApiClient sharedInstance] getSingpostContentsOnSuccess:^(id responseJSON) {
//        if (completionBlock) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //                    completionBlock(items);
//                completionBlock([[self class] articleForJSON:responseJSON module:@"About This App"]);;
//            });
//        }
//    } onFailure:^(NSError *error) {
//        if (completionBlock) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completionBlock(nil);
//            });
//        }
//    }];
//}





+ (void)API_getTermsOfUseOnCompletion:(void(^)(NSString *termsOfUse))completionBlock
{
    [[ApiClient sharedInstance] getSingpostContentsOnSuccess:^(id responseJSON) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block NSString *termsOfUse = nil;
            [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                if ([attributes[@"Name"] isEqualToString:@"Terms of Use"]) {
                    termsOfUse = attributes[@"content"];
                    *stop = YES;
                }
            }];
            
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(termsOfUse);
                });
            }
        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    }];
}

+ (void)API_getFaqOnCompletion:(void(^)(NSString *termsOfUse))completionBlock
{
    [[ApiClient sharedInstance] getSingpostContentsOnSuccess:^(id responseJSON) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block NSString *faq = nil;
            [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                if ([attributes[@"Name"] isEqualToString:@"FAQ"]) {
                    faq = attributes[@"content"];
                    *stop = YES;
                }
            }];
            
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(faq);
                });
            }
        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    }];
}

+ (void)API_getTrackIOnCompletion:(void(^)(NSString *trackI))completionBlock
{
    [[ApiClient sharedInstance] getSingpostContentsOnSuccess:^(id responseJSON) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block NSString *faq = nil;
            [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                if ([attributes[@"Name"] isEqualToString:@"Track I"]) {
                    faq = attributes[@"content"];
                    *stop = YES;
                }
            }];
            
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(faq);
                });
            }
        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    }];
}

+ (void)API_getTrackIIOnCompletion:(void(^)(NSString *trackII))completionBlock
{
    [[ApiClient sharedInstance] getSingpostContentsOnSuccess:^(id responseJSON) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block NSString *faq = nil;
            [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                if ([attributes[@"Name"] isEqualToString:@"Track II"]) {
                    faq = attributes[@"content"];
                    *stop = YES;
                }
            }];
            
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(faq);
                });
            }
        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    }];
}

+ (void)API_getSingPostAppsOnCompletion:(void(^)(NSArray *apps))completionBlock
{
    [[ApiClient sharedInstance] getSingPostAppsItemsOnSuccess:^(id responseJSON) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (completionBlock) {
                NSArray *sortedItems = [responseJSON[@"root"] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"Order" ascending:YES]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(sortedItems);
                });
            }
        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    }];
}





@end
