//
//  TrackingMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TrackingMainViewController.h"
#import "NavigationBarView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+SingPost.h"
#import "UIColor+SingPost.h"
#import "CTextField.h"
#import "TrackingItemMainTableViewCell.h"
#import "TrackingHeaderMainTableViewCell.h"
#import "TrackingDetailsViewController.h"
#import "AppDelegate.h"
#import <SevenSwitch.h>
#import <KGModal.h>
#import <SVProgressHUD.h>
#import "UIImage+Extensions.h"

#import "ItemTracking.h"

typedef enum {
    TRACKINGITEMS_SECTION_HEADER,
    TRACKINGITEMS_SECTION_ACTIVE,
    TRACKINGITEMS_SECTION_COMPLETED,
    
    TRACKINGITEMS_SECTION_TOTAL
} tTrackingItemsSections;

@interface TrackingMainViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *activeItemsFetchedResultsController;
@property (nonatomic) NSFetchedResultsController *completedItemsFetchedResultsController;


@end

@implementation TrackingMainViewController
{
    CTextField *trackingNumberTextField;
    UITableView *trackingItemsTableView;
    SevenSwitch *receiveUpdateSwitch;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    //navigation bar
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setShowSidebarToggleButton:YES];
    [navigationBarView setTitle:@"Track"];
    [contentView addSubview:navigationBarView];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton.layer setBorderWidth:1.0f];
    [infoButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [infoButton setBackgroundImage:nil forState:UIControlStateNormal];
    [infoButton setBackgroundImage:[UIImage imageWithColor:RGB(76, 109, 166)] forState:UIControlStateHighlighted];
    [infoButton setTitle:@"Info" forState:UIControlStateNormal];
    [infoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoButton.titleLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setFrame:CGRectMake(255, 7, 50, 30)];
    [navigationBarView addSubview:infoButton];

    trackingItemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    [trackingItemsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [trackingItemsTableView setSeparatorColor:[UIColor clearColor]];
    [trackingItemsTableView setDelegate:self];
    [trackingItemsTableView setDataSource:self];
    [trackingItemsTableView setBackgroundColor:[UIColor whiteColor]];
    [trackingItemsTableView setBackgroundView:nil];
    [contentView addSubview:trackingItemsTableView];
    
    self.view = contentView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [trackingNumberTextField resignFirstResponder];
}

#pragma mark - Accessors

- (void)setTrackingNumber:(NSString *)inTrackingNumber
{
    _trackingNumber = inTrackingNumber;
    [trackingNumberTextField setText:_trackingNumber];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == trackingNumberTextField)
        [self findTrackingNumberButtonClicked:nil];
    return YES;
}

#pragma mark - IBActions

- (IBAction)findTrackingNumberButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeClear];
    [ItemTracking API_getItemTrackingDetailsForTrackingNumber:trackingNumberTextField.text onCompletion:^(BOOL success, NSError *error) {
        if (success) {
            [SVProgressHUD dismiss];
        }
        else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

- (IBAction)reloadTrackingItemsButtonClicked:(id)sender
{
    tTrackingItemsSections section = [(UIButton *)sender tag];
    
    NSArray *itemsToReload;
    
    if (section == TRACKINGITEMS_SECTION_ACTIVE)
        itemsToReload = [self.activeItemsFetchedResultsController fetchedObjects];
    else if (section == TRACKINGITEMS_SECTION_COMPLETED)
        itemsToReload = [self.completedItemsFetchedResultsController fetchedObjects];
    
    __block CGFloat updateProgress = 0.0f;
    [SVProgressHUD showProgress:updateProgress status:@"Updating items.." maskType:SVProgressHUDMaskTypeClear];
    [ItemTracking API_batchUpdateTrackedItems:itemsToReload onCompletion:^(BOOL success, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"An error has occurred"];
        }
        else {
            [SVProgressHUD dismiss];
        }
    } withProgressCompletion:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        updateProgress = ((float)numberOfFinishedOperations / (float)totalNumberOfOperations);
        [SVProgressHUD showProgress:updateProgress status:@"Updating items.." maskType:SVProgressHUDMaskTypeClear];
    }];
}

- (IBAction)infoButtonClicked:(id)sender
{
    UIView *contentView = [[UIView alloc] initWithFrame:INTERFACE_IS_4INCHSCREEN ? CGRectMake(0, 0, 280, 500) : CGRectMake(0, 0, 280, 400)];
    
    CGRect headerLabelRect = contentView.bounds;
    headerLabelRect.origin.y = 20;
    headerLabelRect.size.height = 20;
    UIFont *headerLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerLabelRect];
    headerLabel.text = @"Tracking information";
    headerLabel.font = headerLabelFont;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:headerLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(headerLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
    infoLabel.text = @"Tracking information";
    infoLabel.numberOfLines = 6;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.shadowColor = [UIColor blackColor];
    infoLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:infoLabel];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

#pragma mark - UITableView DataSource & Delegate

