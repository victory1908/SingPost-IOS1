//
//  TrackingDetailsViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TrackingDetailsViewController.h"
#import "TrackingFeedbackViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "UIImage+Extensions.h"
#import "TrackingItemDetailTableViewCell.h"
#import "TrackedItem.h"
#import "DeliveryStatus.h"
#import <KGModal.h>
#import <QuartzCore/QuartzCore.h>
#import <SVProgressHUD.h>
#import "Article.h"
#import "ApiClient.h"
#import "NSDictionary+Additions.h"
#import "UIView+Position.h"
#import "PersistentBackgroundView.h"
#import "UIImage+animatedGIF.h"

#define NEW_LAYOUT_OFFSET_Y 45

@interface UITextField (LiLeAwesome)
- (CGRect)clearButtonRectForBounds:(CGRect)bounds;
@end

@implementation UITextField (LiLeAwesome)

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    return CGRectMake(self.frame.size.width-30, 0, 35, 35);
    
}
@end

@interface TrackingDetailsViewController()
<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate
>
@end

@implementation TrackingDetailsViewController
{
    UILabel *trackingNumberLabel, *originLabel, *destinationLabel;
    UITableView *trackingDetailTableView;
    
    UIImageView * adBanner;
    NSString * redirectUrl;
    NSString * locationId;
    
    UILabel * labelLabel;
    UIButton * icon;
    
    UIButton * btnDetail2;
    
    UITextField * customTextfield;
}

@synthesize title;

