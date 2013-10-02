
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
    UILabel *monFriOpeningHoursLabel, *monThuOpeningHoursLabel, *friOpeningHoursLabel, *saturdayOpeningHoursLabel, *sundayOpeningHoursLabel, *publicHolidayOpeningHoursLabel;
}

//designated initializer
- (id)initWithLocation:(EntityLocation *)inLocation andFrame:(CGRect)frame
{
    NSParameterAssert(inLocation);
    _location = inLocation;
    if ((self = [super initWithFrame:frame])) {
        CGFloat offsetY = 20.0f;
        if ([_location.type isEqualToString:LOCATION_TYPE_POSTING_BOX]) {
            UILabel *monThuOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
            [monThuOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [monThuOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
            [monThuOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
            [monThuOpeningHoursDisplayLabel setText:@"Mon - Thu"];
            [self addSubview:monThuOpeningHoursDisplayLabel];
            
            monThuOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, offsetY, 110, 20)];
            [monThuOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
            [monThuOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [monThuOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
            [self addSubview:monThuOpeningHoursLabel];
            offsetY += 30.0f;
            
            UILabel *friOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
            [friOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [friOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
            [friOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
            [friOpeningHoursDisplayLabel setText:@"Fri"];
            [self addSubview:friOpeningHoursDisplayLabel];
            
            friOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, offsetY, 110, 20)];
            [friOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
            [friOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [friOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
            [self addSubview:friOpeningHoursLabel];
            offsetY += 30.0f;
        }
        else {
            UILabel *monFriOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
            [monFriOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [monFriOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
            [monFriOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
            [monFriOpeningHoursDisplayLabel setText:@"Mon - Fri"];
            [self addSubview:monFriOpeningHoursDisplayLabel];
            
            monFriOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, offsetY, 110, 20)];
            [monFriOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
            [monFriOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [monFriOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
            [self addSubview:monFriOpeningHoursLabel];
            offsetY += 30.0f;
        }
        
        UILabel *saturdayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
        [saturdayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [saturdayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
        [saturdayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [saturdayOpeningHoursDisplayLabel setText:@"Saturday"];
        [self addSubview:saturdayOpeningHoursDisplayLabel];
        
        saturdayOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, offsetY, 110, 20)];
        [saturdayOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
        [saturdayOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [saturdayOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:saturdayOpeningHoursLabel];
        offsetY += 30.0f;
        
        UILabel *sundayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
        [sundayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [sundayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
        [sundayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [sundayOpeningHoursDisplayLabel setText:@"Sunday"];
        [self addSubview:sundayOpeningHoursDisplayLabel];
        
        sundayOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, offsetY, 110, 20)];
        [sundayOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
        [sundayOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [sundayOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:sundayOpeningHoursLabel];
        offsetY += 30.0f;
        
        UILabel *publicHolidayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
        [publicHolidayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
        [publicHolidayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [publicHolidayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [publicHolidayOpeningHoursDisplayLabel setText:@"Public Holiday"];
        [self addSubview:publicHolidayOpeningHoursDisplayLabel];
        
        publicHolidayOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, offsetY, 110, 20)];
        [publicHolidayOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
        [publicHolidayOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [publicHolidayOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:publicHolidayOpeningHoursLabel];
        
        //populate fields
        [monFriOpeningHoursLabel setText:_location.monFriOpeningHours];
        [monThuOpeningHoursLabel setText:_location.monThuOpeningHours];
        [friOpeningHoursLabel setText:_location.friOpeningHours];
        [saturdayOpeningHoursLabel setText:_location.satOpeningHours];
        [sundayOpeningHoursLabel setText:_location.sunOpeningHours];
        [publicHolidayOpeningHoursLabel setText:_location.publicHolidayOpeningHours];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithLocation:nil andFrame:frame];
}


@end
