//
//  LocateUsMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LocateUsMainViewController.h"
#import "NavigationBarView.h"
#import "LocateUsMapView.h"

@interface LocateUsMainViewController ()

@end

@implementation LocateUsMainViewController
{
    UIView *activeView;
    LocateUsMapView *locateUsMapView;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Locate Us"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    activeView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [activeView setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:activeView];
    
    locateUsMapView = [[LocateUsMapView alloc] initWithFrame:activeView.bounds];
    [activeView addSubview:locateUsMapView];
    
    self.view = contentView;
}

@end
