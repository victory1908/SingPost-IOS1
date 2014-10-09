//
//  NavigationBarView.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NAVIGATIONBAR_FRAME CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)

@interface NavigationBarView : UIView

@property (nonatomic, assign) BOOL showSidebarToggleButton;
@property (nonatomic, assign) BOOL showBackButton;
@property (nonatomic) NSString *title;
@property (nonatomic, assign) CGFloat titleFontSize;

- (void)setToggleButtonEnable:(BOOL)isEnable;

@end
