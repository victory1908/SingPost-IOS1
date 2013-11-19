//
//  TrackingItemMainTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TrackingItemMainTableViewCell.h"
#import "UIFont+SingPost.h"
#import "UIColor+SingPost.h"
#import "ItemTracking.h"
#import "PersistentBackgroundView.h"

@implementation TrackingItemMainTableViewCell
{
    UILabel *trackingNumberLabel, *statusLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = RGB(240, 240, 240);
        self.selectedBackgroundView = v;
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        trackingNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 180, 30)];
        [trackingNumberLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [trackingNumberLabel setTextColor:RGB(58, 68, 61)];
        [trackingNumberLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:trackingNumberLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 250, 30)];
        [statusLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [statusLabel setTextColor:RGB(50, 50, 50)];
        [statusLabel setNumberOfLines:0];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:statusLabel];
        
        PersistentBackgroundView *separatorView = [[PersistentBackgroundView alloc] initWithFrame:CGRectMake(0, 59, contentView.bounds.size.width, 1.0f)];
        [separatorView setPersistentBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView];

        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)setItem:(ItemTracking *)inItem
{
    _item = inItem;
    [trackingNumberLabel setText:_item.trackingNumber];
    [statusLabel setText:_item.status];
}

@end
