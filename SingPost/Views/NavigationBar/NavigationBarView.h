//
//  NavigationBarView.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBarView : UIView

@property (nonatomic, assign) BOOL showSidebarToggleButton;
@property (nonatomic, assign) BOOL showBackButton;
@property (nonatomic) NSString *title;
@property (nonatomic, assign) CGFloat titleFontSize;

@end
