//
//  ParcelRowController.m
//  SingPost
//
//  Created by Wei Guang Heng on 11/06/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "ParcelRowController.h"

@interface ParcelRowController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *parcelLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *statusIndicator;
@end

@implementation ParcelRowController

- (void)setLabel:(NSString *)label isActive:(BOOL)active {
    self.parcelLabel.text = label;
    
    if (active) {
        [self.statusIndicator setImageNamed:@"ActiveStatus"];
    } else {
        [self.statusIndicator setImageNamed:@"CompletedStatus"];
    }
}

@end
