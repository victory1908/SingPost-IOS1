//
//  ArticleSubCategoryViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 2/12/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ArticleSubCategoryViewController.h"
#import "AppDelegate.h"
#import "ArticleContentViewController.h"

@interface ArticleSubCategoryViewController ()

@end

@implementation ArticleSubCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setIsRootLevel:NO];
    
    [self setItems:[_jsonItems valueForKey:@"Name"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int dataRow = floorf(indexPath.row / 2.0f);
    id articleJSON = _jsonItems[dataRow];
    
    ArticleContentViewController *viewController = [[ArticleContentViewController alloc] initWithArticleJSON:articleJSON];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ - %@ - %@", self.parentPageTitle, self.pageTitle, articleJSON[@"Name"]]];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
