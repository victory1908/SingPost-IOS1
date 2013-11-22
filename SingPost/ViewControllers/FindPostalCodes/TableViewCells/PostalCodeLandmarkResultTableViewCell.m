
//
//  PostalCodeLandmarkResultTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 23/11/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "PostalCodeLandmarkResultTableViewCell.h"
#import "UIFont+SingPost.h"
#import "UIView+Position.h"
#import "UILabel+VerticalAlign.h"

@implementation PostalCodeLandmarkResultTableViewCell
{
    UILabel *landmarkLabel, *postalCodeLabel;
    UIView *separatorView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        landmarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, LOCATION_LABEL_SIZE.width, LOCATION_LABEL_SIZE.height)];
        [landmarkLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [landmarkLabel setTextColor:RGB(58, 68, 61)];
        [landmarkLabel setNumberOfLines:0];
        [landmarkLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:landmarkLabel];
        
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
    [landmarkLabel setHeight:LOCATION_LABEL_SIZE.height];
    [landmarkLabel setText:_result[@"landmark"]];
    [landmarkLabel setVerticalAlignmentTop];

    [postalCodeLabel setHeight:30];
    [postalCodeLabel setText:_result[@"postalcode"]];
    [postalCodeLabel setVerticalAlignmentTop];

    [separatorView setY:CGRectGetMaxY(landmarkLabel.frame) + 10];
}

@end
