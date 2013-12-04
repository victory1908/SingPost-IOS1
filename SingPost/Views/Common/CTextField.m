//
//  CTextField.m
//  SingPost
//
//  Created by Edward Soetiono on 29/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CTextField.h"
#import "UIFont+SingPost.h"
#import "UIColor+SingPost.h"

@implementation CTextField

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _fontSize = 16.0f;
        _placeholderFontSize = 16.0f;
        _insetBoundsSize = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? CGSizeMake(10, 12) : CGSizeMake(10, 10);

        self.background = [UIImage imageNamed:@"trackingTextBox_grayBg"];
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
        self.backgroundColor = RGB(240, 240, 240);
        self.textColor = [UIColor SingPostBlueColor];
        self.font = [UIFont SingPostRegularFontOfSize:_fontSize fontKey:kSingPostFontOpenSans];
    }
    
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    [[UIColor SingPostBlueColor] setFill];
    [[self placeholder] drawInRect:CGRectInset(rect, 0, _insetBoundsSize.height / 2 + (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 0.0f : -5.0f))
                          withFont:[UIFont SingPostLightItalicFontOfSize:_placeholderFontSize fontKey:kSingPostFontOpenSans]
                     lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectInset(rect, _insetBoundsSize.width, _insetBoundsSize.height / 2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    return CGRectInset(rect, _insetBoundsSize.width, _insetBoundsSize.height / 2);
}


@end
