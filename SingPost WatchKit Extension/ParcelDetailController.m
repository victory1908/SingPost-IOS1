//
//  ParcelDetailInterfaceController.m
//  SingPost
//
//  Created by Wei Guang Heng on 03/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "ParcelDetailController.h"
#import "ParcelDetailRowController.h"
#import "DatabaseManager.h"

@interface ParcelDetailController ()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property (strong, nonatomic) Parcel *parcel;
@end

@implementation ParcelDetailController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.parcel = context;
    RLMArray *statusArray = self.parcel.deliveryStatus;
    
    if ([statusArray count] == 0)
        return;
    
    [self.tableView setNumberOfRows:[statusArray count]
                        withRowType:NSStringFromClass([ParcelDetailRowController class])];
    
    for (NSInteger i = 0; i < [statusArray count]; i++) {
        ParcelStatus *status = [statusArray objectAtIndex:i];
        ParcelDetailRowController *rowController = [self.tableView rowControllerAtIndex:i];
        [rowController setCellWithDetail:status];
    }
}

- (IBAction)showInGlance {
    [DatabaseManager setShowInGlance:self.parcel];
}

- (IBAction)deleteParcel {
    [DatabaseManager removeParcel:self.parcel];
    [self popToRootController];
}

@end



