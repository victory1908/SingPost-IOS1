//
//  StampCollectibleDetailExpandableView.m
//  SingPost
//
//  Created by Edward Soetiono on 10/12/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "StampCollectibleDetailExpandableView.h"
#import "UILabel+VerticalAlign.h"
#import "UIView+Position.h"
#import "UIFont+SingPost.h"

@implementation StampCollectibleDetailExpandableView

#define READ_LESS_LINE 4

//designated initalizer
- (id)initWithFrame:(CGRect)frame andText:(NSString *)text
{
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
        
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.numberOfLines = READ_LESS_LINE;
        _label.backgroundColor = [UIColor clearColor];
        _label.text = text;
        _label.lineBreakMode = NSLineBreakByTruncatingTail;
        _label.textColor = RGB(51, 51, 51);
        _label.font = [UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans];
        
        [self resizeAndAlignTop];
        [self addSubview:_label];
        [self setHeight:floorf(_label.bounds.size.height)];
        
        _collapsedHeight = floorf(_label.bounds.size.height);
        _expandedHeight = floorf([text sizeWithFont:_label.font constrainedToSize:CGSizeMake(_label.bounds.size.width, LONG_MAX)].height);
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andText:@""];
}

- (void)resizeAndAlignTop
{
    [_label sizeToFit];
    [_label alignTop];
}

- (void)toggleExpandCollapse
{
    _isExpanded = !_isExpanded;
    [_label setNumberOfLines:_isExpanded ? 0 : READ_LESS_LINE];
    [self resizeAndAlignTop];
}

- (CGFloat)deltaHeight
{
    return _isExpanded ? (_expandedHeight - _collapsedHeight) : (_collapsedHeight - _expandedHeight);
}

@end
