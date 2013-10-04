//
//  LocateUsListViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 1/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LocateUsListViewController.h"
#import "CTextField.h"
#import "FlatBlueButton.h"
#import "CDropDownListControl.h"
#import "FlatBlueButton.h"
#import <MapKit/MapKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "UIView+Position.h"
#import "UIView+Origami.h"
#import "UIFont+SingPost.h"
#import "CMIndexBar.h"
#import "LocateUsLocationTableViewCell.h"
#import "AppDelegate.h"

#import "LocateUsDetailsViewController.h"

#import "EntityLocation.h"

@interface LocateUsListViewController () <CDropDownListControlDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CMIndexBarDelegate, CLLocationManagerDelegate, UITextFieldDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation LocateUsListViewController
{
    TPKeyboardAvoidingScrollView *contentScrollView;
    UITableView *locationsTableView;
    CTextField *findByTextField;
    UILabel *searchLocationsCountLabel;
    CDropDownListControl *typesDropDownList;
    CMIndexBar *indexBar;
    
    CLLocationManager *locationManager;
    
    CLLocation *_cachedUserLocation;
    NSInteger _cachedCurrentTimeDigits;
    
    NSArray *filteredSearchResults;
    
    UIView *animateThisView;
}

- (void)loadView
{
    contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentScrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [contentScrollView setDelaysContentTouches:NO];
    [contentScrollView setBackgroundColor:RGB(250, 250, 250)];
    
    animateThisView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.bounds.size.width, 130)];
    [animateThisView setBackgroundColor:RGB(250, 250, 250)];
    
    findByTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 15, 290, 44)];
    findByTextField.delegate = self;
    [findByTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    findByTextField.placeholderFontSize = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 11.0f : 9.0f;
    findByTextField.insetBoundsSize = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? CGSizeMake(10, 6) : CGSizeMake(10, 10);
    [findByTextField setPlaceholder:@"Find by street name,\nblk no., mrt station etc"];
    [animateThisView addSubview:findByTextField];
    
    UIButton *locateUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locateUsButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [locateUsButton setFrame:CGRectMake(265, 24, 30, 30)];
    [locateUsButton addTarget:self action:@selector(locateUsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [animateThisView addSubview:locateUsButton];

    typesDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(15, 70, 215, 44)];
    [typesDropDownList setPlistValueFile:@"LocateUs_Types"];
    [typesDropDownList setDelegate:self];
    [typesDropDownList selectRow:0 animated:NO];
    [animateThisView addSubview:typesDropDownList];

    FlatBlueButton *goButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(235, 70, 70, 44)];
    [goButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [goButton setTitle:@"GO" forState:UIControlStateNormal];
    [animateThisView addSubview:goButton];
    
//    searchLocationsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, contentScrollView.bounds.size.width, 30)];
//    [searchLocationsCountLabel setBackgroundColor:RGB(125, 136, 149)];
//    [searchLocationsCountLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
//    [searchLocationsCountLabel setTextColor:[UIColor whiteColor]];
//    [contentScrollView addSubview:searchLocationsCountLabel];
    
    
    
    locationsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.bounds.size.width, contentScrollView.bounds.size.height - 155)];
//    [locationsTableView setClipsToBounds:NO];
    [locationsTableView setDelegate:self];
    [locationsTableView setDataSource:self];
    [locationsTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [locationsTableView setBackgroundColor:contentScrollView.backgroundColor];
    [locationsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [locationsTableView setSeparatorColor:[UIColor clearColor]];
    [locationsTableView setBackgroundView:nil];
    [contentScrollView addSubview:locationsTableView];
    
    
//    [locationsTableView addSubview:animateThisView];
    

    indexBar = [[CMIndexBar alloc] initWithFrame:CGRectMake(contentScrollView.bounds.size.width - 30, 100, 28.0, contentScrollView.bounds.size.height - 155)];
    [indexBar setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [indexBar setDelegate:self];
    [indexBar setTextColor:RGB(36, 84, 157)];
    [indexBar setTextFont:[UIFont SingPostRegularFontOfSize:INTERFACE_IS_4INCHSCREEN ? 10.0f : 8.0f fontKey:kSingPostFontOpenSans]];
    [indexBar setIndexes: [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    [contentScrollView addSubview:indexBar];

    self.view = contentScrollView;
}

#define ANIMATION_DURATION 0.3f

- (void)showTopBar:(NSInteger)shouldShowTopBar
{
    [indexBar setHidden:YES];
    if (shouldShowTopBar) {
        NSLog(@"showing top bar");
        [locationsTableView showOrigamiTransitionWith:animateThisView NumberOfFolds:1 Duration:0.5f Direction:XYOrigamiDirectionFromTop completion:^(BOOL finished) {
            [indexBar setHidden:NO];
            [indexBar setY:animateThisView.bounds.size.height andHeight:locationsTableView.bounds.size.height];
            NSLog(@"index bar frame: %@", NSStringFromCGRect(indexBar.frame));
        }];
    }
    else {
        NSLog(@"hiding top bar");
        [locationsTableView hideOrigamiTransitionWith:animateThisView NumberOfFolds:1 Duration:0.5f Direction:XYOrigamiDirectionFromTop completion:^(BOOL finished) {
            [indexBar setHidden:NO];
            [indexBar setY:0 andHeight:locationsTableView.bounds.size.height];
        }];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [contentScrollView setContentSize:contentScrollView.bounds.size];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //setup location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    
    //cache time digits for performance (this is used to determine opening hour indicators)
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HHmm"];
    _cachedCurrentTimeDigits = [[timeFormatter stringFromDate:[NSDate date]] integerValue];
}

- (void)updateNumLocations
{
    [searchLocationsCountLabel setText:[NSString stringWithFormat:@"     %d locations found", [self isSearching] ? filteredSearchResults.count : self.fetchedResultsController.fetchedObjects.count]];
}

#pragma mark - Search

- (BOOL)isSearching
{
    return ([findByTextField.text length] > 0);
}

- (void)filterContentForSearchText:(NSString *)searchText
{
    if ([self isSearching]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@) OR (address CONTAINS[cd] %@)", searchText, searchText];
        filteredSearchResults = [self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:predicate];
    }
    else
        filteredSearchResults = nil;
    
    [locationsTableView reloadData];
    [self updateNumLocations];
}

- (void)resetSearch
{
    [findByTextField setText:@""];
    [self filterContentForSearchText:@""];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self filterContentForSearchText:textField.text];
}

#pragma mark - CDropDownListControlDelegate

- (void)repositionRelativeTo:(CDropDownListControl *)control byVerticalHeight:(CGFloat)offsetHeight
{
    [self.view endEditing:YES];
    
    CGFloat repositionFromY = CGRectGetMaxY(control.frame);
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *subview in contentScrollView.subviews) {
            if (subview.frame.origin.y >= repositionFromY) {
                if (subview.tag != TAG_DROPDOWN_PICKERVIEW)
                    [subview setY:subview.frame.origin.y + offsetHeight];
            }
        }
    } completion:^(BOOL finished) {
        if (offsetHeight > 0)
            [contentScrollView setContentOffset:CGPointMake(0, control.frame.origin.y - 10) animated:YES];
        else
            [contentScrollView setContentOffset:CGPointZero animated:YES];
    }];
}

