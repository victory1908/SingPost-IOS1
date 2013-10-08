#import "Article.h"
#import "ApiClient.h"

@interface Article ()

@end


@implementation Article

- (void)updateWithApiDictionaryRepresentation:(NSDictionary *)attributes
{
    self.name = attributes[@"Name"];
    self.htmlContent = attributes[@"Description"];
    self.category = attributes[@"Category"];
    self.thumbnail = attributes[@"Thumbnail"];
    self.websiteURL = attributes[@"WebsiteURL"];
}

+ (NSFetchedResultsController *)frcSendReceiveArticlesWithDelegate:(id)delegate
{
    return [Article MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"category == %@", @"Send Document / Parcel"] sortedBy:ArticleAttributes.ordering ascending:YES delegate:delegate];
}

#pragma mark - APIs

+ (void)API_getSendReceiveItemsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] getSingpostServicesArticlesOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            [Article MR_truncateAllInContext:localContext];
            
            [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                Article *article = [Article MR_createInContext:localContext];
                [article updateWithApiDictionaryRepresentation:attributes];
                [article setOrderingValue:idx];
                NSLog(@"1111");
            }];
            
            [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(!error, error);
                    });
                }
            }];
        });
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error);
            });
        }
    }];
}

@end
