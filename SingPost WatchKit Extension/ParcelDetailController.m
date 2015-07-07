//
//  ParcelDetailInterfaceController.m
//  SingPost
//
//  Created by Wei Guang Heng on 03/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "ParcelDetailController.h"
#import "ParcelDetailRowController.h"

@interface ParcelDetailController ()
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet WKInterfaceTable *tableView;
@end

@implementation ParcelDetailController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.dataArray = [context objectForKey:@"status"];
    
    if ([self.dataArray count] == 0)
        return;
    
    [self.tableView setNumberOfRows:[self.dataArray count] withRowType:NSStringFromClass([ParcelDetailRowController class])];
    
    for (NSInteger i = 0; i < [self.dataArray count]; i++) {
        NSDictionary *status = [self.dataArray objectAtIndex:i];
        ParcelDetailRowController *rowController = [self.tableView rowControllerAtIndex:i];
        [rowController setCellWithDetail:status];
    }
}

@end



