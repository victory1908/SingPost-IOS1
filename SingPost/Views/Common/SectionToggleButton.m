//
//  SectionToggleButton.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SectionToggleButton.h"
#import "UIFont+SingPost.h"

@implementation SectionToggleButton

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [self setTitleColor:RGB(36, 84, 157) forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        UIView *rightSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 1, 0, 0.5f, self.bounds.size.height)];
        [rightSeparatorView setBackgroundColor:RGB(196, 197, 200)];
        [self addSubview:rightSeparatorView];
    }
    
    return self;
}

@end
