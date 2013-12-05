
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

    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, instructionsLabelBackgroundView.bounds.size.width - 30, instructionsLabelBackgroundView.bounds.size.height)];
    [instructionsLabel setNumberOfLines:0];
    [instructionsLabel setText:@"At SingPost, we are always looking to improve your customer experience. If you have any feedback or ideas for us, we would love to hear from you."];
    [instructionsLabel setTextColor:RGB(58, 68, 81)];
    [instructionsLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [instructionsLabel setBackgroundColor:RGB(240, 240, 240)];
    [instructionsLabelBackgroundView addSubview:instructionsLabel];
    
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
    UILabel *allFieldMandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, offsetY, 150, 20)];
    [allFieldMandatoryLabel setText:@"All fields are mandatory"];
    [allFieldMandatoryLabel setBackgroundColor:[UIColor clearColor]];
    [allFieldMandatoryLabel setTextColor:RGB(125, 136, 149)];
    [allFieldMandatoryLabel setFont:[UIFont SingPostLightItalicFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [contentScrollView addSubview:allFieldMandatoryLabel];
    
    offsetY += 45.0f;
    nameTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, offsetY, 290, 44)];
    [nameTextField setPlaceholder:@"Name"];
    [contentScrollView addSubview:nameTextField];
    
    offsetY += 56.0f;
    contactNumberTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, offsetY, 290, 44)];
    [contactNumberTextField setPlaceholder:@"Contact number"];
    [contactNumberTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [contentScrollView addSubview:contactNumberTextField];
    
    offsetY += 56.0f;
    emailAddressTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, offsetY, 290, 44)];
    [emailAddressTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailAddressTextField setPlaceholder:@"Email address"];
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
    UIImageView *commentsBackgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"trackingTextBox_grayBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [commentsBackgroundImageView setFrame:CGRectMake(15, offsetY + 20, 290, 150)];
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
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"Feedback"];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - IBActions

- (IBAction)sendFeedbackButtonClicked:(id)sender
{
    NSLog(@"send feedback button clicked");
}

@end
