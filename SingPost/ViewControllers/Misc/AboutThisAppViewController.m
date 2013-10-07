//
//  AboutThisAppViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "AboutThisAppViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"

@interface AboutThisAppViewController ()

@end

@implementation AboutThisAppViewController

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"About This App"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    UILabel *loremIpsumLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, navigationBarView.frame.size.height + 10, contentView.bounds.size.width - 30, 400)];
    [loremIpsumLabel setNumberOfLines:0];
    [loremIpsumLabel setText:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."];
    [loremIpsumLabel setTextColor:RGB(51, 51, 51)];
    [loremIpsumLabel setBackgroundColor:[UIColor clearColor]];
    [loremIpsumLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    
    [contentView addSubview:loremIpsumLabel];
    
    self.view = contentView;
}

@end
