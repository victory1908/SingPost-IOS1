//
//  TrackingDetailsViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"

@class TrackedItem;

@interface TrackingDetailsViewController : SwipeViewController

- (id)initWithTrackedItem:(TrackedItem *)trackedItem;

@property (nonatomic,retain) NSString * title;
@property (nonatomic,retain) TrackingMainViewController * delegate;

@end
