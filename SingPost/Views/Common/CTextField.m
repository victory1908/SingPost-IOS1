//
//  CTextField.m
//  SingPost
//
//  Created by Edward Soetiono on 29/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CTextField.h"
#import "UIFont+SingPost.h"

#define DEFAULT_TEXTFIELD_BACKGROUND      [[UIImage imageNamed:@"trackingTextBox_grayBg"]resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,15,15)]

@implementation CTextField

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _fontSize = 16.0f;
        _placeholderFontSize = 13.0f;
        _insetBoundsSize = CGSizeMake(10, 5);

        self.background = DEFAULT_TEXTFIELD_BACKGROUND;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
        self.backgroundColor = RGB(240, 240, 240);
        self.textColor = RGB(36, 84, 157);
        self.font = [UIFont SingPostRegularFontOfSize:_fontSize fontKey:kSingPostFontOpenSans];
        
    }
    
    return self;
}

- (void)setInsetBoundsSize:(CGSize)inInsetBoundsSize
{
    _insetBoundsSize = inInsetBoundsSize;
    [self setNeedsDisplay];
}

- (void)setFontSize:(CGFloat)inFontSize
{
    _fontSize = inFontSize;
    self.font = [UIFont SingPostRegularFontOfSize:_fontSize fontKey:kSingPostFontOpenSans];
}

- (void)setPlaceholderFontSize:(CGFloat)inPlaceholderFontSize
{
    _placeholderFontSize = inPlaceholderFontSize;
    [self setNeedsDisplay];
}

-(void)drawPlaceholderInRect:(CGRect)rect{
    //    CGRect textRect = CGRectMake(x, y, length-x, maxFontSize);
    UIFont *font = [UIFont SingPostLightItalicFontOfSize:_placeholderFontSize fontKey:kSingPostFontOpenSans];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor blackColor]};
    
    CGRect newRect = CGRectInset(rect, 0, rect.size.height/2 - _fontSize/2);
    
    [[self placeholder] drawInRect:newRect withAttributes:attributes];
    
}

//- (void)drawPlaceholderInRect:(CGRect)rect {
//    [RGB(36, 84, 157) setFill];
//    
////    CGRect textRect = CGRectMake(x, y, length-x, maxFontSize);
//    UIFont *font = [UIFont SingPostLightItalicFontOfSize:_placeholderFontSize fontKey:kSingPostFontOpenSans];
//    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraphStyle.alignment = NSTextAlignmentLeft;
//    NSDictionary *attributes = @{ NSFontAttributeName: font,
//                                  NSParagraphStyleAttributeName: paragraphStyle,
//                                  NSForegroundColorAttributeName: [UIColor blackColor]};
//    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//
//    [[self placeholder] drawInRect:rect withAttributes:attributes];
////    [[self placeholder] drawInRect:CGRectInset(rect, 0, _insetBoundsSize.height + (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 0.0f : -5.0f))
////                          withFont:[UIFont SingPostLightItalicFontOfSize:_placeholderFontSize fontKey:kSingPostFontOpenSans]
////                     lineBreakMode:NSLineBreakByWordWrapping];
//}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectInset(rect, _insetBoundsSize.width, _insetBoundsSize.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    return CGRectInset(rect, _insetBoundsSize.width, _insetBoundsSize.height);
}

@end
