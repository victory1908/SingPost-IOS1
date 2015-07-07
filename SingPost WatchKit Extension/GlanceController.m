//
//  GlanceController.m
//  SingPost WatchKit Extension
//
//  Created by Wei Guang Heng on 25/05/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "GlanceController.h"


@interface GlanceController()
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *progressIndicator;
@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    [self.progressIndicator startAnimatingWithImagesInRange:NSMakeRange(0,10) duration:1.0 repeatCount:1];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



