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
    
    
}
@synthesize signIn2Label;
@synthesize delegate;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.contentView.bounds.size.height)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        trackingNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 56, 150, 30)];
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
        
        
        signIn2Label = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, 150, 40)];
        [signIn2Label setBackgroundColor:RGB(240, 240, 240)];
        //[signIn2Label setPlaceholder:@"Enter a label"];
        [signIn2Label setTextColor:RGB(36, 84, 157)];
        [signIn2Label setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, signIn2Label.frame.size.height)];
        signIn2Label.leftView = paddingView;
        signIn2Label.leftViewMode = UITextFieldViewModeAlways;
        
        
        if (FBSession.activeSession.state != FBSessionStateOpen
            && FBSession.activeSession.state != FBSessionStateOpenTokenExtended) {
            
            [signIn2Label setPlaceholder:@"Sign in to label"];
            [signIn2Label setTextColor:RGB(50, 50, 50)];
            [signIn2Label setUserInteractionEnabled:NO];
            
            UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 14, 14)];
            [icon setImage:[UIImage imageNamed:@"labelIcon.png"]];
            
            
            
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 150, 40)];
            [button addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview: button];
            
            [signIn2Label addSubview:icon];
        } else {
            [signIn2Label setText:@"Enter a label"];
            [signIn2Label setClearsOnBeginEditing:YES];
            
            [signIn2Label setAutocorrectionType:UITextAutocorrectionTypeNo];
            
        }
        [contentView addSubview:signIn2Label];
        
        
        signIn2Label.delegate = self;
        
        
        [self.contentView addSubview:contentView];
    }
    return self;
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
    
    [statusLabel setHeight:STATUS_LABEL_SIZE.height];
    [statusLabel setText:_item.status];
    [statusLabel alignTop];
    
    [separatorView setY:MAX(59 + 30, CGRectGetMaxY(statusLabel.frame) + 7 + 30)];
    
    NSString * label = [delegate.labelDic objectForKey:_item.trackingNumber];
    
    if(label && ![label isEqualToString:@""]) {
        [signIn2Label removeFromSuperview];
        
        UILabel * itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 40)];
        [itemLabel setText:label ];
        [itemLabel setTextColor:RGB(36, 84, 157)];
        [itemLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        
        [self.contentView addSubview:itemLabel ];
        
        signIn2Label.text = label;
    }
}

- (void)setTextBold {
    [trackingNumberLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [statusLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
}



- (void)signIn {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Register / Sign In" message:@"To enjoy this new feature of labelling all your packages for easy reference, you need to register with us via a simple Facebook sign in. Shall we proceed?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 0) {
        
    } else {
        // If the session state is any of the two "open" states when the button is clicked
        if (FBSession.activeSession.state == FBSessionStateOpen
            || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
            
            // Close the session and remove the access token from the cache
            // The session state handler (in the app delegate) will be called automatically
            
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            // If the session state is not any of the two "open" states when the button is clicked
        } else {
            // Open a session showing the user the login UI
            // You must ALWAYS ask for public_profile permissions when opening a session
            [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email",@"user_about_me",@"user_birthday",@"user_location"]
                                               allowLoginUI:YES
                                          completionHandler:
             ^(FBSession *session, FBSessionState state, NSError *error) {
                 
                 // Retrieve the app delegate
                 AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                 // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                 [appDelegate sessionStateChanged:session state:state error:error];
             }];
        }
        

    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
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
    
    [self setItemLabel:textField.text];
}

- (void) setItemLabel : (NSString *)text {
    [signIn2Label removeFromSuperview];
    
    UILabel * itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 40)];
    [itemLabel setText:text ];
    [itemLabel setTextColor:RGB(36, 84, 157)];
    [itemLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    
    [self.contentView addSubview:itemLabel ];
    
    [delegate submitAllTrackingItemWithLabel];
    
    
}

- (void) updateLabel : (NSString *)label {
    signIn2Label.text = label;
}


@end
