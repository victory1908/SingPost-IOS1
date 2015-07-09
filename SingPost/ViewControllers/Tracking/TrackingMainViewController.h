//
//  TrackingMainViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"
#import "CustomIOS7AlertView.h"

@interface TrackingMainViewController : SwipeViewController <CustomIOS7AlertViewDelegate>{
    UITableView *trackingItemsTableView;
}

@property (nonatomic) NSString *trackingNumber;

@property (nonatomic,assign) BOOL isOn;
@property (nonatomic,assign) BOOL isDeleteAll;

@property BOOL isPushNotification;
@property BOOL isFirstTimeUser;

@property (nonatomic,retain)NSMutableDictionary * labelDic;

@property (nonatomic,retain)UITableView *trackingItemsTableView;

@property (nonatomic) NSFetchedResultsController *allItemsFetchedResultsController;

- (void)addTrackingNumber:(NSString *)trackingNumber;

- (void)refreshTableView;
- (void)setItem:(NSString *)number WithLabel:(NSString *)label;
- (void) animateTextField: (UITextField*) textField up: (BOOL) up;


- (void) submitAllTrackingItemWithLabel;
- (void) updateSelectItem : (NSArray *) items2Delete;
- (void) deleteAllItems : (NSArray *) items2Delete;
- (void) syncLabelsWithTrackingNumbers;

- (void) enableSideBar;

- (void)forwardToDetailPageWithTrackedItem:(NSString *)trackNum;
@end
