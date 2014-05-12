//
//  TrackingFeedbackViewController.m
//  SingPost
//
//  Created by Wei Guang on 2/1/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "TrackingFeedbackViewController.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "TrackedItem.h"
#import "CTextView.h"
#import "FlatBlueButton.h"
#import "SVProgressHUD.h"
#import "ApiClient.h"
#import "UIAlertView+Blocks.h"
#import "DeliveryStatus.h"

@interface TrackingFeedbackViewController ()

@end

@implementation TrackingFeedbackViewController {
    TrackedItem *_trackedItem;
    UILabel *trackingNumberLabel, *originLabel, *destinationLabel;
    CTextView *commentsTextView;
}

- (id)initWithTrackedItem:(TrackedItem *)inTrackedItem
{
    NSParameterAssert(inTrackedItem);
    if ((self = [super initWithNibName:nil bundle:nil]))
        _trackedItem = inTrackedItem;
    return self;
}

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    //navigation bar
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setShowBackButton:YES];
    [navigationBarView setTitle:@"Feedback"];
    [contentView addSubview:navigationBarView];
    
    TPKeyboardAvoidingScrollView *contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [contentScrollView setBackgroundColor:[UIColor whiteColor]];
    [contentScrollView setContentSize:CGSizeMake(contentScrollView.bounds.size.width, 395)];
    [contentView addSubview:contentScrollView];
    
    //tracking info view
    UIView *trackingInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, 100)];
    [trackingInfoView setBackgroundColor:RGB(240, 240, 240)];
    [contentScrollView addSubview:trackingInfoView];
    
    UILabel *trackingNumberDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 130, 20)];
    [trackingNumberDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [trackingNumberDisplayLabel setText:@"Tracking number"];
    [trackingNumberDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [trackingNumberDisplayLabel setTextColor:RGB(168, 173, 180)];
    [trackingInfoView addSubview:trackingNumberDisplayLabel];
    
    UILabel *originDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 130, 20)];
    [originDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [originDisplayLabel setText:@"Origin"];
    [originDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [originDisplayLabel setTextColor:RGB(168, 173, 180)];
    [trackingInfoView addSubview:originDisplayLabel];
    
    UILabel *destinationDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 130, 20)];
    [destinationDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [destinationDisplayLabel setText:@"Destination"];
    [destinationDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [destinationDisplayLabel setTextColor:RGB(168, 173, 180)];
    [trackingInfoView addSubview:destinationDisplayLabel];
    
    trackingNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 16, 130, 20)];
    trackingNumberLabel.right = contentView.width - 15;
    [trackingNumberLabel setFont:[UIFont SingPostSemiboldFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [trackingNumberLabel setTextColor:RGB(36, 84, 157)];
    [trackingNumberLabel setText:_trackedItem.trackingNumber];
    [trackingNumberLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:trackingNumberLabel];
    
    originLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 40, 130, 20)];
    originLabel.right = contentView.width - 15;
    [originLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [originLabel setTextColor:RGB(51, 51, 51)];
    [originLabel setText:_trackedItem.originalCountry];
    [originLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:originLabel];
    
    destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 65, 130, 20)];
    destinationLabel.right = contentView.width - 15;
    [destinationLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [destinationLabel setTextColor:RGB(51, 51, 51)];
    [destinationLabel setText:_trackedItem.destinationCountry];
    [destinationLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:destinationLabel];
    
    UIView *bottomTrackingInfoSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, trackingInfoView.bounds.size.height - 1, contentView.bounds.size.width, 1)];
    [bottomTrackingInfoSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [trackingInfoView addSubview:bottomTrackingInfoSeparatorView];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, trackingInfoView.frame.origin.y + trackingInfoView.frame.size.height + 10, contentView.bounds.size.width - 30, 80)];
    [instructionsLabel setNumberOfLines:0];
    [instructionsLabel setText:@"SingPost will be alerted about this tracking number. Use the box below to submit any specific feedback (optional).\n\nTap the ‘Send’ button to submit the alert."];
    [instructionsLabel setFont:[UIFont SingPostLightFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [instructionsLabel setBackgroundColor:[UIColor clearColor]];
    [contentScrollView addSubview:instructionsLabel];
    
    CGSize maximumLabelSize = CGSizeMake(contentView.width - 30, FLT_MAX);
    CGSize expectedLabelSize = [instructionsLabel.text sizeWithFont:instructionsLabel.font constrainedToSize:maximumLabelSize lineBreakMode:instructionsLabel.lineBreakMode];
    CGRect newFrame = instructionsLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    instructionsLabel.frame = newFrame;
    
    UIImageView *commentsBackgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"trackingTextBox_grayBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [commentsBackgroundImageView setFrame:CGRectMake(15, instructionsLabel.frame.origin.y + instructionsLabel.frame.size.height + 10, contentView.width - 30, 150)];
    [contentScrollView addSubview:commentsBackgroundImageView];
    
    commentsTextView = [[CTextView alloc] initWithFrame:CGRectInset(commentsBackgroundImageView.frame, 5, 5)];
    [commentsTextView setPlaceholder:@"Optional"];
    [contentScrollView addSubview:commentsTextView];
    
    FlatBlueButton *sendFeedbackButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, commentsBackgroundImageView.frame.origin.y + commentsBackgroundImageView.frame.size.height + 10, contentView.width - 30 , 48)];
    [sendFeedbackButton addTarget:self action:@selector(sendFeedbackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendFeedbackButton setTitle:@"SEND" forState:UIControlStateNormal];
    [contentScrollView addSubview:sendFeedbackButton];
    
    self.view = contentView;
}

#pragma mark - IBActions

- (IBAction)sendFeedbackButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    
    NSMutableString *deliveryStatusString = [NSMutableString string];
    
    for (DeliveryStatus *deliveryStatus in self.deliveryStatusArray) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yy"];
        
        NSString *date = [dateFormatter stringFromDate:deliveryStatus.date];
        NSString *statusDescription = deliveryStatus.statusDescription;
        NSString *location = deliveryStatus.location;
        
        [deliveryStatusString appendFormat:@"%@      %@      %@\n",date,statusDescription,location];
    }
    
    NSString *postMessage = [NSString stringWithFormat:@"TrackingNo.: %@\n%@Message: %@",_trackedItem.trackingNumber,deliveryStatusString,commentsTextView.text];
    
    [UIAlertView showWithTitle:nil
                       message:@"Submit alert?"
             cancelButtonTitle:@"No"
             otherButtonTitles:@[@"Yes"]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if (buttonIndex != [alertView cancelButtonIndex]) {
             [self.view endEditing:YES];
             [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeClear];
             [[ApiClient sharedInstance] postFeedbackMessage:postMessage subject:@"SingPost Mobile App | Customer T&T Issue" onSuccess:^(id responseObject) {
                 [SVProgressHUD showSuccessWithStatus:@"Feedback sent."];
             } onFailure:^(NSError *error) {
                 [SVProgressHUD showErrorWithStatus:@"An error has occured"];
             }];
         }
         else
             return;
         
     }];
}

@end
