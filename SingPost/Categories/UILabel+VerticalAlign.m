//
//  UILabel+VerticalAlign.m
//  WanBao
//
//  Created by enpsapp on 2/25/13.
//
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)

- (void) setVerticalAlignmentTop
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

@end
