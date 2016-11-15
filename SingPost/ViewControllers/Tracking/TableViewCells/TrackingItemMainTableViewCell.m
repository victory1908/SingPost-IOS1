//
//  TrackingItemMainTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TrackingItemMainTableViewCell.h"
#import "UIFont+SingPost.h"
#import "TrackedItem.h"
#import "PersistentBackgroundView.h"
#import "UILabel+VerticalAlign.h"
#import "UIView+Position.h"
#import "ApiClient.h"
//#import "CustomIOS7AlertView.h"
#import "CustomIOSAlertView.h"
//#import "RMUniversalAlert.h"

#import <FacebookSDK/FacebookSDK.h>

@implementation TrackingItemMainTableViewCell
{
    UILabel *trackingNumberLabel, *statusLabel;
    PersistentBackgroundView *separatorView;
    PersistentBackgroundView *separatorView2;
    PersistentBackgroundView *separatorView3;
    
    BOOL isActiveOrUnknown;
    
    UIButton * button;
    UIButton * icon;
    
    BOOL flag2;
    UITextField * textfield;
}
@synthesize signIn2Label;
@synthesize delegate;
@synthesize itemLabel;
@synthesize editBtn;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier IsActive : (BOOL)isActive
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = RGB(240, 240, 240);
        self.selectedBackgroundView = v;
        
        CGFloat width;
        if (INTERFACE_IS_IPAD)
            width = 768;
        else
            width = 320;
        
        isActiveOrUnknown = isActive;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.contentView.bounds.size.height)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        trackingNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 6 + (isActive ? 50: 0), 150, 30)];
        [trackingNumberLabel setNumberOfLines:2];
        [trackingNumberLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [trackingNumberLabel setTextColor:RGB(58, 68, 61)];
        [trackingNumberLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:trackingNumberLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 6, STATUS_LABEL_SIZE.width, STATUS_LABEL_SIZE.height)];
        if (INTERFACE_IS_IPAD)
            statusLabel.left = 512;
        [statusLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [statusLabel setTextColor:RGB(50, 50, 50)];
        [statusLabel setNumberOfLines:0];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:statusLabel];
        
        separatorView = [[PersistentBackgroundView alloc] initWithFrame:CGRectMake(15, 59, contentView.bounds.size.width - 30, 1.0f)];
        [separatorView setPersistentBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView];
        
        separatorView2 = [[PersistentBackgroundView alloc] initWithFrame:CGRectMake(contentView.bounds.size.width/1.85, 0, 1, 100)];
        [separatorView2 setPersistentBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView2];
        
        separatorView3 = [[PersistentBackgroundView alloc] initWithFrame:CGRectMake(15, 100, contentView.bounds.size.width - 30, 1.0f)];
        [separatorView3 setPersistentBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView3];
        
        if(![ApiClient isWithoutFacebook]) {
            //Facebook sign in
            if(isActive) {
                
                signIn2Label = [[UITextField alloc] initWithFrame:CGRectMake(15, 6, 160, 40)];
                [signIn2Label setBackgroundColor:RGB(240, 240, 240)];
                //[signIn2Label setPlaceholder:@"Enter a label"];
                [signIn2Label setTextColor:RGB(36, 84, 157)];
                [signIn2Label setFont:[UIFont SingPostRegularFontOfSize:13.0f fontKey:kSingPostFontOpenSans]];
                UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, signIn2Label.frame.size.height)];
                signIn2Label.leftView = paddingView;
                signIn2Label.leftViewMode = UITextFieldViewModeAlways;
                
                UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, signIn2Label.frame.size.height)];
                signIn2Label.rightView = paddingView2;
                signIn2Label.rightViewMode = UITextFieldViewModeAlways;
                
                [contentView addSubview:signIn2Label];
                if (FBSession.activeSession.state != FBSessionStateOpen
                    && FBSession.activeSession.state != FBSessionStateOpenTokenExtended) {
                    
                    [signIn2Label setPlaceholder:@"Sign in to label"];
                    [signIn2Label setTextAlignment:NSTextAlignmentLeft];
                    [signIn2Label setTextColor:RGB(50, 50, 50)];
                    [signIn2Label setUserInteractionEnabled:NO];
                    
                    icon = [[UIButton alloc] initWithFrame:CGRectMake(140, 6, 30, 30)];
                    [icon setBackgroundImage:[UIImage imageNamed:@"labelIcon2.png"] forState:UIControlStateNormal];
                    [icon addTarget:self action:@selector(showSignInButton) forControlEvents:UIControlEventTouchUpInside];
                    
                    button = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 150, 40)];
                    [button addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
                    [contentView addSubview: button];
                    [button setHidden:YES];
                    
                    [signIn2Label setHidden:YES];
                    [self.contentView addSubview: icon];
                    
                    [trackingNumberLabel setFrame:CGRectMake(15, 6, 150, 30)];
                } else {
                    [signIn2Label setText:@"Enter a label"];
                    [signIn2Label setClearsOnBeginEditing:YES];
                    
                    [signIn2Label setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
                    icon = [[UIButton alloc] initWithFrame:CGRectMake(140, 6, 30, 30)];
                    [icon setBackgroundImage:[UIImage imageNamed:@"pencilIcon.png"] forState:UIControlStateNormal];
                    [icon setBackgroundImage:[UIImage imageNamed:@"tickIcon.png"] forState:UIControlStateSelected];
                    [icon addTarget:self action:@selector(showSignInButton) forControlEvents:UIControlEventTouchUpInside];
                    [self.contentView addSubview: icon];
                    
                    [signIn2Label setHidden:YES];
                    
                }
                
                signIn2Label.delegate = self;
                
                [self.contentView bringSubviewToFront:icon];
                
            }
        }
        
        [self.contentView addSubview:contentView];
    }
    return self;
}


