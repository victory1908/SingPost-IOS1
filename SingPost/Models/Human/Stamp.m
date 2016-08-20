#import "Stamp.h"
#import "StampImage.h"
#import "ApiClient.h"
#import "MagicalRecord+serialSaveWithBlock.h"

@interface Stamp ()

@end


@implementation Stamp

static NSString *STAMPS_LOCK = @"STAMPS_LOCK";

- (void)updateWithApiRepresentation:(NSDictionary *)json
{
    self.title = json[@"Name"];
    self.serverIdValue = [json[@"Id"] intValue];
    self.year = json[@"Year of Release"];
    self.month = json[@"Month of Release"];
    self.day = json[@"Day of Release"];
    self.details = json[@"Description"];
    self.coverImage = json[@"CoverImage"];
    self.thumbnail = json[@"Thumbnail"];
    self.price = json[@"Buy"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMMM/yyy"];
    
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@/%@/%@",self.day,self.month,self.year]];
    self.issueDate = date;
}



+ (void)API_getStampsOnCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] getStampsOnSuccess:^(id responseJSON) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized(STAMPS_LOCK) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                    [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                        Stamp *stamp = [Stamp MR_findFirstOrCreateByAttribute:@"title" withValue:attributes[@"Name"] inContext:localContext];
                        if (stamp.serverId ==nil) {
                            [stamp setOrderingValue:(u_int)idx];
                            [stamp updateWithApiRepresentation:attributes];
                        }
                    }];

                } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                    completionBlock(!error, error);
                }];
//                NSManagedObjectContext *localContext = [NSManagedObjectContext MR_context];
//                
//                [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
//                    Stamp *stamp = [Stamp MR_findFirstOrCreateByAttribute:@"title" withValue:attributes[@"Name"] inContext:localContext];
//                    if (stamp.serverId ==nil) {
//                        [stamp setOrderingValue:(u_int)idx];
//                        [stamp updateWithApiRepresentation:attributes];
//                    }
//                }];
//                [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
//                    if (completionBlock) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            completionBlock(!error, error);
//                        });
//                    }
//                }];
            }});
        
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
    
}


+ (void)API_getImagesOfStamps:(Stamp *)stamp onCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] getImagesOfStamp:stamp onSuccess:^(id responseJSON) {
        @synchronized(STAMPS_LOCK) {
            NSManagedObjectContext *localContext = stamp.managedObjectContext;
            
            
//            NSMutableOrderedSet *stampImages = [NSMutableOrderedSet orderedSet];
            [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
//                StampImage *stampImage = [StampImage MR_createEntityInContext:localContext];
                StampImage *stampImage = [StampImage MR_findFirstOrCreateByAttribute:@"image" withValue:attributes[@"Views"] inContext:localContext];
                if (stampImage.name == nil) {
                    [stampImage setStamp:stamp];
                    [stampImage updateWithApiRepresentation:attributes];
                }
            }];
            
            [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                if (completionBlock) {
                    completionBlock(!error, error);
                }
            }];
        }
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            completionBlock(NO, error);
            
        }
    }];
}

+ (NSArray *)yearsDropDownValues
{
    NSManagedObjectContext *moc = [NSManagedObjectContext MR_rootSavingContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [Stamp entityInManagedObjectContext:moc];
    request.entity = entity;
    request.propertiesToFetch = @[StampAttributes.year];
    request.returnsDistinctResults = YES;
    request.resultType = NSDictionaryResultType;
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:StampAttributes.year ascending:NO]];
    
    NSArray *years = [moc executeFetchRequest:request error:nil];
    
    NSMutableArray *res = [NSMutableArray array];
    for (NSDictionary *year in years) {
        [res addObject:@{@"code": [NSString stringWithFormat:@"%@ Collections", year[@"year"]], @"value": year[@"year"] }];
    }
    
    return res;
}

+ (Stamp *)featuredStamp
{
    return [Stamp MR_findFirstOrderedByAttribute:StampAttributes.issueDate ascending:NO];
}

@end
