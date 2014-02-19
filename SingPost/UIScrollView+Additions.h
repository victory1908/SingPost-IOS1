//
//  UIScrollView+Additions.h
//  GNC
//
//  Created by Wei Guang on 28/1/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Additions)

- (void)autoAdjustScrollViewContentSize;

- (void)autoAdjustScrollViewContentSizeBottomInset:(CGFloat)bottomInset;

- (CGRect)visibleRect;

- (void)scrollSubviewToCenter:(UIView*)subview animated:(BOOL)animated;

@end
