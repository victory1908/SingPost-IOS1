//
//  ShopMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ShopMainViewController.h"
#import "AppDelegate.h"
#import "Article.h"
#import <SVProgressHUD.h>

@interface ShopMainViewController ()

@end

@implementation ShopMainViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        _fetchedResultsController = [Article frcShopArticlesWithDelegate:self];
    }
    
    return _fetchedResultsController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"Shop"];
    
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
