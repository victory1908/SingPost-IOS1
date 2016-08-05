//
//  TrackingItemMainTableViewCell.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parcel.h"
#import "CustomIOSAlertView.h"

#define STATUS_LABEL_SIZE CGSizeMake(120, 500)

@interface TrackingItemMainTableViewCell : UITableViewCell <UITextFieldDelegate>

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
