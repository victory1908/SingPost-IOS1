//
//  ArticleContentViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 9/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleContentViewController : UIViewController

- (id)initWithArticleJSON:(NSDictionary *)articleJSON;

@property (nonatomic, readonly) NSDictionary *articleJSON;

@end
