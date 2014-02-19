//
//  UIScrollView+Additions.m
//  GNC
//
//  Created by Wei Guang on 28/1/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "UIScrollView+Additions.h"

@implementation UIScrollView (Additions)

- (void)autoAdjustScrollViewContentSize {
    [self autoAdjustScrollViewContentSizeBottomInset:0];
}

- (void)autoAdjustScrollViewContentSizeBottomInset:(CGFloat)bottomInset {
    CGFloat maxY = 0;
    for (UIView *subview in self.subviews)
        if (subview.hidden == NO && subview.alpha > 0)
            if (maxY < CGRectGetMaxY(subview.frame))
                maxY = CGRectGetMaxY(subview.frame);

    maxY += bottomInset;
    
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), maxY);
}

- (CGRect)visibleRect {
    CGRect visibleRect;
    
    visibleRect.origin = self.contentOffset;
    visibleRect.size = self.bounds.size;
    
    visibleRect.origin.x /= self.zoomScale;
    visibleRect.origin.y /= self.zoomScale;
    visibleRect.size.width /= self.zoomScale;
    visibleRect.size.height /= self.zoomScale;
    return visibleRect;
}

- (void)scrollSubviewToCenter:(UIView*)subview animated:(BOOL)animated {
    CGRect subviewBounds = subview.bounds;
    CGRect subviewFrame = [subview convertRect:subviewBounds toView:self];
    
    CGPoint offset = self.contentOffset;
    CGFloat height = CGRectGetHeight(self.bounds) - self.contentInset.top - self.contentInset.bottom;
    height = ABS(height);
    
    offset.y = CGRectGetMidY(subviewFrame) - height/2;
    if (offset.y + height > self.contentSize.height)
        offset.y = self.contentSize.height - height;
    if (offset.y < 0)
        offset.y = 0;
    
    [self setContentOffset:offset animated:animated];
}

@end
