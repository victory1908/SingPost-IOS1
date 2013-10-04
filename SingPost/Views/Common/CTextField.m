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
        _insetBoundsSize = CGSizeMake(10, 12);

        self.background = [UIImage imageNamed:@"trackingTextBox_grayBg"];
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.backgroundColor = RGB(240, 240, 240);
        self.textColor = [UIColor SingPostBlueColor];
        self.font = [UIFont SingPostRegularFontOfSize:_fontSize fontKey:kSingPostFontOpenSans];
    }
    
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    [[UIColor SingPostBlueColor] setFill];
    [[self placeholder] drawInRect:rect
                          withFont:[UIFont SingPostLightItalicFontOfSize:_placeholderFontSize fontKey:kSingPostFontOpenSans]
                     lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, _insetBoundsSize.width, _insetBoundsSize.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, _insetBoundsSize.width, _insetBoundsSize.height);
}


@end
