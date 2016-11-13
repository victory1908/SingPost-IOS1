//
//  TrackingDetailsViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"
#import "CustomIOSAlertView.h"
#import "Parcel.h"
#import "SidebarMenuViewController.h"

@interface TrackingDetailsViewController : SwipeViewController <CustomIOSAlertViewDelegate>

@property (nonatomic,assign) BOOL isActiveItem;
@property (nonatomic,retain) TrackingMainViewController * delegate;
@property (strong, nonatomic) Parcel *selectedParcel;

@end