- (void)editClicked {
    
    [signIn2Label removeFromSuperview];
    signIn2Label = [[UITextField alloc] initWithFrame:CGRectMake(15, 6, 160, 40)];
    [signIn2Label setBackgroundColor:RGB(240, 240, 240)];
    [signIn2Label setTextColor:RGB(36, 84, 157)];
    [signIn2Label setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, signIn2Label.frame.size.height)];
    signIn2Label.leftView = paddingView;
    signIn2Label.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, signIn2Label.frame.size.height)];
    signIn2Label.rightView = paddingView2;
    signIn2Label.rightViewMode = UITextFieldViewModeAlways;
    
    if(itemLabel.text != nil && ![itemLabel.text isEqualToString:@""]) {
        [signIn2Label setText:itemLabel.text];
        [signIn2Label setClearsOnBeginEditing:NO];
    } else {
        [signIn2Label setText:@"Enter a label"];
        [signIn2Label setClearsOnBeginEditing:YES];
    }
    [signIn2Label setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.contentView addSubview:signIn2Label];
    signIn2Label.delegate = self;
    
    [self.contentView bringSubviewToFront:icon];
    
    [itemLabel removeFromSuperview];
}


- (void)setHideSeparatorView:(BOOL)inHideSeparatorView
{
    _hideSeparatorView = inHideSeparatorView;
    [separatorView setHidden:_hideSeparatorView];
}

- (void)setParcel:(Parcel *)parcel
{
    _parcel = parcel;
    [trackingNumberLabel setText:_parcel.trackingNumber];
    [trackingNumberLabel alignTop];
    [trackingNumberLabel setNumberOfLines:0];
    [trackingNumberLabel sizeToFit];
    
    [statusLabel setHeight:STATUS_LABEL_SIZE.height];
    [statusLabel setText:[_parcel latestStatus]];
    [statusLabel alignTop];
    
    [separatorView setY:MAX(59 + 20, CGRectGetMaxY(statusLabel.frame) + 7 + 20)];
    [separatorView2 setHeight:MAX(59 + 20, CGRectGetMaxY(statusLabel.frame) + 7 + 20)];
    [separatorView3 setY:MAX(59 + 20, CGRectGetMaxY(statusLabel.frame) + 7 + 20)];
    
    NSString * label = [delegate.labelDic objectForKey:_parcel.trackingNumber];
    if(isActiveOrUnknown && label && ![label isEqualToString:@""]) {
        [signIn2Label removeFromSuperview];
        
        itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 130, 40)];
        [itemLabel setText:label];
        [itemLabel setTextColor:RGB(36, 84, 157)];
        [itemLabel setFont:[UIFont SingPostBoldFontOfSize:13.0f fontKey:kSingPostFontOpenSans]];
        [itemLabel setNumberOfLines:0];
        [itemLabel sizeToFit];
        [self.contentView addSubview:itemLabel ];
        
        signIn2Label.text = label;
        [editBtn setHidden:NO];
        
        [self.contentView bringSubviewToFront:editBtn];
        
        [icon setBackgroundImage:[UIImage imageNamed:@"pencilIcon.png"] forState:UIControlStateNormal];
        [icon setBackgroundImage:[UIImage imageNamed:@"tickIcon.png"] forState:UIControlStateSelected];
        
        [trackingNumberLabel setFrame:CGRectMake(15, itemLabel.frame.origin.y + itemLabel.frame.size.height + 5, 150, 30)];
        
    } else {
        [trackingNumberLabel setFrame:CGRectMake(15, 6, 150, 30)];
        [icon setBackgroundImage:[UIImage imageNamed:@"labelIcon2.png"] forState:UIControlStateNormal];
    }
    [self.contentView bringSubviewToFront:icon];
}

