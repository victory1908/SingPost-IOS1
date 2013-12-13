//
//  CTextView.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CTextView.h"
#import "UIFont+SingPost.h"

@implementation CTextView
{
    BOOL _shouldDrawPlaceholder;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _fontSize = 16.0f;
        _placeholderFontSize = 16.0f;
        _placeholderColor = RGB(36, 84, 157);
        _shouldDrawPlaceholder = NO;
    
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = RGB(36, 84, 157);
        self.font = [UIFont SingPostRegularFontOfSize:_fontSize fontKey:kSingPostFontOpenSans];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (_shouldDrawPlaceholder) {
        [_placeholderColor set];
        [_placeholder drawInRect:CGRectMake(8.0f, 8.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f) withFont:[UIFont SingPostLightItalicFontOfSize:self.fontSize fontKey:kSingPostFontOpenSans]];
    }
}

#pragma mark - Accessors

- (void)setPlaceholder:(NSString *)string {
    if ([string isEqual:_placeholder])
        return;

    _placeholder = string;
    
    [self _updateShouldDrawPlaceholder];
}

- (void)setText:(NSString *)string {
    [super setText:string];
    [self _updateShouldDrawPlaceholder];
}

#pragma mark - Private

- (void)_updateShouldDrawPlaceholder {
    BOOL prev = _shouldDrawPlaceholder;
    _shouldDrawPlaceholder = self.placeholder && self.placeholderColor && self.text.length == 0;
    
    if (prev != _shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
}


- (void)_textChanged:(NSNotification *)notificaiton {
    [self _updateShouldDrawPlaceholder];
}



@end
