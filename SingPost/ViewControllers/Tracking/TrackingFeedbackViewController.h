//
//  TrackingFeedbackViewController.h
//  SingPost
//
//  Created by Wei Guang on 2/1/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "Parcel.h"
#import "SwipeViewController.h"

@interface TrackingFeedbackViewController : SwipeViewController

@property (strong, nonatomic) Parcel *parcel;
@property (strong, nonatomic) RLMArray *deliveryStatusArray;

@end
