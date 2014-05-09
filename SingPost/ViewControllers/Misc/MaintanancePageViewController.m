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
#import "FlatBlueButton.h"

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
    
    UILabel *moduleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, contentView.height/2, contentView.width - 30, 20)];
    moduleNameLabel.backgroundColor = [UIColor clearColor];
    moduleNameLabel.textColor = RGB(195, 17, 38);
    moduleNameLabel.textAlignment = NSTextAlignmentCenter;
    moduleNameLabel.text = @"Service Unavailable";
    moduleNameLabel.font = [UIFont SingPostBoldFontOfSize:16.0f fontKey:kSingPostFontOpenSans];
    [contentView addSubview:moduleNameLabel];
    
    UILabel *maintananceMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, moduleNameLabel.bottom + 15, contentView.width - 30, 300)];
    maintananceMessageLabel.backgroundColor = [UIColor clearColor];
    maintananceMessageLabel.textColor = RGB(67, 67, 67);
    maintananceMessageLabel.numberOfLines = 0;
    maintananceMessageLabel.textAlignment = NSTextAlignmentCenter;
    maintananceMessageLabel.text = _message;
    maintananceMessageLabel.font = [UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans];
    [maintananceMessageLabel alignTop];
    [contentView addSubview:maintananceMessageLabel];
    
    FlatBlueButton *closeButton = [[FlatBlueButton alloc] initWithFrame:
                                   CGRectMake(15, maintananceMessageLabel.bottom + 15, contentView.width - 30 , 48)];
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"GO BACK" forState:UIControlStateNormal];
    [contentView addSubview:closeButton];
    
    self.view = contentView;
}

- (IBAction)closeButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
