//
//  UILabel+VerticalAlign.m
//  WanBao
//
//  Created by Edward Soetiono on 2/2/13.
//  Copyright 2013 SPH. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)

- (void)alignTop
{
    CGSize textSize = [self.text sizeWithFont:self.font
                            constrainedToSize:self.frame.size
                                lineBreakMode:self.lineBreakMode];
    
    CGRect textRect = CGRectMake(self.frame.origin.x,
                                 self.frame.origin.y,
                                 self.frame.size.width,
                                 textSize.height);
    [self setFrame:textRect];
    [self setNeedsDisplay];
}

- (void)sizeToFitKeepHeight {
    CGFloat initialHeight = CGRectGetHeight(self.frame);
    [self sizeToFit];
    CGRect frame = self.frame;
    frame.size.height = initialHeight;
    self.frame = frame;
}

- (void)sizeToFitKeepWidth {
    CGFloat initialWidth = CGRectGetWidth(self.frame);
    [self sizeToFit];
    CGRect frame = self.frame;
    frame.size.width = initialWidth;
    self.frame = frame;
}

@end
