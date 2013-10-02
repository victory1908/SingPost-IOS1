
//
//  LocateUsDetailsOpeningHoursView.m
//  SingPost
//
//  Created by Edward Soetiono on 2/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LocateUsDetailsOpeningHoursView.h"
#import "UIFont+SingPost.h"
#import "EntityLocation.h"

@implementation LocateUsDetailsOpeningHoursView
{
    UILabel *monFriOpeningHoursLabel, *saturdayOpeningHoursLabel, *sundayOpeningHoursLabel, *publicHolidayOpeningHoursLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        UILabel *monFriOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 180, 20)];
        [monFriOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [monFriOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
        [monFriOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [monFriOpeningHoursDisplayLabel setText:@"Mon - Fri"];
        [self addSubview:monFriOpeningHoursDisplayLabel];
        
        UILabel *saturdayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 180, 20)];
        [saturdayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [saturdayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
        [saturdayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [saturdayOpeningHoursDisplayLabel setText:@"Saturday"];
        [self addSubview:saturdayOpeningHoursDisplayLabel];
        
        UILabel *sundayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 180, 20)];
        [sundayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [sundayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
        [sundayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [sundayOpeningHoursDisplayLabel setText:@"Sunday"];
        [self addSubview:sundayOpeningHoursDisplayLabel];
        
        UILabel *publicHolidayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 180, 20)];
        [publicHolidayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
        [publicHolidayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [publicHolidayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [publicHolidayOpeningHoursDisplayLabel setText:@"Public Holiday"];
        [self addSubview:publicHolidayOpeningHoursDisplayLabel];
        
        monFriOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 20, 110, 20)];
        [monFriOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
        [monFriOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [monFriOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:monFriOpeningHoursLabel];
        
        saturdayOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 50, 110, 20)];
        [saturdayOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
        [saturdayOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [saturdayOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:saturdayOpeningHoursLabel];
        
        sundayOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 80, 110, 20)];
        [sundayOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
        [sundayOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [sundayOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:sundayOpeningHoursLabel];
        
        publicHolidayOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 110, 110, 20)];
        [publicHolidayOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
        [publicHolidayOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [publicHolidayOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:publicHolidayOpeningHoursLabel];
    }
    
    return self;
}

- (void)setLocation:(EntityLocation *)inLocation
{
    _location = inLocation;
    
    [monFriOpeningHoursLabel setText:[_location.mon_opening isEqualToString:@"Closed"] ? @"Closed" : [NSString stringWithFormat:@"%@ - %@", _location.mon_opening, _location.mon_closing]];
    [saturdayOpeningHoursLabel setText:[_location.sat_opening isEqualToString:@"Closed"] ? @"Closed" : [NSString stringWithFormat:@"%@ - %@", _location.sat_opening, _location.sat_closing]];
    [sundayOpeningHoursLabel setText:[_location.sun_opening isEqualToString:@"Closed"] ? @"Closed" : [NSString stringWithFormat:@"%@ - %@", _location.sun_opening, _location.sun_closing]];
    [publicHolidayOpeningHoursLabel setText:[_location.ph_opening isEqualToString:@"Closed"] ? @"Closed" : [NSString stringWithFormat:@"%@ - %@", _location.ph_opening, _location.ph_closing]];
}

@end
