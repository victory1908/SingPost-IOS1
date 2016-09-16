
//
//  FeedbackViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "FeedbackViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "CTextField.h"
#import "CTextView.h"
#import "FlatBlueButton.h"
#import "ApiClient.h"
#import <SVProgressHUD.h>
#import "UIAlertView+Blocks.h"

#define DEFAULT_TEXTFIELD_BACKGROUND      [[UIImage imageNamed:@"trackingTextBox_grayBg"]resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,15,15)]

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
{
    CTextField *nameTextField, *contactNumberTextField, *emailAddressTextField;
    CTextView *commentsTextView;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Feedback"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    TPKeyboardAvoidingScrollView *contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [contentScrollView setBackgroundColor:[UIColor whiteColor]];
    [contentScrollView setContentSize:CGSizeMake(contentScrollView.bounds.size.width, 715)];
    [contentView addSubview:contentScrollView];
    
    UIView *topInstructionsSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, contentView.bounds.size.width, 1)];
    [topInstructionsSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [topInstructionsSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentScrollView addSubview:topInstructionsSeparatorView];
    
    UIView *instructionsLabelBackgroundView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, 130)];
    [instructionsLabelBackgroundView setBackgroundColor:RGB(240, 240, 240)];
    [contentScrollView addSubview:instructionsLabelBackgroundView];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, instructionsLabelBackgroundView.bounds.size.width - 30 , instructionsLabelBackgroundView.bounds.size.height- 25)];
    [instructionsLabel setNumberOfLines:0];
    [instructionsLabel setText:@"At SingPost, we are always looking to improve your customer experience. If you have any feedback or ideas for us, we would love to hear from you."];
    [instructionsLabel setTextColor:RGB(58, 68, 81)];
    [instructionsLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [instructionsLabel setBackgroundColor:RGB(240, 240, 240)];
    [contentScrollView addSubview:instructionsLabel];
    
    UIView *bottomInstructionsSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, contentView.bounds.size.width, 1)];
    [bottomInstructionsSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [bottomInstructionsSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentScrollView addSubview:bottomInstructionsSeparatorView];
    
    CGFloat offsetY = 150.0f;
    UILabel *personalInformationDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 180, 20)];
    [personalInformationDisplayLabel setText:@"Personal information"];
    [personalInformationDisplayLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [personalInformationDisplayLabel setTextColor:RGB(36, 84, 157)];
    [personalInformationDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [contentScrollView addSubview:personalInformationDisplayLabel];
    
    offsetY += 22.0f;
    UILabel *allFieldMandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 290, 20)];
    [allFieldMandatoryLabel setText:@"All fields above are mandatory"];
    [allFieldMandatoryLabel setBackgroundColor:[UIColor clearColor]];
    [allFieldMandatoryLabel setTextColor:RGB(125, 136, 149)];
    [allFieldMandatoryLabel setFont:[UIFont SingPostLightItalicFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [contentScrollView addSubview:allFieldMandatoryLabel];
    
    offsetY += 45.0f;
    nameTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, offsetY, contentScrollView.width - 30, 44)];
    [nameTextField setPlaceholder:@"Name"];
    [nameTextField setKeyboardType:UIKeyboardTypeNamePhonePad];
    [contentScrollView addSubview:nameTextField];
    
    offsetY += 56.0f;
    contactNumberTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, offsetY, contentScrollView.width - 30, 44)];
    [contactNumberTextField setPlaceholder:@"Contact number"];
    [contactNumberTextField setKeyboardType:UIKeyboardTypePhonePad];
    [contentScrollView addSubview:contactNumberTextField];
    
    offsetY += 56.0f;
    emailAddressTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, offsetY, contentScrollView.width - 30, 44)];
    [emailAddressTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailAddressTextField setPlaceholder:@"Email address"];
    emailAddressTextField.delegate = self;
    emailAddressTextField.returnKeyType = UIReturnKeyNext;
    [contentScrollView addSubview:emailAddressTextField];
    
    offsetY += 70.0f;
    UIView *personalInformationSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, contentView.bounds.size.width, 1)];
    [personalInformationSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [personalInformationSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentScrollView addSubview:personalInformationSeparatorView];
    
    offsetY += 30.0f;
    UILabel *yourCommentDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 180, 20)];
    [yourCommentDisplayLabel setText:@"Your comments"];
    [yourCommentDisplayLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [yourCommentDisplayLabel setTextColor:RGB(36, 84, 157)];
    [yourCommentDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [contentScrollView addSubview:yourCommentDisplayLabel];
    
    offsetY += 20.0f;
    UIImageView *commentsBackgroundImageView = [[UIImageView alloc] initWithImage:DEFAULT_TEXTFIELD_BACKGROUND];
    [commentsBackgroundImageView setFrame:CGRectMake(15, offsetY + 20, contentScrollView.width - 30, 150)];
    [contentScrollView addSubview:commentsBackgroundImageView];
    
    commentsTextView = [[CTextView alloc] initWithFrame:CGRectInset(commentsBackgroundImageView.frame, 5, 5)];
    [commentsTextView setPlaceholder:@"Message"];
    [contentScrollView addSubview:commentsTextView];
    
    offsetY += 190.0f;
    FlatBlueButton *sendFeedbackButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, offsetY, contentScrollView.bounds.size.width - 30, 48)];
    [sendFeedbackButton addTarget:self action:@selector(sendFeedbackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendFeedbackButton setTitle:@"SEND FEEDBACK" forState:UIControlStateNormal];
    [contentScrollView addSubview:sendFeedbackButton];
    
    self.view = contentView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Feedback"];
}

#pragma mark - IBActions

- (IBAction)sendFeedbackButtonClicked:(id)sender
{
    if ([nameTextField.text length] == 0 || [contactNumberTextField.text length] == 0 || [emailAddressTextField.text length] == 0 || [commentsTextView.text length] == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:INCOMPLETE_FIELDS_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:INCOMPLETE_FIELDS_ERROR preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    if([emailAddressTextField.text rangeOfString:@"@"].location == NSNotFound) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:INCOMPLETE_FIELDS_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:INCOMPLETE_FIELDS_ERROR preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

        
        return;
    }
    
    if([emailAddressTextField.text rangeOfString:@"."].location == NSNotFound) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:INCOMPLETE_FIELDS_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:INCOMPLETE_FIELDS_ERROR preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

        
        return;
    }
    
    if([contactNumberTextField.text length] < 7) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:INCOMPLETE_FIELDS_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:INCOMPLETE_FIELDS_ERROR preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

        
        return;
    }
    
    
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        [self.view endEditing:YES];
        NSString *feedbackMessage = [NSString stringWithFormat:@"Name: %@\nContact: %@\nEmail: %@\nMessage: %@", nameTextField.text, contactNumberTextField.text, emailAddressTextField.text, commentsTextView.text];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@"Please wait"];
//        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeClear];
        [[ApiClient sharedInstance] postFeedbackMessage:feedbackMessage subject:@"SingPost Mobile App | Customer Feedback" onSuccess:^(id responseObject) {
            
            nameTextField.text = @"";
            contactNumberTextField.text = @"";
            emailAddressTextField.text = @"";
            commentsTextView.text = @"";
            
            [SVProgressHUD showSuccessWithStatus:@"Feedback has been submitted."];
        } onFailure:^(NSError *error) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            [SVProgressHUD showErrorWithStatus:@"An error has occured"];
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == emailAddressTextField) {
        [commentsTextView becomeFirstResponder];
        return NO;
    }
    return YES;
}

@end
