//
//  TrackingItemMainTableViewCell.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STATUS_LABEL_SIZE CGSizeMake(120, 500)

@class ItemTracking;

@interface TrackingItemMainTableViewCell : UITableViewCell

@property (nonatomic) ItemTracking *item;
@property (nonatomic, assign) BOOL hideSeparatorView;

@end
