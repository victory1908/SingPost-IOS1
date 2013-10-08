//
//  SendReceiveMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SendReceiveMainViewController.h"
#import "AppDelegate.h"
#import "Article.h"
#import <SVProgressHUD.h>

@implementation SendReceiveMainViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        _fetchedResultsController = [Article frcSendReceiveArticlesWithDelegate:self];
    }
    
    return _fetchedResultsController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setPageTitle:@"Send & Receive"];
    
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
