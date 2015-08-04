//
//  GlanceController.m
//  SingPost WatchKit Extension
//
//  Created by Wei Guang Heng on 25/05/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "GlanceController.h"
#import "DatabaseManager.h"

@interface GlanceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *statusLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *trackingLabel;
@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [DatabaseManager setupRealm];
}

- (void)willActivate {
    [super willActivate];
    
    Parcel *parcel = [Parcel getGlanceParcel];
    if (parcel != nil) {
        self.trackingLabel.text = parcel.trackingNumber;
        
        RLMResults *results = [parcel.deliveryStatus sortedResultsUsingProperty:@"date" ascending:NO];
        ParcelStatus *status = [results firstObject];
        self.statusLabel.text = status.statusDescription;
    } else {
        self.statusLabel.text = @"No parcel found";
        self.trackingLabel.text = @"";
    }
}

@end



