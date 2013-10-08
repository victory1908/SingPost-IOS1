//
//  ArticleViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface ArticleViewController : UIViewController

- (id)initWithArticle:(Article *)article;

@property (nonatomic, readonly) Article *article;

@end
