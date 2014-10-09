//
//  TrackingSelectViewController.h
//  SingPost
//
//  Created by Li Le on 24/9/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackedItem.h"
#import "TrackingMainViewController.h"

@interface TrackingSelectViewController : UIViewController
@property (nonatomic,retain)NSArray * trackItems;
@property (nonatomic,retain)NSMutableArray * trackItems2Delete;
@property (nonatomic,retain)TrackingMainViewController * delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void) add2DeleteItem : (TrackedItem *)item;
-(void) removeFromDeleteItem : (TrackedItem *)item;

@end
