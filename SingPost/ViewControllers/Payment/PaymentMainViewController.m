//
//  PaymentMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "PaymentMainViewController.h"
#import "AppDelegate.h"
#import "PaymentSubLevelViewController.h"

@implementation PaymentMainViewController
{
    NSArray *data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPageTitle:@"Pay"];
    [self setIsRootLevel:YES];
    
    data = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Pay" ofType:@"plist"]];
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
