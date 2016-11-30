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
//#import "UIAlertView+Blocks.h"
#import "SVProgressHUD.h"
#import "EntityLocation.h"

typedef enum {
    LOCATEUS_VIEWMODE_MAP,
    LOCATEUS_VIEWMODE_LIST
} tLocateUsViewModes;

@interface LocateUsMainViewController ()
@property (nonatomic,weak)SVProgressHUD *sVProgressHUD;

@end

@implementation LocateUsMainViewController
{
    tLocateUsViewModes currentMode;
    UIButton *toggleModesButton;
    __block BOOL isAnimating;
    
    CubeTransitionViewController *cubeContainerViewController;
    LocateUsListViewController *locateUsListViewController;
    LocateUsMapViewController *locateUsMapViewController;
    UIActivityIndicatorView *activityIndicator;
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
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setImage:[UIImage imageNamed:@"reload_button"] forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [reloadButton setFrame:CGRectMake(navigationBarView.right - 88, 0, 44, 44)];
    [navigationBarView addSubview:reloadButton];
    
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
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
    }
//    [self updateViewData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self updateViewData];
    
    [UIView createBanner:self];
    
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

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
    [_sVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD show];
    [SVProgressHUD showWithStatus:@"Please wait..."];
    //        [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
    if ([selectedType isEqualToString:LOCATION_TYPE_POST_OFFICE]) {
         [self updateViewData];
        [EntityLocation API_updatePostOfficeLocationsOnCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) [SVProgressHUD showErrorWithStatus:@"Error Synchronise with server"];
            else [self updateViewData];
        }];
    }
    else if ([selectedType isEqualToString:LOCATION_TYPE_POSTING_BOX]) {
        [self updateViewData];
        
        [EntityLocation API_updatePostingBoxLocationsOnCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) [SVProgressHUD showErrorWithStatus:@"Error Synchronise with server"];
            else [self updateViewData];
        }];
    }
    else if ([selectedType isEqualToString:LOCATION_TYPE_SAM]) {
        [self updateViewData];
        
        [EntityLocation API_updateSamLocationsOnCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            
            if (error) [SVProgressHUD showErrorWithStatus:@"Error Synchronise with server"];
            else [self updateViewData];
        }];
    }
    else if ([selectedType isEqualToString:LOCATION_TYPE_POSTAL_AGENT]) {
        [self updateViewData];
        [EntityLocation API_updatePostalAgentLocationsOnCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            [activityIndicator stopAnimating];
            if (error) [SVProgressHUD showErrorWithStatus:@"Error Synchronise with server"];
            else [self updateViewData];
        }];
    }
    else if ([selectedType isEqualToString:LOCATION_TYPE_SINGPOST_AGENT]) {
        [self updateViewData];
        
        [EntityLocation API_updateSingPostAgentLocationsOnCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) [SVProgressHUD showErrorWithStatus:@"Error Synchronise with server"];
            else [self updateViewData];
        }];
    }
    
    else if ([selectedType isEqualToString:LOCATION_TYPE_POPSTATION]) {
        [self updateViewData];
        
        [EntityLocation API_updatePopStationLocationsOnCompletion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) [SVProgressHUD showErrorWithStatus:@"Error Synchronise with server"];
            else [self updateViewData];
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

- (IBAction)reloadButtonClicked:(id)sender {
    [self fetchAndReloadLocationsData];
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
