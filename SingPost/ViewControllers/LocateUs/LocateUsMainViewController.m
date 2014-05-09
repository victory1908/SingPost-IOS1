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
#import <UIAlertView+Blocks.h>
#import <SVProgressHUD.h>
#import "EntityLocation.h"

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
    if (_showNavBarBackButton)
        [navigationBarView setShowBackButton:YES];
    else
        [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    toggleModesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleModesButton setImage:[UIImage imageNamed:@"list_toggle_button"] forState:UIControlStateNormal];
    [toggleModesButton addTarget:self action:@selector(toggleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toggleModesButton setFrame:CGRectMake(navigationBarView.right - 44, 0, 44, 44)];
    [navigationBarView addSubview:toggleModesButton];
    
    locateUsMapViewController = [[LocateUsMapViewController alloc] initWithNibName:nil bundle:nil];
    locateUsMapViewController.delegate = self;
    locateUsListViewController = [[LocateUsListViewController alloc] initWithNibName:nil bundle:nil];
    locateUsListViewController.delegate = self;
    
    cubeContainerViewController = [[CubeTransitionViewController alloc] initWithViewControllers:@[locateUsMapViewController, locateUsListViewController]];
    [self addChildViewController:cubeContainerViewController];
    [cubeContainerViewController.view setFrame:CGRectMake(0, navigationBarView.bounds.size.height, contentView.bounds.size.width, contentView.bounds.size.height - navigationBarView.bounds.size.height)];
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
                [locateUsMapViewController setSearchTerm:locateUsListViewController.searchTerm];
                [locateUsMapViewController setSelectedTypeRowIndex:locateUsListViewController.selectedTypeRowIndex];
                [locateUsMapViewController showFilteredLocationsOnMap];
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
                [locateUsListViewController setSearchTerm:locateUsMapViewController.searchTerm];
                [locateUsListViewController setSelectedTypeRowIndex:locateUsMapViewController.selectedTypeRowIndex];
                [locateUsListViewController reloadData];
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

- (void)fetchAndReloadLocationsData
{
    NSString *selectedType = [self selectedType];
    
    [locateUsMapViewController removeMapAnnotations];
    [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
    if ([selectedType isEqualToString:LOCATION_TYPE_POST_OFFICE]) {
        [EntityLocation API_updatePostOfficeLocationsOnCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            [self updateViewData];
        }];
    }
    else if ([selectedType isEqualToString:LOCATION_TYPE_POSTING_BOX]) {
        [EntityLocation API_updatePostingBoxLocationsOnCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            [self updateViewData];
        }];
    }
    else if ([selectedType isEqualToString:LOCATION_TYPE_SAM]) {
        [EntityLocation API_updateSamLocationsOnCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            [self updateViewData];
        }];
    }
    else if ([selectedType isEqualToString:LOCATION_TYPE_POSTAL_AGENT]) {
        [EntityLocation API_updatePostalAgentLocationsOnCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            [self updateViewData];
        }];
    }
    else if ([selectedType isEqualToString:LOCATION_TYPE_SINGPOST_AGENT]) {
        [EntityLocation API_updateSingPostAgentLocationsOnCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            [self updateViewData];
        }];
    }
    
    else if ([selectedType isEqualToString:LOCATION_TYPE_POPSTATION]) {
        [EntityLocation API_updatePopStationLocationsOnCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            [self updateViewData];
        }];
    }
    else {
        NSAssert(NO, @"unsupported location type");
    }
}

- (void)updateViewData {
    switch (currentMode) {
        case LOCATEUS_VIEWMODE_LIST:
            [locateUsListViewController reloadData];
            break;
            
        case LOCATEUS_VIEWMODE_MAP:
            [locateUsMapViewController showFilteredLocationsOnMap];
            break;
            
        default:
            break;
    }
}

- (IBAction)reloadButtonClicked:(id)sender
{
    NSString *selectedType = [self selectedType];
    
    [UIAlertView showWithTitle:@""
                       message:[NSString stringWithFormat:@"Refreshing the list of %@ may take awhile. Do you wish to proceeed?", selectedType]
             cancelButtonTitle:@"No"
             otherButtonTitles:@[@"Yes"]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex != [alertView cancelButtonIndex]) {
                              [self fetchAndReloadLocationsData];
                          }
                      }];
}

- (NSString *)selectedType
{
    switch (currentMode) {
        case LOCATEUS_VIEWMODE_LIST:
        {
            return locateUsListViewController.selectedLocationType;
            break;
        }
        case LOCATEUS_VIEWMODE_MAP:
        {
            return locateUsMapViewController.selectedLocationType;
        }
        default:
            NSAssert(NO, @"unsupported view mode type");
            return @"";
    }
}

@end
