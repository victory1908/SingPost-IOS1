//
//  SendReceiveSubLevelViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 17/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SendReceiveSubLevelViewController.h"
#import "SampleArticleContentViewController.h"
#import "AppDelegate.h"

@interface SendReceiveSubLevelViewController ()

@end

@implementation SendReceiveSubLevelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setIsRootLevel:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int dataRow = floorf(indexPath.row / 2.0f);
    SampleArticleContentViewController *viewController = [[SampleArticleContentViewController alloc] initWithNibName:nil bundle:nil];
    [viewController setPageTitle:self.items[dataRow]];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
