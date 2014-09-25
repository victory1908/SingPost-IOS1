//
//  TrackingMainViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingMainViewController : UIViewController{
    UITableView *trackingItemsTableView;
}

@property (nonatomic) NSString *trackingNumber;

@property (nonatomic,assign) BOOL isOn;

@property BOOL isPushNotification;

@property (nonatomic,retain)NSDictionary * labelDic;

@property (nonatomic,retain)UITableView *trackingItemsTableView;

- (void)addTrackingNumber:(NSString *)trackingNumber;

- (void)refreshTableView;
- (void) animateTextField: (UITextField*) textField up: (BOOL) up;


- (void) submitAllTrackingItemWithLabel;
- (void) updateSelectItem : (NSArray *) items2Delete;
@end
