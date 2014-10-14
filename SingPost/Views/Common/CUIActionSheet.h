//
//  FlatBlueButton.h
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUIActionSheet : UIView

@property (nonatomic, strong) UIView *blockBackground;

- (void)showInView:(UIView *)view;
- (void)dismissView;

@end