#pragma mark - IBActions

- (IBAction)locateUsButtonClicked:(id)sender
{
    NSLog(@"locate us clicked");
}

- (IBAction)searchButtonClicked:(id)sender
{
    [self.fetchedResultsController.fetchRequest setPredicate:[self frcSearchPredicate]];
    
    NSError *error = nil;
    if ([self.fetchedResultsController performFetch:&error]) {
        [locationsTableView reloadData];
        [locationsTableView setContentOffset:CGPointZero animated:YES];
        [self updateNumLocations];
    }
}

#pragma mark - CLLocationManagerDelegates

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _cachedUserLocation = newLocation;
    [locationsTableView reloadData];
}

#pragma mark - CMIndexBarDelegate

- (void)indexSelectionDidChange:(CMIndexBar *)indexBar index:(NSInteger)index title:(NSString *)title
{
    NSArray *items = [self isSearching] ? filteredSearchResults : self.fetchedResultsController.fetchedObjects;
    NSInteger scrollToRowIndex = [items indexOfObjectPassingTest:
                                  ^BOOL(EntityLocation *location, NSUInteger idx, BOOL *stop) {
                                      return [location.name hasPrefix:title];
                                  }];
    
    if (scrollToRowIndex != NSNotFound) {
        [locationsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(scrollToRowIndex * 2) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= -20) {
        [self showTopBar:YES];
    }
    else if (scrollView.contentOffset.y >= 20) {
        [self showTopBar:NO];
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
    return [self isSearching] ? 1 : [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self isSearching]) {
        return filteredSearchResults.count * 2;
    }
    else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
        return [sectionInfo numberOfObjects] * 2;
    }
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
    EntityLocation *location;
    
    if ([self isSearching]) {
        int dataIndex = floorf(indexPath.row / 2.0f);
        location = filteredSearchResults[dataIndex];
    }
    else {
        NSIndexPath *dataIndexPath = [NSIndexPath indexPathForRow:floorf((float)indexPath.row / 2.0f) inSection:indexPath.section];
        location = [self.fetchedResultsController objectAtIndexPath:dataIndexPath];
    }

    LocateUsDetailsViewController *viewController = [[LocateUsDetailsViewController alloc] initWithEntityLocation:location];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    EntityLocation *location;
    
    if ([self isSearching]) {
        int dataIndex = floorf(indexPath.row / 2.0f);
        location = filteredSearchResults[dataIndex];
    }
    else {
        NSIndexPath *dataIndexPath = [NSIndexPath indexPathForRow:floorf((float)indexPath.row / 2.0f) inSection:indexPath.section];
        location = [self.fetchedResultsController objectAtIndexPath:dataIndexPath];
    }
    
    LocateUsLocationTableViewCell *locationCell = (LocateUsLocationTableViewCell *)cell;
    [locationCell setLocation:location];
    [locationCell setCachedTimeDigits:_cachedCurrentTimeDigits];
    [locationCell setCachedUserLocation:_cachedUserLocation];
}

#pragma mark - Fetched results controller

- (NSPredicate *)frcSearchPredicate
{
    return [NSPredicate predicateWithFormat:@"type == %@", typesDropDownList.selectedText];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        _fetchedResultsController = [EntityLocation MR_fetchAllGroupedBy:nil withPredicate:[self frcSearchPredicate] sortedBy:EntityLocationAttributes.name ascending:YES delegate:self];
        [self updateNumLocations];
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self resetSearch];
    [locationsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [locationsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [locationsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [locationsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [locationsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[locationsTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [locationsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [locationsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [locationsTableView endUpdates];
}

@end
