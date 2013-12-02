//
//  ArticleContentViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ArticleContentViewController.h"
#import "NavigationBarView.h"

@interface ArticleContentViewController ()

@end

@implementation ArticleContentViewController
{
    UIWebView *contentWebView;
}

//designated initializer
- (id)initWithArticleJSON:(NSDictionary *)inArticleJSON
{
    NSParameterAssert(inArticleJSON);
    if  ((self = [super initWithNibName:nil bundle:nil])) {
        _articleJSON = inArticleJSON;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithArticleJSON:nil];
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitleFontSize:14.0f];
    [navigationBarView setTitle:_articleJSON[@"Name"]];
    [navigationBarView setShowBackButton:YES];
    [contentView addSubview:navigationBarView];
    
    contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, contentView.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height)];
    [contentView addSubview:contentWebView];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //load html content
    NSString *htmlContentWithThumbnail = [NSString stringWithFormat:@"<div><img style=\"width:%.0fpx;\" src=\"%@\"></img></div>%@", 300.0f, _articleJSON[@"Thumbnail"], _articleJSON[@"Description"]];
    [contentWebView loadHTMLString:htmlContentWithThumbnail baseURL:nil];
}

@end
