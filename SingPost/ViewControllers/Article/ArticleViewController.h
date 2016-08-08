//
//  ArticleViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarView.h"
#import "SwipeViewController.h"

@interface ArticleViewController : SwipeViewController
{
@protected
    NavigationBarView *navigationBarView;
}

@property (nonatomic) NSArray *items;
@property (nonatomic) NSString *pageTitle;


@end
