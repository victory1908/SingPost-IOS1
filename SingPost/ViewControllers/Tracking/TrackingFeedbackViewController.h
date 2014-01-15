//
//  TrackingFeedbackViewController.h
//  SingPost
//
//  Created by Wei Guang on 2/1/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrackedItem;

@interface TrackingFeedbackViewController : UIViewController

- (id)initWithTrackedItem:(TrackedItem *)trackedItem;

@property (strong, nonatomic) NSArray *deliveryStatusArray;

@end
