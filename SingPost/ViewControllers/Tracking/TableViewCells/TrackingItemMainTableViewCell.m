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

- (void)setItem:(TrackedItem *)inItem
{
    _item = inItem;
    [trackingNumberLabel setText:_item.trackingNumber];
    [trackingNumberLabel alignTop];
    [trackingNumberLabel setNumberOfLines:0];
    [trackingNumberLabel sizeToFit];
    
    [statusLabel setHeight:STATUS_LABEL_SIZE.height];
    [statusLabel setText:_item.status];
    [statusLabel alignTop];
    
    [separatorView setY:MAX(59 + 20, CGRectGetMaxY(statusLabel.frame) + 7 + 20)];
    [separatorView2 setHeight:MAX(59 + 20, CGRectGetMaxY(statusLabel.frame) + 7 + 20)];
    [separatorView3 setY:MAX(59 + 20, CGRectGetMaxY(statusLabel.frame) + 7 + 20)];
    
    NSString * label = [delegate.labelDic objectForKey:_item.trackingNumber];
    
    if(isActiveOrUnknown && label && ![label isEqualToString:@""]) {
        [signIn2Label removeFromSuperview];
        
        itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 130, 40)];
        [itemLabel setText:label ];
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
                NSString * num = _item.trackingNumber;
                [delegate.labelDic setValue:@"" forKey:num];
                
            }
        } else {
            
            UIAlertView * labelEnterview = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Enter a label for your item %@",self.item.trackingNumber] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
            labelEnterview.alertViewStyle = UIAlertViewStylePlainTextInput;
            labelEnterview.tag = 101;
            UITextField *textField = [labelEnterview textFieldAtIndex:0];
            textField.placeholder = @"Not more than 30 characters";
            textField.text = itemLabel.text;
            textField.delegate = self;
            textField.clearButtonMode = UITextFieldViewModeAlways;
            [labelEnterview show];
        }
        
        [icon setBackgroundImage:[UIImage imageNamed:@"pencilIcon.png"] forState:UIControlStateNormal];
        [icon setBackgroundImage:[UIImage imageNamed:@"tickIcon.png"] forState:UIControlStateSelected];
        
        [self endEditing:YES];
    }
}

- (void)signIn {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Label Your Items" message:@"Don’t know which tracking number belongs to which package?\nNow you can label tracking numbers to easily identify your items.\nCreate an account with us to enjoy this feature. Sign Up with Facebook to get started!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign Up/Login", nil];
 
    
    [alert show];
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
            
        } else {
            if (FBSession.activeSession.state == FBSessionStateOpen
                || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
                
                
                [FBSession.activeSession closeAndClearTokenInformation];

            } else {

                NSArray *permissions = @[@"public_profile",@"email",@"user_about_me",@"user_birthday",@"user_location"];
                FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
                [FBSession setActiveSession:session];
                
                [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {

                    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    
                    appDelegate.isLoginFromSideBar = YES;
  
                    [appDelegate sessionStateChanged:session state:state error:error];
                    
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
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.trackingMainViewController animateTextField: textField up: NO];

   [self endEditing:YES];
    
    if([textField.text isEqualToString:@""]) {
        textField.text = @"Enter a label";
        itemLabel.text = @"";
        
        NSString * num = _item.trackingNumber;
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
    
    NSString * num = _item.trackingNumber;
    [delegate.labelDic setValue:text forKey:num];
    [signIn2Label setText:text];
    
    [trackingNumberLabel setFrame:CGRectMake(15,56, 150, 30)];
    [delegate submitAllTrackingItemWithLabel];

}

- (void) updateLabel : (NSString *)label {
    signIn2Label.text = label;
}


@end
