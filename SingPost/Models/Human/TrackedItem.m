#import "TrackedItem.h"
#import "ApiClient.h"
#import "DeliveryStatus.h"
#import "PushNotification.h"

@interface TrackedItem ()

// Private interface goes here.

@end


@implementation TrackedItem

- (NSString *)status
{
    DeliveryStatus *firstDeliveryStatus = [self.deliveryStatuses firstObject];
    return firstDeliveryStatus ? firstDeliveryStatus.statusDescription : @"-";
}

- (BOOL)shouldRefetchFromServer
{
#define STALE_INTERVAL_SECONDS 300
    NSTimeInterval intervalSinceLastUpdated = [[NSDate date] timeIntervalSinceDate:self.lastUpdatedOn];
    return (fabsl(intervalSinceLastUpdated) > STALE_INTERVAL_SECONDS);
}

+ (TrackedItem *)createIfNotExistsFromXMLElement:(RXMLElement *)el inContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    NSString *trackingNumber = [[el child:@"TrackingNumber"] text];
    TrackedItem *trackedItem = [TrackedItem MR_findFirstByAttribute:TrackedItemAttributes.trackingNumber withValue:trackingNumber inContext:context];
    if (!trackedItem) {
        trackedItem = [TrackedItem MR_createInContext:context];
        [trackedItem setAddedOn:[NSDate date]];
    }
    
    trackedItem.isFoundValue = [[el child:@"TrackingNumberFound"].text boolValue];
    trackedItem.isActive = [el child:@"TrackingNumberActive"].text;
    trackedItem.trackingNumber = trackingNumber;
    trackedItem.originalCountry = [el child:@"OriginalCountry"].text;
    trackedItem.destinationCountry = [el child:@"DestinationCountry"].text;
    trackedItem.lastUpdatedOn = [NSDate date];
    
    NSOrderedSet *oldStatus = trackedItem.deliveryStatuses;
    
    RXMLElement *rxmlItems = [el child:@"DeliveryStatusDetails"];
    NSMutableOrderedSet *newStatus = [NSMutableOrderedSet orderedSet];
    for (RXMLElement *rxmlDeliveryStatus in [rxmlItems children:@"DeliveryStatusDetail"]) {
        [newStatus addObject:[DeliveryStatus createFromXMLElement:rxmlDeliveryStatus inContext:context]];
    }
    
    if ([oldStatus count] != [newStatus count]) {
        //delete existing status
        for (DeliveryStatus *deliveryStatus in trackedItem.deliveryStatuses) {
            [context deleteObject:deliveryStatus];
        }
        trackedItem.isReadValue = NO;
        [trackedItem setDeliveryStatuses:newStatus];
    }
    else
        trackedItem.isReadValue = YES;
    
    return trackedItem;
}

+ (void)API_batchUpdateTrackedItems:(NSArray *)trackedItems onCompletion:(void(^)(BOOL success, NSError *error))completionBlock withProgressCompletion:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressCompletion;
{
    [[ApiClient sharedInstance] batchUpdateTrackedItems:trackedItems onSuccess:^(RXMLElement *rootXML) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            RXMLElement *rxmlItems = [rootXML child:@"ItemsTrackingDetailList"];
            
            for (RXMLElement *rxmlItem in [rxmlItems children:@"ItemTrackingDetail"]) {
                [TrackedItem createIfNotExistsFromXMLElement:rxmlItem inContext:localContext error:nil];
            }
            
            [localContext MR_saveToPersistentStoreAndWait];
        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            completionBlock(NO, error);
        }
    } withProgressCompletion:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressCompletion(numberOfFinishedOperations, totalNumberOfOperations);
            if (numberOfFinishedOperations == totalNumberOfOperations) {
                if (completionBlock)
                    completionBlock(YES, nil);
            }
        });
    }];
}

+ (void)API_getItemTrackingDetailsForTrackingNumber:(NSString *)trackingNumber notification:(BOOL)pushOn onCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] getItemTrackingDetailsForTrackingNumber:trackingNumber onSuccess:^(RXMLElement *rootXML) {
        NSLog(@"tracking item response: %@", rootXML);
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            RXMLElement *rxmlItems = [rootXML child:@"ItemsTrackingDetailList"];
            
            NSError *error;
            TrackedItem *trackedItem = [TrackedItem createIfNotExistsFromXMLElement:[[rxmlItems children:@"ItemTrackingDetail"] firstObject] inContext:localContext error:&error];
            NSLog(@"TrackedItem %@",trackedItem);
            if (!error) {
                [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(!error, error);
                        });
                    }
                }];
                if (pushOn) {
                    [PushNotificationManager API_subscribeNotificationForTrackingNumber:trackedItem.trackingNumber onCompletion:^(BOOL success, NSError *error)
                     {
                     }];
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error);
                });
            }
        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
}

+ (void)deleteTrackedItem:(TrackedItem *)trackedItemToDelete onCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    [PushNotificationManager API_unsubscribeNotificationForTrackingNumber:trackedItemToDelete.trackingNumber onCompletion:^(BOOL success, NSError *error) {
        if (success) {
            [trackedItemToDelete.managedObjectContext deleteObject:trackedItemToDelete];
            [trackedItemToDelete.managedObjectContext save:nil];
        }
        completionBlock(success, error);
    }];
}

+ (void)saveLastEnteredTrackingNumber:(NSString *)lastKnownTrackingNumber
{
    [[NSUserDefaults standardUserDefaults] setValue:[lastKnownTrackingNumber uppercaseString] forKey:@"SETTINGS_LASTENTEREDTRACKINGNUMBER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)lastEnteredTrackingNumber
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"SETTINGS_LASTENTEREDTRACKINGNUMBER"];
}

+ (NSArray *)itemsRequiringUpdates
{
    //NSArray *activeItems = [TrackedItem MR_findByAttribute:TrackedItemAttributes.isActive withValue:@(1)];
    
    NSMutableArray *res = [NSMutableArray array];
    /*
     for (TrackedItem *item in activeItems) {
     if (item.shouldRefetchFromServer)
     [res addObject:item];
     }
     */
    return res;
}

@end
