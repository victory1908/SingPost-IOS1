//
//  TrackingItemDetailTableViewCell.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParcelStatus.h"
#import "TrackingMainViewController.h"

#define STATUS_LABEL_SIZE CGSizeMake(130, 500)
#define LOCATION_LABEL_SIZE CGSizeMake(75, 500)

@interface TrackingItemDetailTableViewCell : UITableViewCell
- (void)configureCellWithStatus:(ParcelStatus *)status;
@end
