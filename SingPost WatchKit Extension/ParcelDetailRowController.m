//
//  ParcelDetailRowController.m
//  SingPost
//
//  Created by Wei Guang Heng on 03/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "ParcelDetailRowController.h"
@import WatchKit;

@interface ParcelDetailRowController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *dateLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *statusLabel;
@end

@implementation ParcelDetailRowController

- (void)setCellWithDetail:(ParcelStatus *)status {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd-MM-yy"];
    
    self.dateLabel.text = [dateFormatter stringFromDate:status.date];
    self.statusLabel.text = status.statusDescription;
}

@end