- (void)setTextBold {
    [trackingNumberLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [statusLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
}


- (void)showSignInButton {
    if (FBSession.activeSession.state != FBSessionStateOpen
        && FBSession.activeSession.state != FBSessionStateOpenTokenExtended) {
        [self signIn];
        [AppDelegate sharedAppDelegate].trackingNumberTappedBeforeSignin = _parcel.trackingNumber;
    } else {
        if(icon.isSelected) {
            
            [icon setSelected:NO];
            [icon setY:6];
            [signIn2Label setHidden:YES];
            
            if(signIn2Label.text != nil && ![signIn2Label.text isEqualToString:@""] && ![signIn2Label.text isEqualToString:@"Enter a label"]) {
                
                
                [trackingNumberLabel setFrame:CGRectMake(15,56, 150, 30)];
                
                [self setItemLabel2:signIn2Label.text];
                [icon setBackgroundImage:[UIImage imageNamed:@"pencilIcon.png"] forState:UIControlStateNormal];
                [icon setBackgroundImage:[UIImage imageNamed:@"tickIcon.png"] forState:UIControlStateSelected];
                [icon setSelected:NO];
            }
            else {
                [trackingNumberLabel setFrame:CGRectMake(15,6, 150, 30)];
                NSString * num = _parcel.trackingNumber;
                [delegate.labelDic setValue:@"" forKey:num];
            }
        } else {
            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
            UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, 150)];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 240, 60)];
            label.numberOfLines = 0;
            label.text = [NSString stringWithFormat:@"Enter a label for your item %@",_parcel.trackingNumber];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            [label setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [contentView addSubview:label];
            
            PersistentBackgroundView * separator = [[PersistentBackgroundView alloc] initWithFrame:CGRectMake(120, 140, 1, 50)];
            [separator setPersistentBackgroundColor:RGB(196, 197, 200)];
            [contentView addSubview:separator];
            
            textfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 75, 240, 40)];
            [textfield setBorderStyle:UITextBorderStyleRoundedRect];
            textfield.placeholder = @"Not more than 30 characters";
            textfield.text = itemLabel.text;
            textfield.delegate = self;
            textfield.clearButtonMode = UITextFieldViewModeAlways;
            [contentView addSubview:textfield];
            
            alertView.delegate = self;
            alertView.tag = 111;
            
            [alertView setContainerView:contentView];
            [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel",@"Done", nil]];
            
            flag2 = false;
            [alertView show];
        }
        
        [icon setBackgroundImage:[UIImage imageNamed:@"pencilIcon.png"] forState:UIControlStateNormal];
        [icon setBackgroundImage:[UIImage imageNamed:@"tickIcon.png"] forState:UIControlStateSelected];
        
        [self endEditing:YES];
    }
}

