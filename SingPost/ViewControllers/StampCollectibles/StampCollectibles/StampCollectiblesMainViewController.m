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
#import "UIView+Origami.h"
#import "DatabaseSeeder.h"
#import "Stamp.h"
#import "StampCollectiblesTableViewCell.h"
#import "StampCollectiblesDetailsViewController.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface StampCollectiblesMainViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CDropDownListControlDelegate,UIScrollViewDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation StampCollectiblesMainViewController
{
    UIScrollView *contentScrollView;
    UILabel *chosenYearLabel;
    CDropDownListControl *yearDropDownList;
    UITableView *stampsTableView;
    UIImageView *featuredImageView;
    UIView * searchTermsView, * searchResultsContainerView;
    
    
}

- (void)loadView
{
    contentScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentScrollView setBackgroundColor:RGB(250, 250, 250)];
    
    searchTermsView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, contentScrollView.bounds.size.width, 186)];
    [searchTermsView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Stamp Collectibles"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentScrollView addSubview:navigationBarView];
    
    featuredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.bounds.size.width, 186)];
    [featuredImageView setContentMode:UIViewContentModeScaleAspectFit];
    [searchTermsView addSubview:featuredImageView];
    
    searchResultsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, contentScrollView.bounds.size.width, contentScrollView.bounds.size.height - 64)];
    [contentScrollView addSubview:searchResultsContainerView];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 230-44-186, contentScrollView.bounds.size.width, 0.5f)];
    [topSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [topSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [searchResultsContainerView addSubview:topSeparatorView];
    
    UIView *yearSectionBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 230.5- 44-186, contentScrollView.bounds.size.width, 60)];
    [yearSectionBackgroundView setBackgroundColor:RGB(240, 240, 240)];
    [searchResultsContainerView addSubview:yearSectionBackgroundView];
    
    chosenYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 240-44-186, 200, 44)];
    [chosenYearLabel setBackgroundColor:[UIColor clearColor]];
    [chosenYearLabel setTextColor:RGB(195, 17, 38)];
    [chosenYearLabel setFont:[UIFont SingPostLightFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
    [searchResultsContainerView addSubview:chosenYearLabel];
    
    yearDropDownList = [[CDropDownListControl alloc] initWithFrame:CGRectMake(contentScrollView.bounds.size.width - 95, 240-44-186, 80, 44)];
    [yearDropDownList setDelegate:self];
    [searchResultsContainerView addSubview:yearDropDownList];
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 290.5-44-186, contentScrollView.bounds.size.width, 0.5f)];
    [bottomSeparatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [bottomSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [searchResultsContainerView addSubview:bottomSeparatorView];
    
    stampsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 291-44-186, contentScrollView.bounds.size.width, contentScrollView.bounds.size.height - 291 - [UIApplication sharedApplication].statusBarFrame.size.height + 186) style:UITableViewStylePlain];
    [stampsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [stampsTableView setSeparatorColor:[UIColor clearColor]];
    [stampsTableView setBackgroundView:nil];
    [stampsTableView setDelegate:self];
    [stampsTableView setDataSource:self];
    [stampsTableView setBackgroundColor:[UIColor whiteColor]];
    [searchResultsContainerView addSubview:stampsTableView];
    
    self.view = contentScrollView;
    
    contentScrollView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSArray *stamps = [[NSArray alloc] init];
//    stamps = [Stamp MR_findAll];
//    
//    Stamp *stamp = [stamps objectAtIndex:0];
//    NSLog(@"test stamp %@",stamp.details);
//    self.fetchedResultsController = stamps;
    
    
    __weak StampCollectiblesMainViewController *weakSelf = self;
    
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        [SVProgressHUD showWithStatus:@"Please wait.."];
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
    
    [self showSearchTermsView:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] trackGoogleAnalyticsWithScreenName:@"Stamp Collectibles"];
}

#pragma mark - UITableView DataSource & Delegate

- (void)configureCell:(StampCollectiblesTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.stamp = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"test stamp %@",cell.stamp.details);
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
        _fetchedResultsController = [Stamp MR_fetchAllGroupedBy:nil withPredicate:[self frcSearchPredicate] sortedBy:StampAttributes.issueDate ascending:NO delegate:self];
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
        case NSFetchedResultsChangeMove: break;
        case NSFetchedResultsChangeUpdate: break;
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

#define ANIMATION_DURATION 0.5f

- (void)showSearchTermsView:(BOOL)shouldShowSearchTermsView
{
    if ((shouldShowSearchTermsView && isSearchTermViewShown) || (!shouldShowSearchTermsView && !isSearchTermViewShown)) {
        return;
    }
    
    if (!isAnimating) {
        isAnimating = YES;
        [self.view endEditing:YES];
        [stampsTableView setBounces:NO];
        if (!shouldShowSearchTermsView)
            [stampsTableView setScrollEnabled:NO];
        
        if (shouldShowSearchTermsView) {
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                //[indexBar setHeight:INTERFACE_IS_4INCHSCREEN ? 345 : 255];
            }];
            [searchResultsContainerView showOrigamiTransitionWith:searchTermsView NumberOfFolds:1 Duration:ANIMATION_DURATION Direction:XYOrigamiDirectionFromTop completion:^(BOOL finished) {
                [stampsTableView setBounces:YES];
                
                isSearchTermViewShown = YES;
                isAnimating = NO;
            }];
        }
        else {
            [yearDropDownList resignFirstResponder];
            [stampsTableView setContentOffset:CGPointZero];
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                //[indexBar setHeight:INTERFACE_IS_4INCHSCREEN ? 475 : 385];
            }];
            [searchResultsContainerView hideOrigamiTransitionWith:searchTermsView NumberOfFolds:1 Duration:ANIMATION_DURATION Direction:XYOrigamiDirectionFromTop completion:^(BOOL finished) {
                [stampsTableView setBounces:YES];
                [stampsTableView setScrollEnabled:YES];
                
                isSearchTermViewShown = NO;
                isAnimating = NO;
            }];
        }
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isTracking) {
        if (scrollView.contentOffset.y < 0)
            [self showSearchTermsView:YES];
        else if (scrollView.contentOffset.y >= 0)
            [self showSearchTermsView:NO];
    }
}


@end
