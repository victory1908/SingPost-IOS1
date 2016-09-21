//
//  ArticleContentViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"
#import <WebKit/WebKit.h>
#import <SafariServices/SafariServices.h>

@class Article;

@interface ArticleContentViewController : SwipeViewController

@property (nonatomic) Article *article;

@property (strong, nonatomic) NSString *previousViewTitle;

@end
