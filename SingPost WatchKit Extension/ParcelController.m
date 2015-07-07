//
//  InterfaceController.m
//  SingPost WatchKit Extension
//
//  Created by Wei Guang Heng on 25/05/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "ParcelController.h"
#import "ParcelRowController.h"

@interface ParcelController()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property (strong, nonatomic) NSArray *trackedItems;
@end


@implementation ParcelController

- (void)willActivate {
    [super willActivate];
    /*
    self.trackedItems = [[WatchDataHelper sharedInstance]getTrackItems];
    
    if ([self.trackedItems count] == 0)
        return;
    
    [self.tableView setNumberOfRows:[self.trackedItems count] withRowType:NSStringFromClass([ParcelRowController class])];
    
    for (NSInteger i = 0; i < [self.trackedItems count]; i++) {
        NSDictionary *trackItem = [self.trackedItems objectAtIndex:i];
        NSString *trackingNumber = [trackItem objectForKey:@"TrackingNumber"];
        ParcelRowController *rowController = [self.tableView rowControllerAtIndex:i];
        [rowController setLabel:trackingNumber status:@""];
    }
     */
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex {
    if (table == self.tableView) {
        return [self.trackedItems objectAtIndex:rowIndex];
    }
    return nil;
}

@end



