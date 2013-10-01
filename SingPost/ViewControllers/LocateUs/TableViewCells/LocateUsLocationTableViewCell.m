//
//  LocateUsLocationTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LocateUsLocationTableViewCell.h"
#import "UIFont+SingPost.h"
#import "EntityLocation.h"

@implementation LocateUsLocationTableViewCell
{
    UILabel *nameLabel, *addressLabel, *distanceLabel;
    UIButton *openedIndicatorButton, *closedIndicatorButton;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
        self.selectedBackgroundView = v;
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [contentView setBackgroundColor:[UIColor clearColor]];
        
        UIView *openingHoursIndicatorContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 60)];
        [openingHoursIndicatorContainerView setBackgroundColor:RGB(237, 237, 237)];
        [contentView addSubview:openingHoursIndicatorContainerView];
        
        openedIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [openedIndicatorButton setImage:[UIImage imageNamed:@"gray_circle"] forState:UIControlStateNormal];
        [openedIndicatorButton setImage:[UIImage imageNamed:@"green_circle"] forState:UIControlStateSelected];
        [openedIndicatorButton setFrame:CGRectMake(7, 16, 10, 10)];
        [openingHoursIndicatorContainerView addSubview:openedIndicatorButton];
        
        closedIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closedIndicatorButton setImage:[UIImage imageNamed:@"gray_circle"] forState:UIControlStateNormal];
        [closedIndicatorButton setImage:[UIImage imageNamed:@"red_circle"] forState:UIControlStateSelected];
        [closedIndicatorButton setFrame:CGRectMake(7, 36, 10, 10)];
        [openingHoursIndicatorContainerView addSubview:closedIndicatorButton];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 10, 170, 20)];
        [nameLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [nameLabel setAdjustsFontSizeToFitWidth:YES];
        [nameLabel setTextColor:RGB(51, 51, 51)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:nameLabel];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 30, 260, 20)];
        [addressLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [addressLabel setAdjustsFontSizeToFitWidth:YES];
        [addressLabel setTextColor:RGB(125, 136, 149)];
        [addressLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:addressLabel];
        
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 9, 70, 24)];
        [distanceLabel setBackgroundColor:RGB(36, 84, 157)];
        [distanceLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [distanceLabel setTextColor:[UIColor whiteColor]];
        [distanceLabel setTextAlignment:NSTextAlignmentCenter];
        [contentView addSubview:distanceLabel];
        
        [self.contentView addSubview:contentView];
    }
    
    return self;
}

- (void)setLocation:(EntityLocation *)inLocation
{
    _location = inLocation;
    
    nameLabel.text = _location.name;
    addressLabel.text = _location.address;
    
    openedIndicatorButton.selected = [_location isOpenedRelativeToTimeDigits:_cachedTimeDigits];
    closedIndicatorButton.selected = !openedIndicatorButton.selected;
    
    CGFloat distanceKm = [_location distanceInKmToLocation:_cachedUserLocation];
    if (distanceKm > 0)
        distanceLabel.text = [NSString stringWithFormat:@"%.1f km", distanceKm];
}

@end
