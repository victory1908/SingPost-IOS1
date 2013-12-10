//
//  MaintanancePageViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 5/12/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "MaintanancePageViewController.h"
#import "UIFont+SingPost.h"
#import "UILabel+VerticalAlign.h"

@interface MaintanancePageViewController ()

@end

@implementation MaintanancePageViewController
{
    NSString *_moduleName, *_message;
}

- (id)initWithModuleName:(NSString *)moduleName andMessage:(NSString *)message
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _moduleName = moduleName;
        _message = message;
    }
    
    return self;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:contentView.bounds];
    [backgroundImageView setImage:[UIImage imageNamed:@"maintanance_bg"]];
    [backgroundImageView setContentMode:UIViewContentModeScaleToFill];
    [contentView addSubview:backgroundImageView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(270, 10, 44, 44)];
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeButton];
    
    UILabel *moduleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 275, 200, 20)];
    [moduleNameLabel setBackgroundColor:[UIColor clearColor]];
    [moduleNameLabel setTextColor:RGB(195, 17, 38)];
    [moduleNameLabel setAdjustsFontSizeToFitWidth:YES];
    [moduleNameLabel setTextAlignment:NSTextAlignmentCenter];
    [moduleNameLabel setText:[NSString stringWithFormat:@"%@ Service down", _moduleName]];
    [moduleNameLabel setFont:[UIFont SingPostBoldFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [contentView addSubview:moduleNameLabel];
    
    UILabel *maintananceMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 310, 200, 300)];
    [maintananceMessageLabel setBackgroundColor:[UIColor clearColor]];
    [maintananceMessageLabel setTextColor:RGB(67, 67, 67)];
    [maintananceMessageLabel setNumberOfLines:0];
    [maintananceMessageLabel setTextAlignment:NSTextAlignmentCenter];
    [maintananceMessageLabel setText:_message];
    [maintananceMessageLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [maintananceMessageLabel alignTop];
    [contentView addSubview:maintananceMessageLabel];
    
    self.view = contentView;
}

- (IBAction)closeButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
