//
//  ArticleViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController

@property (nonatomic) NSArray *items;
@property (nonatomic) NSArray *jsonItems;
@property (nonatomic) NSString *pageTitle;
@property (nonatomic, assign) BOOL isRootLevel;

@end
