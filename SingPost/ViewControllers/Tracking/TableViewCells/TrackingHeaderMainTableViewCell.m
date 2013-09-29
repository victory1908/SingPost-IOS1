//
//  TrackingHeaderMainTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "TrackingHeaderMainTableViewCell.h"
#import "UIFont+SingPost.h"

@implementation TrackingHeaderMainTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 30)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *trackingNumbersHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 30)];
        [trackingNumbersHeaderLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [trackingNumbersHeaderLabel setText:@"Tracking numbers"];
        [trackingNumbersHeaderLabel setTextColor:RGB(125, 136, 149)];
        [trackingNumbersHeaderLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:trackingNumbersHeaderLabel];
        
        UILabel *statusHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 50, 30)];
        [statusHeaderLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [statusHeaderLabel setText:@"Status"];
        [statusHeaderLabel setTextColor:RGB(125, 136, 149)];
        [statusHeaderLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:statusHeaderLabel];
        
//        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, contentView.bounds.size.height - 1, contentView.bounds.size.width - 30, 1)];
//        [separatorView setBackgroundColor:RGB(196, 197, 200)];
//        [contentView addSubview:separatorView];
        
        [self.contentView addSubview:contentView];
    }
    
    return self;
}

@end
