//
//  AnnouncementViewController.m
//  SingPost
//
//  Created by Wei Guang on 7/7/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "NavigationBarView.h"

@interface AnnouncementViewController ()

@end

@implementation AnnouncementViewController

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Announcements"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];

    self.view = contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
