
//
//  PostalCodePoBoxTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 23/11/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "PostalCodePoBoxTableViewCell.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"
#import "UILabel+VerticalAlign.h"

@implementation PostalCodePoBoxTableViewCell
{
    UILabel *locationLabel, *postalCodeLabel;
    UIView *separatorView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, LOCATION_LABEL_SIZE.width, LOCATION_LABEL_SIZE.height)];
        [locationLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [locationLabel setTextColor:RGB(58, 68, 61)];
        [locationLabel setNumberOfLines:0];
        [locationLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:locationLabel];
        
        postalCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 8, 60, 30)];
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
    [locationLabel setText:_result[@"postoffice"]];
    [locationLabel setVerticalAlignmentTop];
    
    [postalCodeLabel setHeight:30];
    [postalCodeLabel setText:_result[@"postalcode"]];
    [postalCodeLabel setVerticalAlignmentTop];
    
    [separatorView setY:CGRectGetMaxY(locationLabel.frame) + 10];
}

@end
