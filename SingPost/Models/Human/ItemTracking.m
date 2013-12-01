#import "ItemTracking.h"
#import "ApiClient.h"
#import "DeliveryStatus.h"
#import "PushNotification.h"

@interface ItemTracking ()

// Private interface goes here.

@end


@implementation ItemTracking

- (NSString *)status
{
    DeliveryStatus *firstDeliveryStatus = [self.deliveryStatuses firstObject];
    return firstDeliveryStatus ? firstDeliveryStatus.statusDescription : @"-";
}

+ (ItemTracking *)createIfNotExistsFromXMLElement:(RXMLElement *)el inContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    if (![[[el child:@"TrackingNumberFound"] text] boolValue]) {
        *error = [NSError errorWithDomain:ERROR_DOMAIN code:1 userInfo:@{NSLocalizedDescriptionKey: @"Tracking number not found"}];
        return nil;
    }
    
    NSString *trackingNumber = [[el child:@"TrackingNumber"] text];
    ItemTracking *trackingItem = [ItemTracking MR_findFirstByAttribute:ItemTrackingAttributes.trackingNumber withValue:trackingNumber inContext:context];
    if (!trackingItem) {
        trackingItem = [ItemTracking MR_createInContext:context];
        [trackingItem setAddedOn:[NSDate date]];
    }
    
    [trackingItem setIsActiveValue:[[el child:@"TrackingNumberActive"].text boolValue]];
    [trackingItem setTrackingNumber:trackingNumber];
    [trackingItem setOriginalCountry:[el child:@"OriginalCountry"].text];
    [trackingItem setDestinationCountry:[el child:@"DestinationCountry"].text];
    
    //delete existing status
    for (DeliveryStatus *deliveryStatus in trackingItem.deliveryStatuses) {
        [context deleteObject:deliveryStatus];
    }
    
    //rebuild delivery statuses
    RXMLElement *rxmlItems = [el child:@"DeliveryStatusDetails"];
    
    NSMutableOrderedSet *deliveries = [NSMutableOrderedSet orderedSet];
    for (RXMLElement *rxmlDeliveryStatus in [rxmlItems children:@"DeliveryStatusDetail"]) {
        [deliveries addObject:[DeliveryStatus createFromXMLElement:rxmlDeliveryStatus inContext:context]];
    }
    
    [trackingItem setDeliveryStatuses:deliveries];
    
    return trackingItem;
}

+ (void)API_batchUpdateTrackedItems:(NSArray *)trackedItems onCompletion:(void(^)(BOOL success, NSError *error))completionBlock withProgressCompletion:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressCompletion;
{
    [[ApiClient sharedInstance] batchUpdateTrackedItems:trackedItems onSuccess:^(RXMLElement *rootXML) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            RXMLElement *rxmlItems = [rootXML child:@"ItemsTrackingDetailList"];

            for (RXMLElement *rxmlItem in [rxmlItems children:@"ItemTrackingDetail"]) {
                [ItemTracking createIfNotExistsFromXMLElement:rxmlItem inContext:localContext error:nil];
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
            ItemTracking *trackedItem = [ItemTracking createIfNotExistsFromXMLElement:[[rxmlItems children:@"ItemTrackingDetail"] firstObject] inContext:localContext error:&error];
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

+ (void)deleteTrackedItem:(ItemTracking *)trackedItemToDelete
{
    [trackedItemToDelete.managedObjectContext deleteObject:trackedItemToDelete];
    [trackedItemToDelete.managedObjectContext save:nil];
    
    [PushNotification API_unsubscribeNotificationForTrackingNumber:trackedItemToDelete.trackingNumber onCompletion:^(BOOL success, NSError *error) {
        //TODO: fail workflow
    }];
}

@end