- (void)loadView {
    int offsetY = 0;
    if(self.isActiveItem && ![ApiClient isWithoutFacebook])
        offsetY = NEW_LAYOUT_OFFSET_Y;
    
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    //navigation bar
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setShowBackButton:YES];
    
    if(title) {
        [navigationBarView setTitle:@"Parcel Information"];
    }
    else
        [navigationBarView setTitle:@"Parcel Information"];
    [contentView addSubview:navigationBarView];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton.layer setBorderWidth:1.0f];
    [infoButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [infoButton setBackgroundImage:nil forState:UIControlStateNormal];
    [infoButton setBackgroundImage:[UIImage imageWithColor:RGB(76, 109, 166)] forState:UIControlStateHighlighted];
    [infoButton setTitle:@"Info" forState:UIControlStateNormal];
    [infoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoButton.titleLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setFrame:CGRectMake(255, 7, 50, 30)];
    infoButton.right = contentView.right - 10;
    [navigationBarView addSubview:infoButton];
    
    //tracking info view
    UIView *trackingInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBarView.frame), contentView.bounds.size.width, 100 + offsetY)];
    [trackingInfoView setBackgroundColor:RGB(240, 240, 240)];
    [contentView addSubview:trackingInfoView];
    
    if(self.isActiveItem && ![ApiClient isWithoutFacebook]) {
        labelLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 280, 20)];
        [labelLabel setFont:[UIFont SingPostSemiboldFontOfSize:15.0f fontKey:kSingPostFontOpenSans]];
        
        if (![self.selectedParcel.labelAlias isEqualToString:@""]) {
            [labelLabel setText:self.selectedParcel.labelAlias];
            [labelLabel setTextColor:RGB(36, 84, 157)];
        } else {
            [labelLabel setText:@"Add a label"];
            [labelLabel setTextColor:[UIColor orangeColor]];
            btnDetail2 = [[UIButton alloc] initWithFrame:labelLabel.frame];
            [btnDetail2 addTarget:self action:@selector(onEditClicked) forControlEvents:UIControlEventTouchUpInside];
            [trackingInfoView addSubview: btnDetail2];
        }
        [trackingInfoView addSubview: labelLabel];
        
        icon = [[UIButton alloc] initWithFrame:CGRectMake(contentView.bounds.size.width - 48, 2, 46, 46)];
        [icon setBackgroundImage:[UIImage imageNamed:@"pencilIcon2.png"] forState:UIControlStateNormal];
        [icon setBackgroundImage:[UIImage imageNamed:@"pencilIcon2.png"] forState:UIControlStateHighlighted];
        [icon setBackgroundImage:[UIImage imageNamed:@"labelIcon3.png"] forState:UIControlStateSelected];
        
        if(!title) {
            icon.selected = YES;
            [icon setBackgroundImage:[UIImage imageNamed:@"labelIcon3.png"] forState:UIControlStateHighlighted];
        }
        
        [icon addTarget:self action:@selector(onEditClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [trackingInfoView addSubview: icon];
        
        UIView * labelSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(15, offsetY+4, contentView.bounds.size.width-30, 1)];
        [labelSeparatorView setBackgroundColor:RGB(196, 197, 200)];
        [trackingInfoView addSubview:labelSeparatorView];
    }
    
    
    UILabel *trackingNumberDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + offsetY , 130, 20)];
    [trackingNumberDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [trackingNumberDisplayLabel setText:@"Tracking number"];
    [trackingNumberDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [trackingNumberDisplayLabel setTextColor:RGB(168, 173, 180)];
    [trackingInfoView addSubview:trackingNumberDisplayLabel];
    
    UILabel *originDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40 + offsetY, 130, 20)];
    [originDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [originDisplayLabel setText:@"Origin"];
    [originDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [originDisplayLabel setTextColor:RGB(168, 173, 180)];
    [trackingInfoView addSubview:originDisplayLabel];
    
    UILabel *destinationDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 65 + offsetY, 130, 20)];
    [destinationDisplayLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [destinationDisplayLabel setText:@"Destination"];
    [destinationDisplayLabel setBackgroundColor:[UIColor clearColor]];
    [destinationDisplayLabel setTextColor:RGB(168, 173, 180)];
    [trackingInfoView addSubview:destinationDisplayLabel];
    
    trackingNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 16 + offsetY, 130, 20)];
    trackingNumberLabel.right = contentView.right - 15;
    [trackingNumberLabel setFont:[UIFont SingPostSemiboldFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [trackingNumberLabel setTextColor:RGB(36, 84, 157)];
    [trackingNumberLabel setText:self.selectedParcel.trackingNumber];
    [trackingNumberLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:trackingNumberLabel];
    
    originLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 40 + offsetY, 130, 20)];
    originLabel.right = contentView.right - 15;
    [originLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [originLabel setTextColor:RGB(51, 51, 51)];
    [originLabel setText:self.selectedParcel.originalCountry];
    [originLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:originLabel];
    
    destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 65 + offsetY, 130, 20)];
    destinationLabel.right = contentView.right - 15;
    [destinationLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [destinationLabel setTextColor:RGB(51, 51, 51)];
    [destinationLabel setText:self.selectedParcel.destinationCountry];
    [destinationLabel setBackgroundColor:[UIColor clearColor]];
    [trackingInfoView addSubview:destinationLabel];
    
    UIView *bottomTrackingInfoSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, trackingInfoView.bounds.size.height - 1, contentView.bounds.size.width, 1)];
    [bottomTrackingInfoSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [trackingInfoView addSubview:bottomTrackingInfoSeparatorView];
    
    //header view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 144 + offsetY, contentView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *dateHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 50, 16)];
    [dateHeaderLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [dateHeaderLabel setText:@"Date"];
    [dateHeaderLabel setTextColor:RGB(125, 136, 149)];
    [dateHeaderLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:dateHeaderLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 5, 50, 16)];
    [statusLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [statusLabel setText:@"Status"];
    [statusLabel setTextColor:RGB(125, 136, 149)];
    [statusLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:statusLabel];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 5, 100, 16)];
    [locationLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
    [locationLabel setText:@"Location"];
    [locationLabel setTextColor:RGB(125, 136, 149)];
    [locationLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:locationLabel];
    
    if (INTERFACE_IS_IPAD) {
        statusLabel.left = 256;
        locationLabel.left = 512;
    }
    
    UIView *headerSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(15, headerView.bounds.size.height - 1, headerView.bounds.size.width - 30, 1)];
    [headerSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [headerSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [headerView addSubview:headerSeparatorView];
    [contentView addSubview:headerView];
    
    //content
    if(self.isActiveItem && ![ApiClient isWithoutFacebook]) {
        trackingDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 174 + offsetY, contentView.bounds.size.width, contentView.bounds.size.height - 300) style:UITableViewStylePlain];
    } else {
        trackingDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 174 + offsetY, contentView.bounds.size.width, contentView.bounds.size.height - 194) style:UITableViewStylePlain];
    }
    [trackingDetailTableView setDelegate:self];
    [trackingDetailTableView setDataSource:self];
    [trackingDetailTableView setBackgroundColor:[UIColor clearColor]];
    [trackingDetailTableView setBackgroundView:nil];
    [trackingDetailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [trackingDetailTableView setSeparatorColor:[UIColor clearColor]];
    [contentView addSubview:trackingDetailTableView];
    
    //Ad banner
    [self getAdvertisementWithId:@"20" Count:@"5"];
    int height = (int)((50.0f / 320.0f) * contentView.bounds.size.width);
    adBanner = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentView.bounds.size.height - height - 20, contentView.bounds.size.width, height)];
    [contentView addSubview:adBanner];
    
    self.view = contentView;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Track Item Details"];
    
    if([AppDelegate sharedAppDelegate].trackingNumberTappedBeforeSignin != nil) {
        [self onEditClicked];
        [AppDelegate sharedAppDelegate].trackingNumberTappedBeforeSignin = nil;
    }
}

