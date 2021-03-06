//
//  PostalCodeStreetTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 27/11/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "PostalCodeStreetTableViewCell.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"
#import "UILabel+VerticalAlign.h"

@implementation PostalCodeStreetTableViewCell
{
    UILabel *locationLabel, *postalCodeLabel;
    UIView *separatorView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        CGFloat width;
        if (INTERFACE_IS_IPAD)
            width = 768;
        else
            width = 320;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.contentView.bounds.size.height)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, LOCATION_LABEL_SIZE.width, LOCATION_LABEL_SIZE.height)];
        [locationLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [locationLabel setTextColor:RGB(58, 68, 61)];
        [locationLabel setNumberOfLines:0];
        [locationLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:locationLabel];
        
        postalCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 8, 60, 30)];
        postalCodeLabel.right = contentView.right - 15;
        [postalCodeLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [postalCodeLabel setTextColor:RGB(36, 84, 157)];
        [postalCodeLabel setTextAlignment:NSTextAlignmentRight];
        [postalCodeLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:postalCodeLabel];
        
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, 43, contentView.bounds.size.width - 30, 0.5f)];
        [separatorView setBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView];
        
        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)setResult:(NSDictionary *)inResult
{
    _result = inResult;
    [locationLabel setHeight:LOCATION_LABEL_SIZE.height];
    [locationLabel setText:[NSString stringWithFormat:@"%@ %@", _result[@"buildingno"], _result[@"streetname"]]];
    [locationLabel alignTop];
    
    [postalCodeLabel setHeight:30];
    [postalCodeLabel setText:_result[@"postalcode"]];
    [postalCodeLabel alignTop];
    
    [separatorView setY:CGRectGetMaxY(locationLabel.frame) + 10];
}

@end
