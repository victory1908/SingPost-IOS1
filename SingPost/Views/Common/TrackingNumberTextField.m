//
//  TrackingNumberTextField.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TrackingNumberTextField.h"
#import "UIColor+SingPost.h"
#import "UIFont+SingPost.h"

@implementation TrackingNumberTextField

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor SingPostBlueColor];
        self.font = [UIFont SingPostRegularFontOfSize:INTERFACE_IS_4INCHSCREEN ? 16.0f : 14.0f fontKey:kSingPostFontOpenSans];
    }
    
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    [[UIColor SingPostBlueColor] setFill];
    [[self placeholder] drawInRect:INTERFACE_IS_4INCHSCREEN ? CGRectInset(rect, 0, 0) : CGRectInset(rect, 0, 0)
                          withFont:[UIFont SingPostLightItalicFontOfSize:INTERFACE_IS_4INCHSCREEN ? 16.0f : 14.0f fontKey:kSingPostFontOpenSans]];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return INTERFACE_IS_4INCHSCREEN ? CGRectInset(bounds, 5, 12) : CGRectInset(bounds, 5, 6);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return INTERFACE_IS_4INCHSCREEN ? CGRectInset(bounds, 5, 12) : CGRectInset(bounds, 5, 6);
}

@end
