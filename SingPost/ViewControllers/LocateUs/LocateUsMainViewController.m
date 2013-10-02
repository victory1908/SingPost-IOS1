//
//  LocateUsMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LocateUsMainViewController.h"
#import "NavigationBarView.h"
#import "AppDelegate.h"

#import "CubeTransitionViewController.h"
#import "LocateUsMapViewController.h"
#import "LocateUsListViewController.h"
#import "LocateUsDetailsViewController.h"
#import "UIView+Position.h"

typedef enum {
    LOCATEUS_VIEWMODE_MAP,
    LOCATEUS_VIEWMODE_LIST
} tLocateUsViewModes;

@interface LocateUsMainViewController ()

@end

@implementation LocateUsMainViewController
{
    tLocateUsViewModes currentMode;
    UIButton *toggleModesButton;
    __block BOOL isAnimating;
    
    CubeTransitionViewController *cubeContainerViewController;
    LocateUsListViewController *locateUsListViewController;
    LocateUsMapViewController *locateUsMapViewController;
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
    [toggleModesButton setFrame:CGRectMake(270, 0, 44, 44)];
    [navigationBarView addSubview:toggleModesButton];
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setImage:[UIImage imageNamed:@"reload_button"] forState:UIControlStateNormal];
    [reloadButton setFrame:CGRectMake(230, 0, 44, 44)];
    [navigationBarView addSubview:reloadButton];
    
    locateUsMapViewController = [[LocateUsMapViewController alloc] initWithNibName:nil bundle:nil];
    locateUsListViewController = [[LocateUsListViewController alloc] initWithNibName:nil bundle:nil];
    
    cubeContainerViewController = [[CubeTransitionViewController alloc] initWithViewControllers:@[locateUsMapViewController, locateUsListViewController]];
    [self addChildViewController:cubeContainerViewController];
    [cubeContainerViewController.view setFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [contentView addSubview:cubeContainerViewController.view];
    [cubeContainerViewController didMoveToParentViewController:self];

    self.view = contentView;
}

#pragma mark - IBActions

- (IBAction)toggleButtonClicked:(id)sender
{
    if (!isAnimating) {
        isAnimating = YES;
        switch (currentMode) {
            case LOCATEUS_VIEWMODE_LIST:
            {
                currentMode = LOCATEUS_VIEWMODE_MAP;
                [toggleModesButton setImage:[UIImage imageNamed:@"list_toggle_button"] forState:UIControlStateNormal];
                [(UIScrollView *)locateUsListViewController.view setContentOffset:CGPointZero];
                [cubeContainerViewController animateFromCurrent:locateUsListViewController toNext:locateUsMapViewController forward:NO onCompletion:^{
                    isAnimating = NO;
                }];
                break;
            }
            case LOCATEUS_VIEWMODE_MAP:
            {
                currentMode = LOCATEUS_VIEWMODE_LIST;
                [toggleModesButton setImage:[UIImage imageNamed:@"map_toggle_button"] forState:UIControlStateNormal];
                [(UIScrollView *)locateUsMapViewController.view setContentOffset:CGPointZero];
                [cubeContainerViewController animateFromCurrent:locateUsMapViewController toNext:locateUsListViewController forward:YES onCompletion:^{
                    isAnimating = NO;
                }];
                break;
            }
            default:
                NSAssert(NO, @"unsupported view mode type");
                break;
        }
    }
}

@end