#pragma mark - IBActions
- (IBAction)infoButtonClicked:(id)sender {
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [Article API_getTrackIIOnCompletion:^(NSString *trackII) {
        [SVProgressHUD dismiss];
        if (trackII) {
            UIWebView *webView = [[UIWebView alloc] initWithFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(0, 0, 280, 500) : CGRectMake(0, 0, 280, 400)];
            [webView setBackgroundColor:[UIColor clearColor]];
            [webView setOpaque:NO];
            [webView loadHTMLString:[NSString stringWithFormat:@"<!DOCTYPE html><html><body style=\"font-family:OpenSans;color:white;\"><h4 style=\"text-align:center;\">Parcel Information</h4>%@</body></html>", trackII] baseURL:nil];
            [[KGModal sharedInstance] showWithContentView:webView andAnimated:YES];
        }
    }];
}

- (void)onEditClicked {
    if (FBSession.activeSession.state != FBSessionStateOpen
        && FBSession.activeSession.state != FBSessionStateOpenTokenExtended){
        [self signIn];
    } else {
        if(self.selectedParcel != nil && self.selectedParcel.trackingNumber != nil) {
            
            /*UIAlertView * labelEnterview = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Enter a label for your item %@",_trackedItem.trackingNumber] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
             labelEnterview.alertViewStyle = UIAlertViewStylePlainTextInput;
             labelEnterview.tag = 101;
             UITextField *textField = [labelEnterview textFieldAtIndex:0];
             textField.placeholder = @"Not more than 30 characters";
             textField.text = title;
             textField.delegate = self;
             textField.clearButtonMode = UITextFieldViewModeAlways;
             [labelEnterview show];*/
            
            CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
            UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, 150)];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 240, 60)];
            label.numberOfLines = 0;
            label.text = [NSString stringWithFormat:@"Enter a label for your item %@",self.selectedParcel.trackingNumber];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            [label setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [contentView addSubview:label];
            
            PersistentBackgroundView * separator = [[PersistentBackgroundView alloc] initWithFrame:CGRectMake(120, 140, 1, 50)];
            [separator setPersistentBackgroundColor:RGB(196, 197, 200)];
            [contentView addSubview:separator];
            
            customTextfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 75, 240, 40)];
            [customTextfield setBorderStyle:UITextBorderStyleRoundedRect];
            customTextfield.placeholder = @"Not more than 30 characters";
            customTextfield.text = title;
            customTextfield.delegate = self;
            customTextfield.clearButtonMode = UITextFieldViewModeAlways;
            [contentView addSubview:customTextfield];
            
            alertView.delegate = self;
            alertView.tag = 111;
            
            [alertView setContainerView:contentView];
            [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel",@"Done", nil]];
            [alertView show];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 30) ? NO : YES;
}

