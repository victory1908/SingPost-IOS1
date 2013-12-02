//
//  MoreServicesMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "MoreServicesMainViewController.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import "Article.h"

@implementation MoreServicesMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"More Services"];
    [self setIsRootLevel:YES];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    __weak MoreServicesMainViewController *weakSelf = self;
    [Article API_getServicesOnCompletion:^(NSDictionary *items) {
        [weakSelf setJsonData:items];
        if ([items isKindOfClass:[NSDictionary class]])
            [weakSelf setItems:items.allKeys];
        [SVProgressHUD dismiss];
    }];
}


@end
