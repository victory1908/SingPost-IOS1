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
#import "StampCollectiblesDetailsViewController.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface StampCollectiblesMainViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CDropDownListControlDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation StampCollectiblesMainViewController
{
    UIScrollView *contentScrollView;
    UILabel *chosenYearLabel;
    CDropDownListControl *yearDropDownList;
    UITableView *stampsTableView;
    UIImageView *featuredImageView;
}

- (void)loadView
{
    contentScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentScrollView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Stamp Collectibles"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentScrollView addSubview:navigationBarView];
    
    featuredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, contentScrollView.bounds.size.width, 186)];
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
    [chosenYearLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [contentScrollView addSubview:chosenYearLabel];
    
    yearDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(contentScrollView.bounds.size.width - 95, 240, 80, 44)];
    [yearDropDownList setDelegate:self];
    [contentScrollView addSubview:yearDropDownList];
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 290.5, contentScrollView.bounds.size.width, 0.5f)];
    [bottomSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [bottomSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentScrollView addSubview:bottomSeparatorView];
    
    stampsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 291, contentScrollView.bounds.size.width, contentScrollView.bounds.size.height - 291 - [UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    [stampsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [stampsTableView setSeparatorColor:[UIColor clearColor]];
    [stampsTableView setBackgroundView:nil];
    [stampsTableView setDelegate:self];
    [stampsTableView setDataSource:self];
    [stampsTableView setBackgroundColor:[UIColor whiteColor]];
    [contentScrollView addSubview:stampsTableView];

    self.view = contentScrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"Please wait.."];
    
    __weak StampCollectiblesMainViewController *weakSelf = self;
    [Stamp API_getStampsOnCompletion:^(BOOL success, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"An error has occurred"];
        }
        else {
            [featuredImageView setImageWithURL:[NSURL URLWithString:[Stamp featuredStamp].coverImage] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [yearDropDownList setValues:[Stamp yearsDropDownValues]];
            [yearDropDownList selectRow:0 animated:NO];
            [weakSelf yearDropDownListSelected];
            [SVProgressHUD dismiss];
        }
    }];
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
    StampCollectiblesDetailsViewController *detailsViewController = [[StampCollectiblesDetailsViewController alloc] initWithStamp:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:detailsViewController];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Fetched results controller

- (NSPredicate *)frcSearchPredicate
{
    return [NSPredicate predicateWithFormat:@"year == %@", yearDropDownList.selectedText];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        _fetchedResultsController = [Stamp MR_fetchAllGroupedBy:nil withPredicate:[self frcSearchPredicate] sortedBy:StampAttributes.ordering ascending:YES delegate:self];
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

#pragma mark - CDropDownListDelegate

- (void)yearDropDownListSelected
{
    [chosenYearLabel setText:yearDropDownList.selectedValue];
    [self.fetchedResultsController.fetchRequest setPredicate:[self frcSearchPredicate]];
    
    NSError *error = nil;
    if ([self.fetchedResultsController performFetch:&error]) {
        [stampsTableView reloadData];
        [stampsTableView setContentOffset:CGPointZero animated:YES];
    }
}

- (void)CDropDownListControlDismissed:(CDropDownListControl *)dropDownListControl
{
    [self yearDropDownListSelected];
}

@end
