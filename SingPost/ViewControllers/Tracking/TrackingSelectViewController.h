//
//  TrackingSelectViewController.h
//  SingPost
//
//  Created by Li Le on 24/9/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parcel.h"
#import "TrackingMainViewController.h"
#import "SwipeViewController.h"

@interface TrackingSelectViewController : SwipeViewController
@property (nonatomic,retain)NSArray * trackItems;
@property (nonatomic,retain)NSMutableArray * trackItems2Delete;
@property (nonatomic,retain)TrackingMainViewController * delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//-(void) add2DeleteItem : (Parcel *)item;
//-(void) removeFromDeleteItem : (Parcel *)item;

-(void) add2DeleteItem : (TrackedItem *)item;
-(void) removeFromDeleteItem : (TrackedItem *)item;


@end
