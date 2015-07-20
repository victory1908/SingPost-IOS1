//
//  TrackingDetailsViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"
#import "CustomIOS7AlertView.h"
#import "Parcel.h"

@class TrackedItem;

@interface TrackingDetailsViewController : SwipeViewController <CustomIOS7AlertViewDelegate>

//- (id)initWithTrackedItem:(TrackedItem *)trackedItem;

@property (nonatomic,retain) NSString * title;
@property (nonatomic,assign) BOOL isActiveItem;
@property (nonatomic,retain) TrackingMainViewController * delegate;

@property (strong, nonatomic) Parcel *selectedParcel;

@end
