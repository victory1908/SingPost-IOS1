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

@implementation TrackingItemMainTableViewCell
{
    UIView *separatorView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [contentView setBackgroundColor:[UIColor whiteColor]];

        UILabel *trackingNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 180, 30)];
        [trackingNumberLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [trackingNumberLabel setText:@"RA0000000000SG"];
        [trackingNumberLabel setTextColor:RGB(58, 68, 61)];
        [trackingNumberLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:trackingNumberLabel];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(198, 8, 100, 30)];
        [statusLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [statusLabel setText:@"<status>"];
        [statusLabel setTextColor:RGB(58, 68, 61)];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:statusLabel];
        
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, contentView.bounds.size.height - 1, contentView.bounds.size.width - 30, 1)];
        [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [separatorView setBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView];
        
        [self.contentView addSubview:contentView];
        
    }
    return self;
}

#pragma mark - Accessors

- (void)setShowBottomSeparator:(BOOL)showBottomSeparator
{
    [separatorView setHidden:!showBottomSeparator];
}


@end
