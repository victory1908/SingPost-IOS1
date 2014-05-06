//
//  ArticleTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ArticleTableViewCell.h"
#import "UIFont+SingPost.h"

@implementation ArticleTableViewCell
{
    UILabel *titleLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = RGB(204, 204, 204);
        self.selectedBackgroundView = v;
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [contentView setBackgroundColor:[UIColor clearColor]];
        
        float width3 = INTERFACE_IS_IPAD ? 715.0f : 250.0f;
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, width3, 50)];
        [titleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [titleLabel setTextColor:RGB(51, 51, 51)];
        [titleLabel setNumberOfLines:2];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:titleLabel];
        
        float width2 = INTERFACE_IS_IPAD ? 740.0f : 295.0f;
        UIImageView *disclosureIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_disclosure_indicator"]];
        [disclosureIndicatorImageView setFrame:CGRectMake(width2, 25, 8, 17)];
        [contentView addSubview:disclosureIndicatorImageView];
        
        float width = INTERFACE_IS_IPAD ? 780.0f : contentView.bounds.size.width;
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, width, 1)];
        [separatorView setBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView];
        
        [self.contentView addSubview:contentView];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    [titleLabel setText:title];
}

@end
