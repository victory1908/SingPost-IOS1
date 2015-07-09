//
//  TrackingItemMainTableViewCell.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parcel.h"
#import "CustomIOS7AlertView.h"

#define STATUS_LABEL_SIZE CGSizeMake(120, 500)

//@class TrackedItem;

@interface TrackingItemMainTableViewCell : UITableViewCell <UITextFieldDelegate,CustomIOS7AlertViewDelegate>

//@property (nonatomic,retain) TrackedItem *item;
@property (strong, nonatomic) Parcel *parcel;
@property (nonatomic, assign) BOOL hideSeparatorView;

@property (nonatomic,retain) UITextField * signIn2Label;
@property (nonatomic,retain) UILabel * itemLabel;
@property (nonatomic,retain) UIButton * editBtn;


@property (nonatomic,retain) TrackingMainViewController * delegate;

- (void) updateLabel : (NSString *)label;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier IsActive : (BOOL)isActive;
- (void)showSignInButton;

@end
