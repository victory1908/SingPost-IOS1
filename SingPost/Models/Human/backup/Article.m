#import "Article.h"
#import "ApiClient.h"
#import "ArticleCategory.h"


@interface Article ()

@end


@implementation Article

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
    NSMutableArray *items = [NSMutableArray array];
    NSArray *sortedCategories = jsonItems[@"keys"];
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_context];
    
    for (NSString *category in sortedCategories) {
        
        ArticleCategory *articleCategory = [[ArticleCategory alloc] initWithEntity:[ArticleCategory entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
        
        articleCategory.module = moduleName;
        articleCategory.category = category;
        
        NSMutableArray *articles = [NSMutableArray array];
        [jsonItems[category] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
            Article *article = [[Article alloc] initWithEntity:[Article entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
            
            [article updateWithApiRepresentation:articleJSON];
            [articles addObject:article];
            
            article.name
            [article MR_deleteEntity];
            
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==[c]%@",articleJSON[@"Name"]];
            if ([Article MR_findAllWithPredicate:predicate].count==0) {
                [Article MR_importFromObject:article];
                [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                    if (error) NSLog(@"Error save offer to PersistentStore");
                }];
            };

            
            
        }];
        
//        [localContext MR_saveToPersistentStoreAndWait];
        
        [articleCategory setArticles:[NSOrderedSet orderedSetWithArray:articles]];
        
        [items addObject:articleCategory];
        
    };
    return items;
}




//+ (void)API_getStampsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock
//{
//    [[ApiClient sharedInstance] getStampsOnSuccess:^(id responseJSON) {
//        
//        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_context];
//        
//        [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
//            Stamp *stamp = [Stamp MR_findFirstOrCreateByAttribute:@"title" withValue:attributes[@"Name"] inContext:localContext];
//            if (stamp.serverId ==nil) {
//                [stamp setOrderingValue:(int)idx];
//                [stamp updateWithApiRepresentation:attributes];
//            }
//        }];
//        
//        [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
//            if (completionBlock) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completionBlock(!error, error);
//                });
//            }
//        }];
//    } onFailure:^(NSError *error) {
//        if (completionBlock) {
//            completionBlock(NO, error);
//        }
//    }];
//}


//+ (NSArray *)articleItemsForJSON:(NSDictionary *)jsonItems module:(NSString *)moduleName
//{
//    NSMutableArray *items = [NSMutableArray array];
//    NSArray *sortedCategories = jsonItems[@"keys"];
//    
//    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_context];
//    
//    for (NSString *category in sortedCategories) {
//
////        ArticleCategory *articleCategory = [[ArticleCategory alloc] initWithEntity:[ArticleCategory entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
//        
//        ArticleCategory *articleCategory = [ArticleCategory MR_findFirstOrCreateByAttribute:@"module" withValue:moduleName inContext:localContext];
//        
//        if (articleCategory.category ==nil) {
//            //            articleCategory.module = moduleName;
//            articleCategory.category = category;
//        }
////        articleCategory.category = category;
//        
//        NSMutableArray *articles = [NSMutableArray array];
//        [jsonItems[category] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
////            Article *article = [[Article alloc] initWithEntity:[Article entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
//            Article *article = [Article MR_findFirstOrCreateByAttribute:@"name" withValue:articleJSON[@"Name"] inContext:articleCategory.managedObjectContext];
//            
//            if (article.buttonType==nil){
//                                [article setOrderingValue:idx];
//                [article updateWithApiRepresentation:articleJSON];
//            }
////            [article updateWithApiRepresentation:articleJSON];
//            [articles addObject:article];
//            
//        }];
//        
//        [localContext MR_saveToPersistentStoreAndWait];
//        
//        [articleCategory setArticles:[NSOrderedSet orderedSetWithArray:articles]];
//        [items addObject:articleCategory];
//        
//    };
//    return items;
//}




//+ (NSArray *)articleItemsForJSON:(NSDictionary *)jsonItems module:(NSString *)moduleName
//{
//    NSMutableArray *items = [NSMutableArray array];
//    NSArray *sortedCategories = jsonItems[@"keys"];
////    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
////        for (NSString *category in sortedCategories) {
////            ArticleCategory *articleCategory = [[ArticleCategory alloc] initWithEntity:[ArticleCategory entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
////            articleCategory.module = moduleName;
////            articleCategory.category = category;
////            
////            NSMutableArray *articles = [NSMutableArray array];
////            [jsonItems[category] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
////                Article *article = [[Article alloc] initWithEntity:[Article entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
////                [article updateWithApiRepresentation:articleJSON];
////                [articles addObject:article];
////            }];
////            [articleCategory setArticles:[NSOrderedSet orderedSetWithArray:articles]];
////            
////            [items addObject:articleCategory];
////        }
////
////    }];
//    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_context];
//    
//    for (NSString *category in sortedCategories) {
//        ArticleCategory *articleCategory = [[ArticleCategory alloc] initWithEntity:[ArticleCategory entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
//        articleCategory.module = moduleName;
//        articleCategory.category = category;
//        
//        NSMutableArray *articles = [NSMutableArray array];
//        [jsonItems[category] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
//            Article *article = [[Article alloc] initWithEntity:[Article entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
//            [article updateWithApiRepresentation:articleJSON];
//            [articles addObject:article];
//        }];
//        [articleCategory setArticles:[NSOrderedSet orderedSetWithArray:articles]];
//        
//        [items addObject:articleCategory];
//    }
//    
////    for (NSString *category in sortedCategories) {
////        ArticleCategory *articleCategory = [ArticleCategory MR_findFirstOrCreateByAttribute:@"module" withValue:moduleName inContext:localContext];
////        if (articleCategory.category ==nil) {
//////            articleCategory.module = moduleName;
////            articleCategory.category = category;
////        }
////        NSMutableArray *articles = [NSMutableArray array];
////        [jsonItems[category] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
////            Article *article = [Article MR_findFirstOrCreateByAttribute:@"name" withValue:articleJSON[@"Name"] inContext:localContext];
//////            Article *article = [Article MR_createEntityInContext:localContext];
////            if (article.buttonType==nil){
////                [article setOrderingValue:idx];
////                [article updateWithApiRepresentation:articleJSON];
////                [articles addObject:article];
////            }
////        }];
////        
////    }
////    
////    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
////        if (error) NSLog(@"error save article to persistentStore");
////        else {
////            NSLog(@"success save article to persistentStore");
////            NSLog(@"count article %@",@([Article MR_countOfEntitiesWithContext:localContext]));
////        }
////    }];
////    
////    NSLog(@"count item %@",@(items.count));
//    
//    return items;
//
//}

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
                completionBlock([[self class] articleItemsForJSON:responseJSON[@"root"] module:@"Pay"],root);
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *items = [NSMutableArray array];
//                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
//                    [[responseJSON[@"root"] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"Order" ascending:YES]]] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
//                        Article *article = [[Article alloc] initWithEntity:[Article entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
//                        [article updateWithApiRepresentation:articleJSON];
//                        [items addObject:article];
//                    }];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        completionBlock(items);
//                    });
//                }];
                NSManagedObjectContext *localContext = [NSManagedObjectContext MR_context];
//                [localContext MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//                    
//                    [[responseJSON[@"root"] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"Order" ascending:YES]]] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
//                        Article *article = [[Article alloc] initWithEntity:[Article entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
////                        Article *article = [Article MR_findFirstOrCreateByAttribute:@"name" withValue:articleJSON[@"Name"] inContext:localContext];
//                        [article setOrderingValue:idx];
//                        [article updateWithApiRepresentation:articleJSON];
//                        [items addObject:article];
//                    
//                }];
                
                [[responseJSON[@"root"] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"Order" ascending:YES]]] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
                    Article *article = [[Article alloc] initWithEntity:[Article entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
//                    Article *article = [Article MR_findFirstOrCreateByAttribute:@"name" withValue:articleJSON[@"Name"] inContext:localContext];
//                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==[c]%@",articleJSON[@"Name"]];
//                    Article *article = [Article MR_findFirstWithPredicate:predicate inContext:localContext];
//                    Article *article = [Article MR_createEntityInContext:localContext];
                    [article setOrderingValue:(int)idx];
                    [article updateWithApiRepresentation:articleJSON];
                    [items addObject:article];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==[c]%@",articleJSON[@"Name"]];
                    if ([Article MR_findAllWithPredicate:predicate].count==0) {
                        [Article MR_importFromObject:article];
                        [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                            if (error) NSLog(@"Error save offer to PersistentStore");
                        }];
                    };

                    
                }];
//                [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
//                    if(contextDidSave) completionBlock(items);
//                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(items);
                });
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
