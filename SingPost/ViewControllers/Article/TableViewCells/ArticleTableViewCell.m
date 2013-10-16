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
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 250, 50)];
        [titleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [titleLabel setTextColor:RGB(51, 51, 51)];
        [titleLabel setNumberOfLines:2];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:titleLabel];
        
        UIImageView *disclosureIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_disclosure_indicator"]];
        [disclosureIndicatorImageView setFrame:CGRectMake(295, 25, 8, 17)];
        [contentView addSubview:disclosureIndicatorImageView];
        
        [self.contentView addSubview:contentView];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    [titleLabel setText:title];
}

@end
