//
//  PaymentMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "PaymentMainViewController.h"
#import "AppDelegate.h"
#import "Article.h"
#import <SVProgressHUD.h>

@implementation PaymentMainViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        _fetchedResultsController = [Article frcPaymentArticlesWithDelegate:self];
    }
    
    return _fetchedResultsController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"Pay"];
    
    //fetch data
    if ([[AppDelegate sharedAppDelegate] hasInternetConnectionWarnIfNoConnection:YES]) {
        [SVProgressHUD show];
        [Article API_getSendReceiveItemsOnCompletion:^(BOOL success, NSError *error) {
            if (success)
                [SVProgressHUD dismiss];
            else
                [SVProgressHUD showErrorWithStatus:@"An error has occurred"];
        }];
    }
}

@end
