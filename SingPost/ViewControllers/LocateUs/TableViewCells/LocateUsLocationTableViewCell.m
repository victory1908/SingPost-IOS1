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
#import "PersistentBackgroundLabel.h"

@implementation LocateUsLocationTableViewCell
{
    PersistentBackgroundLabel *nameLabel, *addressLabel, *distanceLabel;
    UIButton *openedIndicatorButton, *closedIndicatorButton;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = RGB(204, 204, 204);
        self.selectedBackgroundView = v;
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [contentView setBackgroundColor:[UIColor clearColor]];
        
        UIView *openingHoursIndicatorContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 60)];
        [openingHoursIndicatorContainerView setBackgroundColor:RGB(237, 237, 237)];
        [contentView addSubview:openingHoursIndicatorContainerView];
        
        openedIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [openedIndicatorButton setUserInteractionEnabled:NO];
        [openedIndicatorButton setImage:[UIImage imageNamed:@"gray_circle"] forState:UIControlStateNormal];
        [openedIndicatorButton setImage:[UIImage imageNamed:@"green_circle"] forState:UIControlStateSelected];
        [openedIndicatorButton setFrame:CGRectMake(7, 16, 10, 10)];
        [openingHoursIndicatorContainerView addSubview:openedIndicatorButton];
        
        closedIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closedIndicatorButton setUserInteractionEnabled:NO];
        [closedIndicatorButton setImage:[UIImage imageNamed:@"gray_circle"] forState:UIControlStateNormal];
        [closedIndicatorButton setImage:[UIImage imageNamed:@"red_circle"] forState:UIControlStateSelected];
        [closedIndicatorButton setFrame:CGRectMake(7, 36, 10, 10)];
        [openingHoursIndicatorContainerView addSubview:closedIndicatorButton];
        
        nameLabel = [[PersistentBackgroundLabel alloc] initWithFrame:CGRectMake(38, 10, 170, 20)];
        [nameLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [nameLabel setTextColor:RGB(51, 51, 51)];
        [nameLabel setPersistentBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:nameLabel];
        
        addressLabel = [[PersistentBackgroundLabel alloc] initWithFrame:CGRectMake(38, 30, 170, 20)];
        [addressLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [addressLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [addressLabel setTextColor:RGB(125, 136, 149)];
        [addressLabel setPersistentBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:addressLabel];
        
        distanceLabel = [[PersistentBackgroundLabel alloc] initWithFrame:CGRectMake(210, 9, 70, 24)];
        [distanceLabel setPersistentBackgroundColor:RGB(36, 84, 157)];
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
    
    openedIndicatorButton.selected = [_location isOpenedAtCurrentTimeDigits:_cachedTimeDigits];
    closedIndicatorButton.selected = !openedIndicatorButton.selected;
    
    CGFloat distanceKm = [_location distanceInKmToLocation:_cachedUserLocation];
    if (distanceKm > 0)
        distanceLabel.text = [NSString stringWithFormat:@"%.1f km", distanceKm];
}

@end
