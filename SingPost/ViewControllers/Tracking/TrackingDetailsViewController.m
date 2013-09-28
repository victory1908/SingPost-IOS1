//
//  TrackingDetailsViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TrackingDetailsViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import <KGModal.h>

@interface TrackingDetailsViewController ()

@end

@implementation TrackingDetailsViewController

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setShowBackButton:YES];
    [navigationBarView setTitle:@"Parcel Information"];
    [contentView addSubview:navigationBarView];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton.layer setBorderWidth:1.0f];
    [infoButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [infoButton setTitle:@"Info" forState:UIControlStateNormal];
    [infoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [infoButton.titleLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setFrame:CGRectMake(255, 7, 50, 30)];
    [navigationBarView addSubview:infoButton];
    
    self.view = contentView;
}

#pragma mark - IBActions

- (IBAction)infoButtonClicked:(id)sender
{
    UIView *contentView = [[UIView alloc] initWithFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(0, 0, 280, 500) : CGRectMake(0, 0, 280, 400)];
    
    CGRect headerLabelRect = contentView.bounds;
    headerLabelRect.origin.y = 20;
    headerLabelRect.size.height = 20;
    UIFont *headerLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerLabelRect];
    headerLabel.text = @"Parcel information";
    headerLabel.font = headerLabelFont;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:headerLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(headerLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
    infoLabel.text = @"Tracking information";
    infoLabel.numberOfLines = 6;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.shadowColor = [UIColor blackColor];
    infoLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:infoLabel];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

@end
