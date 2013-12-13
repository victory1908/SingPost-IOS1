//
//  TrackingItemMainTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TrackingItemMainTableViewCell.h"
#import "UIFont+SingPost.h"
#import "ItemTracking.h"
#import "PersistentBackgroundView.h"
#import "UILabel+VerticalAlign.h"
#import "UIView+Position.h"

@implementation TrackingItemMainTableViewCell
{
    UILabel *trackingNumberLabel, *statusLabel;
    PersistentBackgroundView *separatorView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = RGB(240, 240, 240);
        self.selectedBackgroundView = v;
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        trackingNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 150, 30)];
        [trackingNumberLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [trackingNumberLabel setTextColor:RGB(58, 68, 61)];
        [trackingNumberLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:trackingNumberLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 6, STATUS_LABEL_SIZE.width, STATUS_LABEL_SIZE.height)];
        [statusLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [statusLabel setTextColor:RGB(50, 50, 50)];
        [statusLabel setNumberOfLines:0];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:statusLabel];
        
        separatorView = [[PersistentBackgroundView alloc] initWithFrame:CGRectMake(15, 59, contentView.bounds.size.width - 30, 1.0f)];
        [separatorView setPersistentBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView];

        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)setHideSeparatorView:(BOOL)inHideSeparatorView
{
    _hideSeparatorView = inHideSeparatorView;
    [separatorView setHidden:_hideSeparatorView];
}

- (void)setItem:(ItemTracking *)inItem
{
    _item = inItem;
    [trackingNumberLabel setText:_item.trackingNumber];
    [trackingNumberLabel alignTop];
    
    [statusLabel setHeight:STATUS_LABEL_SIZE.height];
    [statusLabel setText:_item.status];
    [statusLabel alignTop];
    
    [separatorView setY:MAX(59, CGRectGetMaxY(statusLabel.frame) + 7)];
}

@end
