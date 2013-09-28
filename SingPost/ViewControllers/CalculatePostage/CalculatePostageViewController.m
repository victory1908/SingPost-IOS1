//
//  CalculatePostageViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CalculatePostageViewController.h"
#import "NavigationBarView.h"

@interface CalculatePostageViewController ()

@end

@implementation CalculatePostageViewController

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [contentView addSubview:navigationBarView];
    
//    UIButton *damnButton = 
    
    self.view = contentView;
}

@end