- (void)signIn {
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, 250)];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 240, 30)];
    title.text = @"Sign Up/Log In";
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kFontBoldKey]];
    [contentView addSubview:title];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 240, 200)];
    label.numberOfLines = 0;
    label.text = @"Don’t know which tracking number belongs to which package?\n\nNow you can label tracking numbers to easily identify your items.\n\nCreate an account with us to enjoy this feature. Sign Up with your Facebook account to get started!";
    [label setTextAlignment:NSTextAlignmentLeft];
    
    [label setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [contentView addSubview:label];
    
    PersistentBackgroundView * separator = [[PersistentBackgroundView alloc] initWithFrame:CGRectMake(120, 240, 1, 50)];
    [separator setPersistentBackgroundColor:RGB(196, 197, 200)];
    [contentView addSubview:separator];
    
    alertView.delegate = self;
    
    [alertView setContainerView:contentView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel",@"Sign Up/Login", nil]];
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex {
    if(alertView.tag == 111) {
        if (buttonIndex == 0) {
            [icon setSelected:NO];
            
            if(itemLabel == nil)
                [icon setBackgroundImage:[UIImage imageNamed:@"labelIcon2.png"] forState:UIControlStateNormal];
            else
                [icon setBackgroundImage:[UIImage imageNamed:@"pencilIcon.png"] forState:UIControlStateNormal];
            flag2 = true;
        } else {
            
        }
        
        [alertView close];
    } else {
        
        if (buttonIndex == 0) {
            
//            [AppDelegate sharedAppDelegate].trackingNumberTappedBeforeSignin = false;
            [AppDelegate sharedAppDelegate].trackingNumberTappedBeforeSignin = nil;
        } else {
            if (FBSession.activeSession.state == FBSessionStateOpen
                || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
                
                
                [FBSession.activeSession closeAndClearTokenInformation];
                
            } else {
                
                NSArray *permissions = @[@"public_profile",@"email",@"user_about_me",@"user_birthday",@"user_location"];
                FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
                [FBSession setActiveSession:session];
                
                [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingSafari fromViewController:nil completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    
                    appDelegate.isLoginFromSideBar = YES;
                    
                    [appDelegate sessionStateChanged:session state:status error:error];
                }];
                }
        }
        
        
    }
    [alertView close];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 101) {
        if (buttonIndex == 0) {
            
        } else {
            // UITextField *textField = [alertView textFieldAtIndex:0];
            //[self textFieldDidEndEditing:textField];
            
        }
        
    } else {
        
        if (buttonIndex == 0) {
//            [AppDelegate sharedAppDelegate].trackingNumberTappedBeforeSignin = false;
            [AppDelegate sharedAppDelegate].trackingNumberTappedBeforeSignin = nil;
        } else {
            if (FBSession.activeSession.state == FBSessionStateOpen
                || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
                
                
                [FBSession.activeSession closeAndClearTokenInformation];
                
            } else {
                
                NSArray *permissions = @[@"public_profile",@"email",@"user_about_me",@"user_birthday",@"user_location"];
                FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
                [FBSession setActiveSession:session];
                

                [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingSafari fromViewController:nil completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    
                    appDelegate.isLoginFromSideBar = YES;
                    
                    [appDelegate sessionStateChanged:session state:status error:error];
                    
                }];
            }
            
            
        }
    }
}





- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 30) ? NO : YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.trackingMainViewController animateTextField: textField up: YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    if(flag2) {
        flag2 = false;
        [appDelegate.trackingMainViewController animateTextField: textField up: NO];
        [self endEditing:YES];
        return;
    }
    
    [appDelegate.trackingMainViewController animateTextField: textField up: NO];
    
    [self endEditing:YES];
    
    if([textField.text isEqualToString:@""]) {
        textField.text = @"Enter a label";
        itemLabel.text = @"";
        signIn2Label.text = @"Enter a label";
        
        NSString * num = _parcel.trackingNumber;
        [delegate.labelDic setValue:@"" forKey:num];
        [delegate submitAllTrackingItemWithLabel];
        return;
    }
    
    [self setItemLabel2:textField.text];
    [signIn2Label setHidden:YES];
    
    [icon setBackgroundImage:[UIImage imageNamed:@"pencilIcon.png"] forState:UIControlStateNormal];
    [icon setBackgroundImage:[UIImage imageNamed:@"tickIcon.png"] forState:UIControlStateSelected];
    if(icon.isSelected) {
        
        [icon setSelected:NO];
    } else {
        [icon setSelected:YES];
    }
}

- (void) setItemLabel2 : (NSString *)text {
    [signIn2Label removeFromSuperview];
    
    [itemLabel removeFromSuperview];
    itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 130, 40)];
    [itemLabel setText:text ];
    [itemLabel setTextColor:RGB(36, 84, 157)];
    [itemLabel setFont:[UIFont SingPostBoldFontOfSize:13.0f fontKey:kSingPostFontOpenSans]];
    [itemLabel setNumberOfLines:0];
    [itemLabel sizeToFit];
    [self.contentView addSubview:itemLabel ];
    
    [self.contentView bringSubviewToFront:icon];
    
    NSString * num = _parcel.trackingNumber;
    [delegate.labelDic setValue:text forKey:num];
    [signIn2Label setText:text];
    
    [trackingNumberLabel setFrame:CGRectMake(15,56, 150, 30)];
    [delegate submitAllTrackingItemWithLabel];
    
}

- (void) updateLabel : (NSString *)label {
    signIn2Label.text = label;
}


@end
