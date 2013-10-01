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
#import "LocateUsLocationTableViewCell.h"
#import "CMIndexBar.h"
#import "AppDelegate.h"

#import "EntityLocation.h"

#import "LocateUsDetailsViewController.h"

typedef enum {
    LOCATEUS_VIEWMODE_MAP,
    LOCATEUS_VIEWMODE_LIST
} tLocateUsViewModes;

@interface LocateUsMainViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate, CMIndexBarDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation LocateUsMainViewController
{
    tLocateUsViewModes currentMode;
    LocateUsMapView *locateUsMapView;
    LocateUsListView *locateUsListView;
    UIButton *toggleModesButton;
    UIScrollView *sectionContentScrollView;
    
    CLLocationManager *locationManager;
    
    NSInteger _cachedCurrentTimeDigits;
    CLLocation *_cachedUserLocation;
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
    
    sectionContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [sectionContentScrollView setBackgroundColor:[UIColor clearColor]];
    [sectionContentScrollView setDelaysContentTouches:NO];
    [sectionContentScrollView setPagingEnabled:YES];
    [sectionContentScrollView setScrollEnabled:NO];
    [contentView addSubview:sectionContentScrollView];
    
    locateUsMapView = [[LocateUsMapView alloc] initWithFrame:CGRectMake(sectionContentScrollView.bounds.size.width * LOCATEUS_VIEWMODE_MAP, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [sectionContentScrollView addSubview:locateUsMapView];
    
    locateUsListView = [[LocateUsListView alloc] initWithFrame:CGRectMake(sectionContentScrollView.bounds.size.width * LOCATEUS_VIEWMODE_LIST, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [locateUsListView setDelegate:self];
    [sectionContentScrollView addSubview:locateUsListView];
    
    [sectionContentScrollView setContentSize:CGSizeMake(sectionContentScrollView.bounds.size.width * 2, sectionContentScrollView.bounds.size.height)];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    //cache time digits for performance
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HHmm"];
    _cachedCurrentTimeDigits = [[timeFormatter stringFromDate:[NSDate date]] integerValue];
}

#pragma mark - CLLocationManagerDelegates

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _cachedUserLocation = newLocation;
    [locateUsListView.locationsTableView reloadRowsAtIndexPaths:[locateUsListView.locationsTableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
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

#pragma mark - CMIndexBarDelegate

- (void)indexSelectionDidChange:(CMIndexBar *)indexBar index:(NSInteger)index title:(NSString *)title
{
    NSInteger scrollToRowIndex = [self.fetchedResultsController.fetchedObjects indexOfObjectPassingTest:
                                  ^BOOL(EntityLocation *location, NSUInteger idx, BOOL *stop) {
                                      return [location.name hasPrefix:title];
                                  }];
    
    if (scrollToRowIndex != NSNotFound) {
        [locateUsListView.locationsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(scrollToRowIndex * 2) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - UITableView DataSource & Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2 == 0) ? 60.0f : 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects] * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const itemCellIdentifier = @"LocateUsLocationTableViewCell";
    static NSString *const separatorCellIdentifier = @"SeparatorTableViewCell";
    
    if ((indexPath.row % 2) == 0) {
        LocateUsLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
        if (!cell)
            cell = [[LocateUsLocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:separatorCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:separatorCellIdentifier];
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, 1)];
            [separatorView setBackgroundColor:RGB(196, 197, 200)];
            [cell.contentView addSubview:separatorView];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *dataIndexPath = [NSIndexPath indexPathForRow:floorf((float)indexPath.row / 2.0f) inSection:indexPath.section];
    EntityLocation *entityLocation = [self.fetchedResultsController objectAtIndexPath:dataIndexPath];
    LocateUsDetailsViewController *viewController = [[LocateUsDetailsViewController alloc] initWithEntityLocation:entityLocation];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *dataIndexPath = [NSIndexPath indexPathForRow:floorf((float)indexPath.row / 2.0f) inSection:indexPath.section];
    LocateUsLocationTableViewCell *locationCell = (LocateUsLocationTableViewCell *)cell;
    [locationCell setLocation:[self.fetchedResultsController objectAtIndexPath:dataIndexPath]];
    [locationCell setCachedTimeDigits:_cachedCurrentTimeDigits];
    [locationCell setCachedUserLocation:_cachedUserLocation];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        _fetchedResultsController = [EntityLocation MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"type == %@", @"Post Office"] sortedBy:EntityLocationAttributes.name ascending:YES delegate:self];
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (currentMode == LOCATEUS_VIEWMODE_LIST)
        [locateUsListView.locationsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if (currentMode == LOCATEUS_VIEWMODE_LIST) {
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [locateUsListView.locationsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [locateUsListView.locationsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (currentMode == LOCATEUS_VIEWMODE_LIST) {
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [locateUsListView.locationsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [locateUsListView.locationsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self configureCell:[locateUsListView.locationsTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
                
            case NSFetchedResultsChangeMove:
                [locateUsListView.locationsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [locateUsListView.locationsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (currentMode == LOCATEUS_VIEWMODE_LIST)
        [locateUsListView.locationsTableView endUpdates];
}

@end
