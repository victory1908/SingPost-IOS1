//
//  SendReceiveSubLevelViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 17/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SendReceiveSubLevelViewController.h"
#import "ArticleContentViewController.h"
#import "AppDelegate.h"

@interface SendReceiveSubLevelViewController ()

@end

@implementation SendReceiveSubLevelViewController

@synthesize jsonItems = _jsonItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setIsRootLevel:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int dataRow = floorf(indexPath.row / 2.0f);
    
    id articleJSON = nil;
    for (id jsonItem in _jsonItems) {
        if ([jsonItem[@"Name"] isEqualToString:self.items[dataRow]]) {
            articleJSON = jsonItem;
            break;
        }
    }

    if (articleJSON) {
        ArticleContentViewController *viewController = [[ArticleContentViewController alloc] initWithArticleJSON:articleJSON];
        [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
