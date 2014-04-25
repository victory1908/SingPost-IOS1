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
    
    UILabel *moduleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 275, 200, 300)];
    moduleNameLabel.backgroundColor = [UIColor clearColor];
    moduleNameLabel.textColor = RGB(195, 17, 38);
    moduleNameLabel.textAlignment = NSTextAlignmentCenter;
    moduleNameLabel.numberOfLines = 0;
    moduleNameLabel.text = _message;
    [moduleNameLabel alignTop];
    [moduleNameLabel setFont:[UIFont SingPostBoldFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [contentView addSubview:moduleNameLabel];
    
    FlatBlueButton *closeButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, moduleNameLabel.frame.origin.y + moduleNameLabel.frame.size.height + 10, 290 , 48)];
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"CONTINUE TO APP" forState:UIControlStateNormal];
    [contentView addSubview:closeButton];
    
    self.view = contentView;
}

- (IBAction)closeButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
