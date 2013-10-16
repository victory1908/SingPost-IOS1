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
#import "PaymentSubLevelViewController.h"

@implementation MoreServicesMainViewController
{
    NSArray *data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"More Services"];
    [self setIsRootLevel:YES];
    
    data = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MoreServices" ofType:@"plist"]];
    [self setItems:[data valueForKey:@"category"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int dataRow = floorf(indexPath.row / 2.0f);
    PaymentSubLevelViewController *subLevelViewController = [[PaymentSubLevelViewController alloc] initWithNibName:nil bundle:nil];
    [subLevelViewController setItems:data[dataRow][@"items"]];
    [subLevelViewController setPageTitle:self.items[dataRow]];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:subLevelViewController];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
