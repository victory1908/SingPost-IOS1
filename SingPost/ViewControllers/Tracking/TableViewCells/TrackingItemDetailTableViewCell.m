
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
#import "UILabel+VerticalAlign.h"
#import "UIView+Position.h"

@implementation TrackingItemDetailTableViewCell
{
    UILabel *trackingDateLabel, *statusLabel, *locationLabel;
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
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        trackingDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 60, 70)];
        [trackingDateLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [trackingDateLabel setTextColor:RGB(58, 68, 61)];
        [trackingDateLabel setNumberOfLines:0];
        [trackingDateLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:trackingDateLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 5, STATUS_LABEL_SIZE.width, STATUS_LABEL_SIZE.height)];
        [statusLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [statusLabel setTextColor:RGB(58, 68, 61)];
        [statusLabel setNumberOfLines:0];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:statusLabel];
        
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 5, LOCATION_LABEL_SIZE.width, LOCATION_LABEL_SIZE.height)];
        [locationLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [locationLabel setTextColor:RGB(58, 68, 61)];
        [locationLabel setNumberOfLines:0];
        [locationLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:locationLabel];
        
        if (INTERFACE_IS_IPAD) {
            statusLabel.left = 256;
            locationLabel.left = 512;
        }
        
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, 59, contentView.bounds.size.width - 30, 1)];
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
    [dateFormatter setDateFormat:@"dd-MM-yy"];
    [trackingDateLabel setHeight:70];
    [trackingDateLabel setText:[dateFormatter stringFromDate:_deliveryStatus.date]];
    [trackingDateLabel alignTop];
    
    [statusLabel setHeight:STATUS_LABEL_SIZE.height];
    [statusLabel setText:_deliveryStatus.statusDescription];
    [statusLabel alignTop];
    
    [locationLabel setHeight:LOCATION_LABEL_SIZE.height];
    [locationLabel setText:_deliveryStatus.location];
    [locationLabel alignTop];
    
    [separatorView setY:MAX(60, MAX(CGRectGetMaxY(statusLabel.frame) + 5, CGRectGetMaxY(locationLabel.frame) + 5))];
}

@end
