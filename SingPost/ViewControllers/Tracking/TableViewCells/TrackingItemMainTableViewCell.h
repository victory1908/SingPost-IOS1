//
//  TrackingItemMainTableViewCell.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STATUS_LABEL_SIZE CGSizeMake(120, 500)

@class TrackedItem;

@interface TrackingItemMainTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic,retain) TrackedItem *item;
@property (nonatomic, assign) BOOL hideSeparatorView;

@property (nonatomic,retain) UITextField * signIn2Label;
@property (nonatomic,retain) UILabel * itemLabel;
@property (nonatomic,retain) UIButton * editBtn;


@property (nonatomic,retain) TrackingMainViewController * delegate;

- (void) updateLabel : (NSString *)label;

@end
