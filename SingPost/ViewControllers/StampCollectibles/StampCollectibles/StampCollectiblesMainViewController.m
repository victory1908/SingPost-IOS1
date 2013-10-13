//
//  StampCollectiblesMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 14/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "StampCollectiblesMainViewController.h"
#import "NavigationBarView.h"
#import "CDropDownListControl.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"
#import "DatabaseSeeder.h"
#import "Stamp.h"
#import "StampCollectiblesTableViewCell.h"

@interface StampCollectiblesMainViewController () <CDropDownListControlDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation StampCollectiblesMainViewController
{
    UIScrollView *contentScrollView;
    UILabel *chosenYearLabel;
    CDropDownListControl *yearDropDownList;
    UITableView *stampsTableView;
}

- (void)loadView
{
    contentScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentScrollView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Stamp Collectibles"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentScrollView addSubview:navigationBarView];
    
    UIImageView *featuredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, contentScrollView.bounds.size.width, 186)];
    [featuredImageView setImage:[UIImage imageNamed:@"sample_stamps_featured_image"]];
    [contentScrollView addSubview:featuredImageView];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 230, contentScrollView.bounds.size.width, 0.5f)];
    [topSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [topSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentScrollView addSubview:topSeparatorView];
    
    UIView *yearSectionBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 230.5, contentScrollView.bounds.size.width, 60)];
    [yearSectionBackgroundView setBackgroundColor:RGB(240, 240, 240)];
    [contentScrollView addSubview:yearSectionBackgroundView];
    
    chosenYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 240, 200, 44)];
    [chosenYearLabel setBackgroundColor:[UIColor clearColor]];
    [chosenYearLabel setTextColor:RGB(195, 17, 38)];
    [chosenYearLabel setText:@"2013 Collections"];
    [chosenYearLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [contentScrollView addSubview:chosenYearLabel];
    
    yearDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(contentScrollView.bounds.size.width - 95, 240, 80, 44)];
    [yearDropDownList setValues:@[@{@"code": @"2013 Collections", @"value": @"2013"}, @{@"code": @"2012 Collections", @"value": @"2012"}]];
    [yearDropDownList setDelegate:self];
    [yearDropDownList selectRow:0 animated:NO];
    [contentScrollView addSubview:yearDropDownList];
    
    stampsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 290.5, contentScrollView.bounds.size.width, contentScrollView.bounds.size.height - 290.5 - [UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    [stampsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [stampsTableView setSeparatorColor:[UIColor clearColor]];
    [stampsTableView setBackgroundView:nil];
    [stampsTableView setDelegate:self];
    [stampsTableView setDataSource:self];
    [stampsTableView setBackgroundColor:[UIColor whiteColor]];
    [contentScrollView addSubview:stampsTableView];

    self.view = contentScrollView;
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
            [contentScrollView setContentOffset:CGPointMake(0, control.frame.origin.y - 50) animated:YES];
        else
            [contentScrollView setContentOffset:CGPointZero animated:YES];
    }];
}

- (void)dropDownListIsDismissed:(CDropDownListControl *)control
{
    if (control == yearDropDownList)
        [chosenYearLabel setText:yearDropDownList.selectedValue];
}

#pragma mark - UITableView DataSource & Delegate

- (void)configureCell:(StampCollectiblesTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.stamp = [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const itemCellIdentifier = @"StampsCollectiblesItemTableViewCell";
    
    StampCollectiblesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
    if (!cell) {
        cell = [[StampCollectiblesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        _fetchedResultsController = [Stamp MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:StampAttributes.ordering ascending:YES delegate:self];
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [stampsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [stampsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [stampsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
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
            [stampsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [stampsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(StampCollectiblesTableViewCell *)[stampsTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [stampsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [stampsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [stampsTableView endUpdates];
}

@end
