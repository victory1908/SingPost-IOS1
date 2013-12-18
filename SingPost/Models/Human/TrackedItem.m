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
    return self.isActiveValue && (fabsl(intervalSinceLastUpdated) > STALE_INTERVAL_SECONDS);
}

+ (TrackedItem *)createIfNotExistsFromXMLElement:(RXMLElement *)el inContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    if (![[[el child:@"TrackingNumberFound"] text] boolValue]) {
        *error = [NSError errorWithDomain:ERROR_DOMAIN code:1 userInfo:@{NSLocalizedDescriptionKey: @"Tracking number not found"}];
        return nil;
    }
    
    NSString *trackingNumber = [[el child:@"TrackingNumber"] text];
    TrackedItem *trackedItem = [TrackedItem MR_findFirstByAttribute:TrackedItemAttributes.trackingNumber withValue:trackingNumber inContext:context];
    if (!trackedItem) {
        trackedItem = [TrackedItem MR_createInContext:context];
        [trackedItem setAddedOn:[NSDate date]];
    }
    
    [trackedItem setIsActiveValue:[[el child:@"TrackingNumberActive"].text boolValue]];
    [trackedItem setTrackingNumber:trackingNumber];
    [trackedItem setOriginalCountry:[el child:@"OriginalCountry"].text];
    [trackedItem setDestinationCountry:[el child:@"DestinationCountry"].text];
    [trackedItem setLastUpdatedOn:[NSDate date]];
    
    //delete existing status
    for (DeliveryStatus *deliveryStatus in trackedItem.deliveryStatuses) {
        [context deleteObject:deliveryStatus];
    }
    
    //rebuild delivery statuses
    RXMLElement *rxmlItems = [el child:@"DeliveryStatusDetails"];
    
    NSMutableOrderedSet *deliveries = [NSMutableOrderedSet orderedSet];
    for (RXMLElement *rxmlDeliveryStatus in [rxmlItems children:@"DeliveryStatusDetail"]) {
        [deliveries addObject:[DeliveryStatus createFromXMLElement:rxmlDeliveryStatus inContext:context]];
    }
    
    [trackedItem setDeliveryStatuses:deliveries];
    
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

+ (void)API_getItemTrackingDetailsForTrackingNumber:(NSString *)trackingNumber onCompletion:(void(^)(BOOL success, NSError *error))completionBlock
{
    [[ApiClient sharedInstance] getItemTrackingDetailsForTrackingNumber:trackingNumber onSuccess:^(RXMLElement *rootXML) {
        NSLog(@"tracking item response: %@", rootXML);
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            RXMLElement *rxmlItems = [rootXML child:@"ItemsTrackingDetailList"];
            
            NSError *error;
            TrackedItem *trackedItem = [TrackedItem createIfNotExistsFromXMLElement:[[rxmlItems children:@"ItemTrackingDetail"] firstObject] inContext:localContext error:&error];
            if (!error) {
                [PushNotification API_subscribeNotificationForTrackingNumber:trackedItem.trackingNumber onCompletion:^(BOOL success, NSError *error) {
                    //TODO: fail workflow
                }];
                
                [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(!error, error);
                        });
                    }
                }];
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

+ (void)deleteTrackedItem:(TrackedItem *)trackedItemToDelete
{
    [trackedItemToDelete.managedObjectContext deleteObject:trackedItemToDelete];
    [trackedItemToDelete.managedObjectContext save:nil];
    
    [PushNotification API_unsubscribeNotificationForTrackingNumber:trackedItemToDelete.trackingNumber onCompletion:^(BOOL success, NSError *error) {
        //TODO: fail workflow
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
    NSArray *activeItems = [TrackedItem MR_findByAttribute:TrackedItemAttributes.isActive withValue:@(1)];
    
    NSMutableArray *res = [NSMutableArray array];
    
    for (TrackedItem *item in activeItems) {
        if (item.shouldRefetchFromServer)
            [res addObject:item];
    }
    
    return res;
}

@end