- (void)configureCell:(TrackingItemMainTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TRACKINGITEMS_SECTION_ACTIVE) {
        cell.item = [self.activeItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        [cell setHideSeparatorView:indexPath.row == (self.activeItemsFetchedResultsController.fetchedObjects.count)];
    }
    else if (indexPath.section == TRACKINGITEMS_SECTION_COMPLETED) {
        cell.item = [self.completedItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        [cell setHideSeparatorView:indexPath.row == (self.completedItemsFetchedResultsController.fetchedObjects.count)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return indexPath.section == TRACKINGITEMS_SECTION_HEADER ? 140.0f : 30.0f;
    
    ItemTracking *trackedItem;
    if (indexPath.section == TRACKINGITEMS_SECTION_ACTIVE)
        trackedItem = [self.activeItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
    else if (indexPath.section == TRACKINGITEMS_SECTION_COMPLETED)
        trackedItem = [self.completedItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];

    CGSize statusLabelSize = [trackedItem.status sizeWithFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans] constrainedToSize:STATUS_LABEL_SIZE];

    return MAX(60, statusLabelSize.height + 14);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == TRACKINGITEMS_SECTION_HEADER ? 0.0f : 50.0f;
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
    return TRACKINGITEMS_SECTION_TOTAL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == TRACKINGITEMS_SECTION_HEADER)
        return 1;
    
    NSInteger HEADER_COUNT = 1;
    
    if (section == TRACKINGITEMS_SECTION_ACTIVE) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.activeItemsFetchedResultsController.sections objectAtIndex:0];
        return HEADER_COUNT + [sectionInfo numberOfObjects];
    }
        
    if (section == TRACKINGITEMS_SECTION_COMPLETED) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.completedItemsFetchedResultsController.sections objectAtIndex:0];
        return HEADER_COUNT + [sectionInfo numberOfObjects];
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == TRACKINGITEMS_SECTION_HEADER)
        return nil;
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
    [sectionHeaderView setBackgroundColor:RGB(240, 240, 240)];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)];
    [topSeparatorView setBackgroundColor:RGB(231, 232, 233)];
    [sectionHeaderView addSubview:topSeparatorView];
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, tableView.bounds.size.width, 1)];
    [bottomSeparatorView setBackgroundColor:RGB(231, 232, 233)];
    [sectionHeaderView addSubview:bottomSeparatorView];

    switch ((tTrackingItemsSections)section) {
        case TRACKINGITEMS_SECTION_ACTIVE:
        {
            UILabel *activeItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 300, 44)];
            [activeItemsLabel setTextColor:RGB(195, 17, 38)];
            [activeItemsLabel setText:@"Active items"];
            [activeItemsLabel setBackgroundColor:[UIColor clearColor]];
            [activeItemsLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [sectionHeaderView addSubview:activeItemsLabel];
            
//            UIButton *numActiveItemsButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [numActiveItemsButton setBackgroundImage:[UIImage imageNamed:@"blue_circle"] forState:UIControlStateNormal];
//            [numActiveItemsButton.titleLabel setFont:[UIFont SingPostSemiboldFontOfSize:7.0f fontKey:kSingPostFontOpenSans]];
//            [numActiveItemsButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 1, 0, 0)];
//            [numActiveItemsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [numActiveItemsButton setTitle:@"1" forState:UIControlStateNormal];
//            [numActiveItemsButton setFrame:CGRectMake(105, 12, 14, 14)];
//            [sectionHeaderView addSubview:numActiveItemsButton];
            
            UIButton *reloadTrackingItemsButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [reloadTrackingItemsButton setImage:[UIImage imageNamed:@"reload_button_orange"] forState:UIControlStateNormal];
            [reloadTrackingItemsButton setFrame:CGRectMake(260, 3, 44, 44)];
            [reloadTrackingItemsButton setTag:TRACKINGITEMS_SECTION_ACTIVE];
            [reloadTrackingItemsButton addTarget:self action:@selector(reloadTrackingItemsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [sectionHeaderView addSubview:reloadTrackingItemsButton];
            break;
        }
        case TRACKINGITEMS_SECTION_COMPLETED: {
            UILabel *completedItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 300, 44)];
            [completedItemsLabel setTextColor:RGB(125, 136, 149)];
            [completedItemsLabel setText:@"Completed items"];
            [completedItemsLabel setBackgroundColor:[UIColor clearColor]];
            [completedItemsLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
            [sectionHeaderView addSubview:completedItemsLabel];
            break;
        }
        default:
            NSAssert(NO, @"unsupported TRACKINGITEMS_SECTION");
            break;
    }
    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const headerCellIdentifier = @"TrackingHeaderMainTableViewCell";
    static NSString *const itemCellIdentifier = @"TrackingItemMainTableViewCell";
    static NSString *const trackingCellIdentifier = @"TrackingCell";
    
    if (indexPath.section == TRACKINGITEMS_SECTION_HEADER) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:trackingCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:trackingCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            trackingNumberTextField = [[CTextField alloc] initWithFrame:CGRectMake(15, 21, 290, 47)];
            [trackingNumberTextField setPlaceholder:@"Last tracking number entered"];
            [trackingNumberTextField setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
            [trackingNumberTextField setFontSize:16.0f];
            [trackingNumberTextField setReturnKeyType:UIReturnKeySend];
            [trackingNumberTextField setInsetBoundsSize:CGSizeMake(14, 12)];
            [trackingNumberTextField setText:_trackingNumber];
            [trackingNumberTextField setDelegate:self];
            [cell.contentView addSubview:trackingNumberTextField];
            
            UIButton *findTrackingNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [findTrackingNumberButton setImage:[UIImage imageNamed:@"tracking_button"] forState:UIControlStateNormal];
            [findTrackingNumberButton setFrame:CGRectMake(265, 29, 35, 35)];
            [findTrackingNumberButton addTarget:self action:@selector(findTrackingNumberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:findTrackingNumberButton];
            
            UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 77, 220, 50)];
            [instructionsLabel setFont:[UIFont SingPostRegularFontOfSize:11.0f fontKey:kSingPostFontOpenSans]];
            [instructionsLabel setText:@"Turn on push notification to auto-receive\nlatest status updates of item(s) you are\ncurrently tracking"];
            [instructionsLabel setNumberOfLines:0];
            [instructionsLabel setTextColor:RGB(51, 51, 51)];
            [instructionsLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:instructionsLabel];
            
            receiveUpdateSwitch = [[SevenSwitch alloc] initWithFrame:CGRectZero];
            receiveUpdateSwitch.onTintColor = [UIColor SingPostBlueColor];
            receiveUpdateSwitch.inactiveColor = [UIColor lightGrayColor];
            receiveUpdateSwitch.center = CGPointMake(278, 104);
            receiveUpdateSwitch.on = YES;
            [cell.contentView addSubview:receiveUpdateSwitch];
        }
        
        return cell;
    }

    if (indexPath.row == 0) {
        TrackingHeaderMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
        if (!cell) {
            cell = [[TrackingHeaderMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
        }
        
        if (indexPath.section == TRACKINGITEMS_SECTION_ACTIVE) {
            [cell setHideSeparatorView:self.activeItemsFetchedResultsController.fetchedObjects.count == 0];
        }
        else if (indexPath.section == TRACKINGITEMS_SECTION_COMPLETED) {
            [cell setHideSeparatorView:self.completedItemsFetchedResultsController.fetchedObjects.count == 0];
        }

        return cell;
    }
    else {
        TrackingItemMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
        if (!cell)
            cell = [[TrackingItemMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TRACKINGITEMS_SECTION_HEADER) {
        [self.view endEditing:YES];
    }
    else {
        ItemTracking *trackedItem;
        if (indexPath.section == TRACKINGITEMS_SECTION_ACTIVE)
            trackedItem = [self.activeItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        else if (indexPath.section == TRACKINGITEMS_SECTION_COMPLETED)
            trackedItem = [self.completedItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        
        TrackingDetailsViewController *trackingDetailsViewController = [[TrackingDetailsViewController alloc] initWithTrackedItem:trackedItem];
        [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:trackingDetailsViewController];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section != TRACKINGITEMS_SECTION_HEADER && indexPath.row > 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ItemTracking *trackedItemToDelete = nil;
        if (indexPath.section == TRACKINGITEMS_SECTION_ACTIVE)
            trackedItemToDelete = [self.activeItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        else if (indexPath.section == TRACKINGITEMS_SECTION_COMPLETED)
            trackedItemToDelete = [self.completedItemsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        
        [ItemTracking deleteTrackedItem:trackedItemToDelete];
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)activeItemsFetchedResultsController
{
    if (!_activeItemsFetchedResultsController) {
        _activeItemsFetchedResultsController = [ItemTracking MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"isActive == 1"] sortedBy:ItemTrackingAttributes.addedOn ascending:NO delegate:self];
    }
    
    return _activeItemsFetchedResultsController;
}

- (NSFetchedResultsController *)completedItemsFetchedResultsController
{
    if (!_completedItemsFetchedResultsController) {
        _completedItemsFetchedResultsController = [ItemTracking MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"isActive == 0"] sortedBy:ItemTrackingAttributes.addedOn ascending:NO delegate:self];
    }
    
    return _completedItemsFetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [trackingItemsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [trackingItemsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [trackingItemsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSInteger section = TRACKINGITEMS_SECTION_HEADER;
    NSInteger rowCount = 0;
    if (controller == self.activeItemsFetchedResultsController) {
        section = TRACKINGITEMS_SECTION_ACTIVE;
        rowCount = self.activeItemsFetchedResultsController.fetchedObjects.count;
    }
    else if (controller == self.completedItemsFetchedResultsController) {
        section = TRACKINGITEMS_SECTION_COMPLETED;
        rowCount = self.activeItemsFetchedResultsController.fetchedObjects.count;
    }
    
    NSLog(@"my row count: %d", rowCount);
    NSIndexPath *dataIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row + 1 inSection:section];
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            if (rowCount == 1)
                [trackingItemsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
            [trackingItemsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:dataIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            if (rowCount == 0)
                [trackingItemsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
            [trackingItemsTableView deleteRowsAtIndexPaths:@[dataIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(TrackingItemMainTableViewCell *)[trackingItemsTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [trackingItemsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:dataIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [trackingItemsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [trackingItemsTableView endUpdates];
}

@end
