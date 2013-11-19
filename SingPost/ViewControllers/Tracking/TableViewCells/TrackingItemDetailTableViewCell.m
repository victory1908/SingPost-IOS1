
//
//  TrackingItemDetailTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TrackingItemDetailTableViewCell.h"
#import "UIFont+SingPost.h"
#import "DeliveryStatus.h"

@implementation TrackingItemDetailTableViewCell
{
    UILabel *trackingDateLabel, *statusLabel, *locationLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        trackingDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 290, 30)];
        [trackingDateLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [trackingDateLabel setTextColor:RGB(58, 68, 61)];
        [trackingDateLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:trackingDateLabel];
        
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 290, 30)];
        [locationLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [locationLabel setTextColor:RGB(58, 68, 61)];
        [locationLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:locationLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 34, 290, 30)];
        [statusLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [statusLabel setTextColor:RGB(58, 68, 61)];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:statusLabel];

        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, 70, contentView.bounds.size.width - 30, 1)];
        [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [separatorView setBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView];
        
        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)setDeliveryStatus:(DeliveryStatus *)inDeliveryStatus
{
    _deliveryStatus = inDeliveryStatus;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [trackingDateLabel setText:[dateFormatter stringFromDate:_deliveryStatus.date]];
    [locationLabel setText:_deliveryStatus.location];
    [statusLabel setText:_deliveryStatus.statusDescription];
}


@end
