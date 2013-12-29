#import "Article.h"
#import "ApiClient.h"

@interface Article ()

@end


@implementation Article

static NSString *ARTICLES_LOCK = @"ARTICLES_LOCK";

- (void)updateWithApiRepresentation:(NSDictionary *)attributes
{
    self.name = attributes[@"Name"];
    self.htmlContent = attributes[@"Description"];
    self.category = attributes[@"Category"];
    self.thumbnail = attributes[@"Thumbnail"];
    self.websiteURL = attributes[@"WebsiteURL"];
}

#pragma mark - APIs

+ (void)API_getSendReceiveItemsOnCompletion:(void(^)(NSDictionary *items))completionBlock
{
    [[ApiClient sharedInstance] getSendReceiveItemsOnSuccess:^(id responseJSON) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseJSON[@"root"]);
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

+ (void)API_getShopItemsOnCompletion:(void(^)(NSDictionary *items))completionBlock
{
    [[ApiClient sharedInstance] getShopItemsOnSuccess:^(id responseJSON) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseJSON[@"root"]);
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

+ (void)API_getServicesOnCompletion:(void(^)(NSDictionary *items))completionBlock
{
    [[ApiClient sharedInstance] getServicesItemsOnSuccess:^(id responseJSON) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseJSON[@"root"]);
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

+ (void)API_getPayItemsOnCompletion:(void(^)(NSDictionary *items))completionBlock
{
    [[ApiClient sharedInstance] getPayItemsOnSuccess:^(id responseJSON) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseJSON[@"root"]);
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

+ (void)API_getOffersOnCompletion:(void(^)(NSArray *items))completionBlock
{
    [[ApiClient sharedInstance] getOffersItemsOnSuccess:^(id responseJSON) {
        if (completionBlock) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *sortedItems = [responseJSON[@"root"] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"Order" ascending:YES]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(sortedItems);
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
