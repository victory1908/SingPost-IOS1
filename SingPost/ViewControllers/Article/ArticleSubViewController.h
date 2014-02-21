//
//  ArticleSubViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 2/12/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ArticleViewController.h"

@class ArticleCategory;

@interface ArticleSubViewController : UIViewController

{
@protected
    NavigationBarView *navigationBarView;
}

@property (nonatomic) ArticleCategory *articleCategory;
@property (nonatomic, assign) BOOL showAsRootViewController;

@property (nonatomic) NSArray *items;
@property (nonatomic) NSString *pageTitle;

@end
