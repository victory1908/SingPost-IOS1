
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
    UIScrollView *contentScrollView;
    UILabel *monOpeningHoursLabel, *tuesOpeningHoursLabel, *wedOpeningHoursLabel, *thursOpeningHoursLabel, *friOpeningHoursLabel, *saturdayOpeningHoursLabel, *sundayOpeningHoursLabel, *publicHolidayOpeningHoursLabel,*monToFriOpeningHoursLabel;
}

//designated initializer
- (id)initWithLocation:(EntityLocation *)inLocation andFrame:(CGRect)frame
{
    NSParameterAssert(inLocation);
    _location = inLocation;
    if ((self = [super initWithFrame:frame])) {
        contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [contentScrollView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:contentScrollView];
        
        CGFloat offsetY = 15.0f;
        
        UILabel *dayHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 100, 20)];
        [dayHeaderLabel setText:@"Day"];
        [dayHeaderLabel setBackgroundColor:[UIColor clearColor]];
        [dayHeaderLabel setTextColor:RGB(36, 84, 157)];
        [dayHeaderLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [contentScrollView addSubview:dayHeaderLabel];
        
        UILabel *openingHoursHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(131, offsetY, 180, 20)];
        openingHoursHeaderLabel.right = contentScrollView.right - 15;
        [openingHoursHeaderLabel setText:[_location.type isEqualToString:LOCATION_TYPE_POSTING_BOX] ? @"Last Collection Time" : @"Operating Hours"];
        [openingHoursHeaderLabel setTextAlignment:NSTextAlignmentRight];
        [openingHoursHeaderLabel setBackgroundColor:[UIColor clearColor]];
        [openingHoursHeaderLabel setTextColor:RGB(36, 84, 157)];
        [openingHoursHeaderLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [contentScrollView addSubview:openingHoursHeaderLabel];
        
        offsetY += 30.0f;
        
        if (![self isWeekdayOpeningSame]) {
            UILabel *mondayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
            [mondayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [mondayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
            [mondayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
            [mondayOpeningHoursDisplayLabel setText:@"Monday"];
            [contentScrollView addSubview:mondayOpeningHoursDisplayLabel];
            
            monOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 150, 20)];
            monOpeningHoursLabel.right = contentScrollView.right - 15;
            [monOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
            [monOpeningHoursLabel setTextAlignment:NSTextAlignmentRight];
            [monOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [monOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
            [contentScrollView addSubview:monOpeningHoursLabel];
            [monOpeningHoursLabel setText:_location.monOpeningHours];
            
            offsetY += 30.0f;
            
            UILabel *tuesdayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
            [tuesdayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [tuesdayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
            [tuesdayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
            [tuesdayOpeningHoursDisplayLabel setText:@"Tuesday"];
            [contentScrollView addSubview:tuesdayOpeningHoursDisplayLabel];
            
            tuesOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 150, 20)];
            tuesOpeningHoursLabel.right = contentScrollView.right - 15;
            [tuesOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
            [tuesOpeningHoursLabel setTextAlignment:NSTextAlignmentRight];
            [tuesOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [tuesOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
            [contentScrollView addSubview:tuesOpeningHoursLabel];
            [tuesOpeningHoursLabel setText:_location.tuesOpeningHours];
            
            offsetY += 30.0f;
            
            UILabel *wednesdayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
            [wednesdayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [wednesdayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
            [wednesdayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
            [wednesdayOpeningHoursDisplayLabel setText:@"Wednesday"];
            [contentScrollView addSubview:wednesdayOpeningHoursDisplayLabel];
            
            wedOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 150, 20)];
            wedOpeningHoursLabel.right = contentScrollView.right - 15;
            [wedOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
            [wedOpeningHoursLabel setTextAlignment:NSTextAlignmentRight];
            [wedOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [wedOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
            [contentScrollView addSubview:wedOpeningHoursLabel];
            [wedOpeningHoursLabel setText:_location.wedOpeningHours];
            
            offsetY += 30.0f;
            
            UILabel *thursdayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
            [thursdayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [thursdayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
            [thursdayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
            [thursdayOpeningHoursDisplayLabel setText:@"Thursday"];
            [contentScrollView addSubview:thursdayOpeningHoursDisplayLabel];
            
            thursOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 150, 20)];
            thursOpeningHoursLabel.right = contentScrollView.right - 15;
            [thursOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
            [thursOpeningHoursLabel setTextAlignment:NSTextAlignmentRight];
            [thursOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [thursOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
            [contentScrollView addSubview:thursOpeningHoursLabel];
            [thursOpeningHoursLabel setText:_location.thursOpeningHours];
            
            offsetY += 30.0f;
            
            UILabel *fridayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
            [fridayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [fridayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
            [fridayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
            [fridayOpeningHoursDisplayLabel setText:@"Friday"];
            [contentScrollView addSubview:fridayOpeningHoursDisplayLabel];
            
            friOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 150, 20)];
            friOpeningHoursLabel.right = contentScrollView.right - 15;
            [friOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
            [friOpeningHoursLabel setTextAlignment:NSTextAlignmentRight];
            [friOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [friOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
            [contentScrollView addSubview:friOpeningHoursLabel];
            [friOpeningHoursLabel setText:_location.friOpeningHours];
            
            offsetY += 30.0f;
        }
        else {
            UILabel *monToFriOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
            [monToFriOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [monToFriOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
            [monToFriOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
            [monToFriOpeningHoursDisplayLabel setText:@"Monday - Friday"];
            [contentScrollView addSubview:monToFriOpeningHoursDisplayLabel];
            
            monToFriOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 150, 20)];
            monToFriOpeningHoursLabel.right = contentScrollView.right - 15;
            [monToFriOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
            [monToFriOpeningHoursLabel setTextAlignment:NSTextAlignmentRight];
            [monToFriOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [monToFriOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
            [contentScrollView addSubview:monToFriOpeningHoursLabel];
            monToFriOpeningHoursLabel.text = _location.monOpeningHours;
            
            offsetY += 30.0f;
        }
        
        UILabel *saturdayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
        [saturdayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [saturdayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
        [saturdayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [saturdayOpeningHoursDisplayLabel setText:@"Saturday"];
        [contentScrollView addSubview:saturdayOpeningHoursDisplayLabel];
        
        saturdayOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 150, 20)];
        saturdayOpeningHoursLabel.right = contentScrollView.right - 15;
        [saturdayOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
        [saturdayOpeningHoursLabel setTextAlignment:NSTextAlignmentRight];
        [saturdayOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [saturdayOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
        [contentScrollView addSubview:saturdayOpeningHoursLabel];
        offsetY += 30.0f;
        
        UILabel *sundayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
        [sundayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [sundayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
        [sundayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [sundayOpeningHoursDisplayLabel setText:@"Sunday"];
        [contentScrollView addSubview:sundayOpeningHoursDisplayLabel];
        
        sundayOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 150, 20)];
        sundayOpeningHoursLabel.right = contentScrollView.right - 15;
        [sundayOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
        [sundayOpeningHoursLabel setTextAlignment:NSTextAlignmentRight];
        [sundayOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [sundayOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
        [contentScrollView addSubview:sundayOpeningHoursLabel];
        offsetY += 30.0f;
        
        UILabel *publicHolidayOpeningHoursDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 180, 20)];
        [publicHolidayOpeningHoursDisplayLabel setTextColor:RGB(58, 68, 81)];
        [publicHolidayOpeningHoursDisplayLabel setFont:[UIFont SingPostLightFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [publicHolidayOpeningHoursDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [publicHolidayOpeningHoursDisplayLabel setText:@"Public Holiday"];
        [contentScrollView addSubview:publicHolidayOpeningHoursDisplayLabel];
        
        publicHolidayOpeningHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 150, 20)];
        publicHolidayOpeningHoursLabel.right = contentScrollView.right - 15;
        [publicHolidayOpeningHoursLabel setTextColor:RGB(58, 68, 81)];
        [publicHolidayOpeningHoursLabel setTextAlignment:NSTextAlignmentRight];
        [publicHolidayOpeningHoursLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [publicHolidayOpeningHoursLabel setBackgroundColor:[UIColor clearColor]];
        [contentScrollView addSubview:publicHolidayOpeningHoursLabel];
        offsetY += 30.0f;
        
        [contentScrollView setContentSize:CGSizeMake(contentScrollView.bounds.size.width, offsetY)];
        
        //populate fields
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

- (BOOL)isWeekdayOpeningSame {
    
    NSArray *tempArray = [NSArray arrayWithObjects:_location.tuesOpeningHours,_location.wedOpeningHours,
                          _location.thursOpeningHours,_location.friOpeningHours, nil];
    
    for (NSString *openingHours in tempArray) {
        if (![openingHours isEqualToString:_location.monOpeningHours])
            return NO;
    }
    return YES;
}

@end
