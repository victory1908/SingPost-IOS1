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
    self.websiteURL = attributes[@"WebsiteURL"];
    self.buttonType = attributes[@"ButtonType"];
}

+ (NSArray *)articleItemsForJSON:(NSDictionary *)jsonItems module:(NSString *)moduleName
{
    NSMutableArray *items = [NSMutableArray array];
    NSArray *sortedCategories = jsonItems[@"keys"];
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    for (NSString *category in sortedCategories) {
        ArticleCategory *articleCategory = [[ArticleCategory alloc] initWithEntity:[ArticleCategory entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
        articleCategory.module = moduleName;
        articleCategory.category = category;
        
        NSMutableArray *articles = [NSMutableArray array];
        [jsonItems[category] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
            Article *article = [[Article alloc] initWithEntity:[Article entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
            [article updateWithApiRepresentation:articleJSON];
            [articles addObject:article];
        }];
        [articleCategory setArticles:[NSOrderedSet orderedSetWithArray:articles]];
        
        [items addObject:articleCategory];
    }
    
    return items;
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

+ (void)API_getShopItemsOnCompletion:(void(^)(NSArray *items))completionBlock
{
    [[ApiClient sharedInstance] getShopItemsOnSuccess:^(id responseJSON) {
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
                NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

                [[responseJSON[@"root"] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"Order" ascending:YES]]] enumerateObjectsUsingBlock:^(id articleJSON, NSUInteger idx, BOOL *stop) {
                    Article *article = [[Article alloc] initWithEntity:[Article entityInManagedObjectContext:localContext] insertIntoManagedObjectContext:nil];
                    [article updateWithApiRepresentation:articleJSON];
                    [items addObject:article];
                }];
                
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
