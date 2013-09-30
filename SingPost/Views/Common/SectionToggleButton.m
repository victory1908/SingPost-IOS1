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
{
    UIImageView *selectedIndicatorImageView;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        
        UIView *rightSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 1, 0, 1, self.bounds.size.height)];
        [rightSeparatorView setBackgroundColor:RGB(196, 197, 200)];
        [self addSubview:rightSeparatorView];
        
        selectedIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_indicator"]];
        [selectedIndicatorImageView setFrame:CGRectMake((int)(self.bounds.size.width / 2) - 8, self.bounds.size.height, 17, 8)];
        [self addSubview:selectedIndicatorImageView];
        
        [self setSelected:NO];
    }
    
    return self;
}
- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted)
        [self.titleLabel setTextColor:[UIColor darkGrayColor]];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        [self setBackgroundColor:RGB(36, 84, 157)];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [selectedIndicatorImageView setHidden:NO];
    }
    else {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.titleLabel setTextColor:RGB(36, 84, 157)];
        [selectedIndicatorImageView setHidden:YES];
    }
}

@end
