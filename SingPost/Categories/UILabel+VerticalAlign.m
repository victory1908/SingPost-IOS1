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
//    NSStringDrawingOptions options = (NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin);
//    
//    NSMutableParagraphStyle * style =  [[NSMutableParagraphStyle alloc] init];
//    [style setLineBreakMode:NSLineBreakByWordWrapping];
//    [style setAlignment:NSTextAlignmentRight];
//    
//    NSDictionary *textAttibutes = @{NSFontAttributeName : self.font,
//                                    NSParagraphStyleAttributeName : style};
//    
//    CGSize textSize = [self.text boundingRectWithSize:self.size options:options attributes:textAttibutes context:nil].size;
    CGSize textSize = [self neededSizeForText:self.text withFont:self.font andMaxWidth:self.frame.size.width];
    
//    CGSize textSize = [self.text sizeWithFont:self.font
//                            constrainedToSize:self.frame.size
//                                lineBreakMode:self.lineBreakMode];
    
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


//addforTextsize
- (CGSize)neededSizeForText:(NSString*)text withFont:(UIFont*)font andMaxWidth:(float)maxWidth
{
    NSStringDrawingOptions options = (NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin);
    
    NSMutableParagraphStyle * style =  [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    [style setAlignment:NSTextAlignmentRight];
    
    NSDictionary *textAttibutes = @{NSFontAttributeName : font,
                                    NSParagraphStyleAttributeName : style};

    CGSize neededTextSize = [text boundingRectWithSize:CGSizeMake(maxWidth, 500) options:options attributes:textAttibutes context:nil].size;
    
    return neededTextSize;
}


@end
