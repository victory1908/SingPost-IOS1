
//
//  TrackingItemDetailTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TrackingItemDetailTableViewCell.h"
#import "UIFont+SingPost.h"

@implementation TrackingItemDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *trackingNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 90, 30)];
        [trackingNumberLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [trackingNumberLabel setText:@"DD-MM-YYYY"];
        [trackingNumberLabel setTextColor:RGB(58, 68, 61)];
        [trackingNumberLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:trackingNumberLabel];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(118, 8, 60, 30)];
        [statusLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [statusLabel setText:@"<status>"];
        [statusLabel setTextColor:RGB(58, 68, 61)];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:statusLabel];
        
        UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 8, 100, 30)];
        [locationLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [locationLabel setText:@"Location"];
        [locationLabel setTextColor:RGB(58, 68, 61)];
        [locationLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:locationLabel];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, contentView.bounds.size.height - 1, contentView.bounds.size.width - 30, 1)];
        [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [separatorView setBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView];
        
        [self.contentView addSubview:contentView];
        
    }
    return self;
}
@end
