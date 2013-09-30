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
#import "LocateUsListView.h"

typedef enum {
    LOCATEUS_VIEWMODE_MAP,
    LOCATEUS_VIEWMODE_LIST
} tLocateUsViewModes;

@interface LocateUsMainViewController ()

@end

@implementation LocateUsMainViewController
{
    tLocateUsViewModes currentMode;
    LocateUsMapView *locateUsMapView;
    LocateUsListView *locateUsListView;
    UIButton *toggleModesButton;
    UIScrollView *sectionContentScrollView;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Locate Us"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    toggleModesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleModesButton setImage:[UIImage imageNamed:@"list_toggle_button"] forState:UIControlStateNormal];
    [toggleModesButton addTarget:self action:@selector(toggleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toggleModesButton setFrame:CGRectMake(278, 10, 25, 25)];
    [navigationBarView addSubview:toggleModesButton];
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setImage:[UIImage imageNamed:@"reload_button"] forState:UIControlStateNormal];
    [reloadButton setFrame:CGRectMake(235, 10, 25, 25)];
    [navigationBarView addSubview:reloadButton];
    
    sectionContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [sectionContentScrollView setBackgroundColor:[UIColor clearColor]];
    [sectionContentScrollView setDelaysContentTouches:NO];
    [sectionContentScrollView setPagingEnabled:YES];
    [sectionContentScrollView setScrollEnabled:NO];
    [contentView addSubview:sectionContentScrollView];
    
    locateUsMapView = [[LocateUsMapView alloc] initWithFrame:CGRectMake(sectionContentScrollView.bounds.size.width * LOCATEUS_VIEWMODE_MAP, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [sectionContentScrollView addSubview:locateUsMapView];
    
    locateUsListView = [[LocateUsListView alloc] initWithFrame:CGRectMake(sectionContentScrollView.bounds.size.width * LOCATEUS_VIEWMODE_LIST, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [sectionContentScrollView addSubview:locateUsListView];
    
    self.view = contentView;
}

#pragma mark - IBActions

- (IBAction)toggleButtonClicked:(id)sender
{
    switch (currentMode) {
        case LOCATEUS_VIEWMODE_LIST:
        {
            currentMode = LOCATEUS_VIEWMODE_MAP;
            [toggleModesButton setImage:[UIImage imageNamed:@"list_toggle_button"] forState:UIControlStateNormal];
            break;
        }
        case LOCATEUS_VIEWMODE_MAP:
        {
            currentMode = LOCATEUS_VIEWMODE_LIST;
            [toggleModesButton setImage:[UIImage imageNamed:@"map_toggle_button"] forState:UIControlStateNormal];
            break;
        }
        default:
            NSAssert(NO, @"unsupported view mode type");
            break;
    }
    
    [sectionContentScrollView setContentOffset:CGPointMake(currentMode * sectionContentScrollView.bounds.size.width, 0) animated:YES];
}

@end
