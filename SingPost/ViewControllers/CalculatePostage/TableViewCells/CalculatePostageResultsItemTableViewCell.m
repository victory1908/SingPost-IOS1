//
//  CalculatePostageResultsItemTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CalculatePostageResultsItemTableViewCell.h"
#import "UIFont+SingPost.h"
#import "CalculatePostageResultItem.h"
#import "UIView+Position.h"

@implementation CalculatePostageResultsItemTableViewCell
{
    UILabel *serviceTitleLabel, *statusLabel, *costLabel;
    UIView *separatorView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        CGFloat width;
        if (INTERFACE_IS_IPAD)
            width = 768;
        else
            width = 320;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 70)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        serviceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, LONG_MAX)];
        [serviceTitleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [serviceTitleLabel setNumberOfLines:0];
        [serviceTitleLabel setTextColor:RGB(51, 51, 51)];
        [serviceTitleLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:serviceTitleLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 200, 30)];
        [statusLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [statusLabel setTextColor:RGB(125, 136, 149)];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:statusLabel];
        
        costLabel = [[UILabel alloc] initWithFrame:CGRectMake(216, 20, 85, 30)];
        costLabel.right = contentView.right - 15;
        [costLabel setFont:[UIFont SingPostBoldFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [costLabel setTextColor:RGB(51, 51, 51)];
        [costLabel setTextAlignment:NSTextAlignmentRight];
        [costLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:costLabel];
        
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, 69, contentView.bounds.size.width - 30, 1)];
        [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [separatorView setBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView];
        
        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)setItem:(CalculatePostageResultItem *)inItem
{
    _item = inItem;
    
    [serviceTitleLabel setWidth:190 andHeight:LONG_MAX];
    NSString * text = [_item.deliveryServiceName stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
    [serviceTitleLabel setText:text];
    [serviceTitleLabel sizeToFit];
    [statusLabel setText:[NSString stringWithFormat:@"%@ working days", _item.deliveryTime]];
    [statusLabel setY:CGRectGetMaxY(serviceTitleLabel.frame)];
    [separatorView setY:CGRectGetMaxY(serviceTitleLabel.frame) + 40.0f];
    [costLabel setText:_item.netPostageCharges];
    [costLabel setCenter:CGPointMake(costLabel.center.x, serviceTitleLabel.bounds.size.height / 2.0f + 23.0f)];
}

@end
