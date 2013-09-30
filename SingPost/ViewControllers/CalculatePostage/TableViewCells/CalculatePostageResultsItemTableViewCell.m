//
//  CalculatePostageResultsItemTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CalculatePostageResultsItemTableViewCell.h"
#import "UIFont+SingPost.h"

@implementation CalculatePostageResultsItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 70)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *serviceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 120, 30)];
        [serviceTitleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [serviceTitleLabel setText:@"Service title"];
        [serviceTitleLabel setTextColor:RGB(51, 51, 51)];
        [serviceTitleLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:serviceTitleLabel];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 100, 30)];
        [statusLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [statusLabel setText:@"3 days or less"];
        [statusLabel setTextColor:RGB(125, 136, 149)];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:statusLabel];
        
        UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 20, 100, 30)];
        [costLabel setFont:[UIFont SingPostBoldFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [costLabel setText:@"$15.30"];
        [costLabel setTextColor:RGB(51, 51, 51)];
        [costLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:costLabel];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, 69, contentView.bounds.size.width - 30, 1)];
        [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [separatorView setBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView];
        
        [self.contentView addSubview:contentView];
    }
    return self;
}

@end
