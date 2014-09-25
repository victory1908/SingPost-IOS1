//
//  TrackingSelectTableViewCell.h
//  SingPost
//
//  Created by Li Le on 24/9/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackedItem.h"
#import "TrackingSelectViewController.h"

@interface TrackingSelectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UILabel *trackingLabel;
@property (nonatomic,retain) TrackedItem * item;
@property (nonatomic,retain) TrackingSelectViewController * delegate;

-(void) initConetent;
@end
