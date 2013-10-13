//
//  LocateUsDetailsServicesView.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LocateUsDetailsServicesView.h"
#import "UIFont+SingPost.h"

@implementation LocateUsDetailsServicesView
{
    UIScrollView *contentScrollView;
}

- (id)initWithServices:(NSArray *)services andFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [contentScrollView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *naLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, contentScrollView.bounds.size.width - 20, 15)];
        [naLabel setTextColor:RGB(58, 68, 81)];
        [naLabel setBackgroundColor:[UIColor clearColor]];
        [naLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [naLabel setText:@"N/A"];
        [contentScrollView addSubview:naLabel];
        
        [self addSubview:contentScrollView];
        
        if (services.count > 0) {
            //clear existing labels
            for (UIView *subview in contentScrollView.subviews) {
                if ([subview isKindOfClass:[UILabel class]])
                    [subview removeFromSuperview];
            }
            
            CGFloat offsetY = 20.0f;
            for (NSString *service in services) {
                UILabel *serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, contentScrollView.bounds.size.width - 20, 15)];
                [serviceLabel setTextColor:RGB(58, 68, 81)];
                [serviceLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
                [serviceLabel setBackgroundColor:[UIColor clearColor]];
                [serviceLabel setText:service];
                [contentScrollView addSubview:serviceLabel];
                
                offsetY += 40.0f;
            }
            
            [contentScrollView setContentSize:CGSizeMake(contentScrollView.bounds.size.width, offsetY)];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithServices:nil andFrame:frame];
}

@end
