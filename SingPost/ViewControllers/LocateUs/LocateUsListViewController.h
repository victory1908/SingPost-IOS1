//
//  LocateUsListViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 1/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocateUsListViewController : UIViewController

@property (nonatomic, readonly) NSString *selectedLocationType;
@property (nonatomic) NSUInteger selectedTypeRowIndex;
@property (nonatomic) NSString *searchTerm;
@property (nonatomic, weak) id delegate;

- (void)reloadData;

@end
