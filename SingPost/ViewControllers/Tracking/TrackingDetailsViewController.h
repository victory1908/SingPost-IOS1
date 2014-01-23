//
//  TrackingDetailsViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrackedItem;

@interface TrackingDetailsViewController : UIViewController

- (id)initWithTrackedItem:(TrackedItem *)trackedItem;

@property BOOL fromSideBar;

@end
