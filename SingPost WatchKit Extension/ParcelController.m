//
//  InterfaceController.m
//  SingPost WatchKit Extension
//
//  Created by Wei Guang Heng on 25/05/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "ParcelController.h"
#import "ParcelRowController.h"
#import "DatabaseManager.h"

@interface ParcelController()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property (strong, nonatomic) NSMutableArray *trackedItems;
@end

@implementation ParcelController

- (void)willActivate {
    [super willActivate];
    
    [DatabaseManager setupRealm];
    
    //Separate the parcels by status
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isActive == 'true'"];
    RLMResults *activeResults = [Parcel objectsWithPredicate:predicate];
    
    predicate = [NSPredicate predicateWithFormat:@"isActive == 'false'"];
    RLMResults *completedResults = [Parcel objectsWithPredicate:predicate];
    
    NSInteger totalItems = [activeResults count] + [completedResults count];
    
    [self.tableView setNumberOfRows:totalItems
                        withRowType:NSStringFromClass([ParcelRowController class])];
    
    if (totalItems == 0)
        return;
    
    //Add them to table
    self.trackedItems = [NSMutableArray array];
    if ([activeResults count] > 0) {
        for (NSInteger i = 0; i < [activeResults count]; i++) {
            Parcel *parcel = [activeResults objectAtIndex:i];
            ParcelRowController *rowController = [self.tableView rowControllerAtIndex:i];
            [rowController setLabel:[parcel getLabelText] isActive:YES];
            [self.trackedItems addObject:parcel];
        }
    }
    
    if ([completedResults count] > 0) {
        for (NSInteger i = 0; i < [completedResults count]; i++) {
            Parcel *parcel = [completedResults objectAtIndex:i];
            ParcelRowController *rowController = [self.tableView rowControllerAtIndex:[activeResults count] + i];
            [rowController setLabel:[parcel getLabelText] isActive:NO];
            [self.trackedItems addObject:parcel];
        }
    }
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier
                            inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex {
    if (table == self.tableView) {
        return [self.trackedItems objectAtIndex:rowIndex];
    }
    return nil;
}

@end