- (void)signIn {
    /*UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Label Your Items" message:@"Don’t know which tracking number belongs to which package?\nNow you can label tracking numbers to easily identify your items.\nCreate an account with us to enjoy this feature. Sign Up with Facebook to get started!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign Up/Login", nil];
     
     [alert show];*/
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, 250)];
    
    UILabel *signInTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 240, 30)];
    signInTitle.text = @"Sign Up/Log In";
    [signInTitle setTextAlignment:NSTextAlignmentCenter];
    [signInTitle setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kFontBoldKey]];
    [contentView addSubview:signInTitle];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 240, 200)];
    label.numberOfLines = 0;
    label.text = @"Don’t know which tracking number belongs to which package?\n\nNow you can label tracking numbers to easily identify your items.\n\nCreate an account with us to enjoy this feature. Sign Up using your Facebook account to get started!";
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

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex {
    if(alertView.tag == 111) {
        if (buttonIndex == 0) {
            
        } else {
            UITextField *textField = customTextfield;
            [self submitAllTrackingItemWithLabel:textField.text];
            
            labelLabel.text = textField.text;
            [labelLabel setTextColor:RGB(36, 84, 157)];
            title = textField.text;
            
            if([textField.text isEqualToString:@""]) {
                labelLabel.text = @"Add a label";
                [icon setBackgroundImage:[UIImage imageNamed:@"labelIcon3.png"] forState:UIControlStateHighlighted];
                [labelLabel setTextColor:[UIColor orangeColor]];
                [btnDetail2 setEnabled:YES];
                title = @"";
                icon.selected = YES;
            } else {
                [icon setBackgroundImage:[UIImage imageNamed:@"pencilIcon2.png"] forState:UIControlStateHighlighted];
                [btnDetail2 setEnabled:NO];
                icon.selected = NO;
            }
        }
        
        [alertView close];
        
        return;
    }
    
    if (buttonIndex == 0) {
        [AppDelegate sharedAppDelegate].trackingNumberTappedBeforeSignin = false;
    } else {
        if (FBSession.activeSession.state == FBSessionStateOpen
            || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
        } else {
            [AppDelegate sharedAppDelegate].trackingNumberTappedBeforeSignin = self.selectedParcel.trackingNumber;
            
            NSArray *permissions = @[@"public_profile",@"email",@"user_about_me",@"user_birthday",@"user_location"];
            FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
            [FBSession setActiveSession:session];
            
            [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                
                AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                appDelegate.isLoginFromDetailPage = YES;
                appDelegate.detailPageTrackNum = self.selectedParcel.trackingNumber;
                [appDelegate sessionStateChanged:session state:state error:error];
                
                
            }];
        }
        
        
    }
    [alertView close];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 101) {
        if (buttonIndex == 0) {
            
        } else {
            UITextField *textField = [alertView textFieldAtIndex:0];
            [self submitAllTrackingItemWithLabel:textField.text];
            
            labelLabel.text = textField.text;
            [labelLabel setTextColor:RGB(36, 84, 157)];
            title = textField.text;
            
            if([textField.text isEqualToString:@""]) {
                labelLabel.text = @"Add a label";
                [labelLabel setTextColor:[UIColor orangeColor]];
                [btnDetail2 setEnabled:YES];
                title = @"";
                icon.selected = YES;
            } else {
                [btnDetail2 setEnabled:NO];
                icon.selected = NO;
            }
        }
        
    }else {
        
        if (buttonIndex == 0) {
            [AppDelegate sharedAppDelegate].trackingNumberTappedBeforeSignin = false;
        } else {
            if (FBSession.activeSession.state == FBSessionStateOpen
                || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
                
                [FBSession.activeSession closeAndClearTokenInformation];
                
            } else {
                [AppDelegate sharedAppDelegate].trackingNumberTappedBeforeSignin = self.selectedParcel.trackingNumber;
                
                NSArray *permissions = @[@"public_profile",@"email",@"user_about_me",@"user_birthday",@"user_location"];
                FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
                [FBSession setActiveSession:session];
                
                [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                    
                    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    appDelegate.isLoginFromDetailPage = YES;
                    appDelegate.detailPageTrackNum = self.selectedParcel.trackingNumber;
                    [appDelegate sessionStateChanged:session state:state error:error];
                    
                    
                }];
            }
        }
    }
}




- (void) submitAllTrackingItemWithLabel:(NSString *)editedLabel {
    if([ApiClient sharedInstance].allTrackingItem && [[ApiClient sharedInstance].allTrackingItem count] != 0) {
        
        NSMutableDictionary * labelDic = [NSMutableDictionary dictionaryWithDictionary:self.delegate.labelDic];
        [labelDic setObject:editedLabel forKey:self.selectedParcel.trackingNumber];
        
        
        NSMutableArray * numbers = [NSMutableArray array];
        NSMutableArray * labels = [NSMutableArray array];
        
        NSDictionary * locaLabelDic = labelDic;
        
        
        RLMResults *trackItemArray = [Parcel allObjects];
        for(Parcel * item in trackItemArray) {
            [numbers addObject:item.trackingNumber];
            
            NSString * label = [locaLabelDic objectForKey:item.trackingNumber];
            if(label != nil)
                [labels addObject:[locaLabelDic objectForKey:item.trackingNumber]];
            else
                [labels addObject:@""];
            
        }
        
        [[ApiClient sharedInstance] registerTrackingNunmbersNew:numbers WithLabels:labels TrackDetails:[ApiClient sharedInstance].allTrackingItem onSuccess:^(id responseObject)
         {
             NSLog(@"registerTrackingNunmbers success");
             [self.delegate setItem:self.selectedParcel.trackingNumber WithLabel:editedLabel];
         } onFailure:^(NSError *error)
         {
             //NSLog([error localizedDescription]);
         }];
        
    } else {
        
        [[ApiClient sharedInstance] deleteAllTrackingNunmbersOnSuccess:^(id responseObject)
         {
             NSLog(@"deleteAllTrackingNunmbersOnSuccess success");
         } onFailure:^(NSError *error)
         {
             //NSLog([error localizedDescription]);
         }];
        
    }
}

