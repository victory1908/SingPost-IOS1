//
//  ParcelRowController.m
//  SingPost
//
//  Created by Wei Guang Heng on 11/06/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "ParcelRowController.h"

@interface ParcelRowController()
@property (weak, nonatomic) IBOutlet WKInterfaceImage *parcelLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *statusIndicator;
@end

@implementation ParcelRowController

- (void)setLabel:(NSString *)label status:(NSString *)status {
    self.statusIndicator.text = label;
}

@end
