//
//  ArticleViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSString *pageTitle;

@end