#pragma mark - UITableView DataSource & Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.selectedParcel.deliveryStatus count]) {
        ParcelStatus *parcelStatus = [self.selectedParcel.deliveryStatus objectAtIndex:indexPath.row];
        CGSize statusLabelSize = [parcelStatus.statusDescription boundingRectWithSize:STATUS_LABEL_SIZE
                                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                                           attributes:nil context:nil].size;
        
        CGSize locationLabelSize = [parcelStatus.location boundingRectWithSize:STATUS_LABEL_SIZE
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:nil context:nil].size;
        return MAX(61.0f, MAX(statusLabelSize.height + 12.0f, locationLabelSize.height + 12.0f));
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    NSString *status = maintananceStatuses[@"ReportThis"];
    
    if ([status isEqualToString:@"on"] || [self.selectedParcel.isActive isEqualToString:@"false"])
        return [self.selectedParcel.deliveryStatus count];
    else
        return [self.selectedParcel.deliveryStatus count] + 1;
}

- (void)configureCell:(TrackingItemDetailTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [cell configureCellWithStatus:[self.selectedParcel.deliveryStatus objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.selectedParcel.deliveryStatus count]) {
        static NSString *const cellIdentifier = @"TrackingItemMainTableViewCell";
        
        TrackingItemDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[TrackingItemDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    else {
        static NSString *const feedbackCellIdentifier = @"FeedbackCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:feedbackCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.width - 30, 60)];
            [label setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            label.numberOfLines = 0;
            
            label.text = @"Is the information about your item incorrect? Send a report to SingPost.";
            
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: label.attributedText];
            [text addAttribute: NSForegroundColorAttributeName value:RGB(61, 133, 198) range: NSMakeRange(46,14)];
            UIFont *boldFont = [UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans];
            [text addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(46, 14)];
            
            [label setAttributedText:text];
            [cell addSubview:label];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.selectedParcel.deliveryStatus count])
        return;
    
    TrackingFeedbackViewController *vc = [[TrackingFeedbackViewController alloc] init];
    vc.parcel = self.selectedParcel;
    vc.deliveryStatusArray = self.selectedParcel.deliveryStatus;
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:vc];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Ad Banner

- (void)getAdvertisementWithId : (NSString *)locationMasterId Count:(NSString *)count {
    
    [[ApiClient sharedInstance] getAdvertisementWithId:locationMasterId Count:count onSuccess:^(id responseObject)
     {
         NSArray * adArray = responseObject;
         
         if(adArray == nil || [adArray isKindOfClass:[NSNull class]] || adArray.count == 0) {
             return;
         }
         
         NSDictionary * dic = [adArray objectAtIndex:0];
         UIImage * gifImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:[dic objectForKey:@"assetUrl"]]];
         if(gifImage != nil)
             [adBanner setImage:gifImage];
         else
             [adBanner setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"assetUrl"]]];
         
         
         UIButton * btn = [[UIButton alloc] initWithFrame:adBanner.frame];
         [btn addTarget:self action:@selector(onClickAd:) forControlEvents:UIControlEventTouchUpInside];
         redirectUrl = [dic objectForKey:@"redirectUrl"];
         locationId = [dic objectForKey:@"locationId"];
         
         if(locationId == nil) {
             locationId = [dic objectForKey:@"locId"];
         }
         
         [self.view addSubview:btn];
         
     } onFailure:^(NSError *error)
     {[SVProgressHUD dismiss];}];
    
    
}

- (void)onClickAd :(id)sender{
    [[ApiClient sharedInstance] incrementClickCountWithId:locationId onSuccess:^(id responseObject)
     {
         NSLog(@"incrementClickCountWithId success");
     } onFailure:^(NSError *error)
     {[SVProgressHUD dismiss];}];
    
    if([redirectUrl isKindOfClass:[NSNull class]] || redirectUrl == NULL) {
        redirectUrl = @"http://www.singpost.com";
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl]];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 160; // tweak as needed
    const float movementDuration = 0.1f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
