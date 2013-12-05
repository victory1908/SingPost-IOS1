//
//  SidebarMenuTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 27/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SidebarMenuTableViewCell.h"
#import "UIFont+SingPost.h"
#import "AppDelegate.h"

@interface SidebarMenuTableViewCell ()

@property (nonatomic, readonly) NSArray *sidebarMenusData;

@end

@implementation SidebarMenuTableViewCell
{
    UILabel *menuNameLabel;
    UIImageView *menuImageView, *subrowIndicatorImageView, *starIndicatorImageView;
}

- (NSArray *)sidebarMenusData
{
    static NSArray *sharedSidebarMenusData;
    if (!sharedSidebarMenusData)
        sharedSidebarMenusData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SidebarMenus" ofType:@"plist"]];
    
    return sharedSidebarMenusData;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = RGB(204, 204, 204);
        self.selectedBackgroundView = v;
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        
        menuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 20, 20)];
        [contentView addSubview:menuImageView];
        
        menuNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 12, 140, 21)];
        [menuNameLabel setBackgroundColor:[UIColor clearColor]];
        [menuNameLabel setTextColor:RGB(58, 68, 81)];
        [menuNameLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [contentView addSubview:menuNameLabel];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.bounds.size.height - 1, contentView.bounds.size.width, 1)];
        [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [separatorView setBackgroundColor:RGB(225, 225, 225)];
        [contentView addSubview:separatorView];
        
        starIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
        [starIndicatorImageView setFrame:CGRectMake(SIDEBAR_WIDTH - 38, 12, 20, 20)];
        [starIndicatorImageView setHidden:YES];
        [contentView addSubview:starIndicatorImageView];
        
        subrowIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showSubRow_indicator"]];
        [subrowIndicatorImageView setFrame:CGRectMake(SIDEBAR_WIDTH - 32, 20, 8, 5)];
        [subrowIndicatorImageView setHidden:YES];
        [contentView addSubview:subrowIndicatorImageView];
        
        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [subrowIndicatorImageView setHidden:YES];
    [starIndicatorImageView setHidden:YES];
}

- (void)setSidebarMenu:(tSidebarMenus)inSidebarMenu
{
    _sidebarMenu = inSidebarMenu;
    
    NSDictionary *sidebarMenuData = self.sidebarMenusData[_sidebarMenu];
    [menuNameLabel setText:sidebarMenuData[@"name"]];
    [menuImageView setImage:[UIImage imageNamed:sidebarMenuData[@"image"]]];
    
    if (_sidebarMenu == SIDEBARMENU_OFFERSMORE)
        [subrowIndicatorImageView setHidden:NO];
    
    if (_sidebarMenu == SIDEBARMENU_STAMPCOLLECTIBLES)
        [starIndicatorImageView setHidden:NO];
    
    NSDictionary *maintananceStatuses = [[AppDelegate sharedAppDelegate] maintenanceStatuses];
    CGFloat alpha = 1.0f;
    switch (_sidebarMenu) {
        case SIDEBARMENU_CALCULATEPOSTAGE:
        {
            alpha = [maintananceStatuses[@"CalculatePostage"] isEqualToString:@"on"] ? 0.5f : 1.0f;;
            break;
        }
        case SIDEBARMENU_FINDPOSTALCODES:
        {
            alpha = [maintananceStatuses[@"FindPostalCodes"] isEqualToString:@"on"] ? 0.5f : 1.0f;;
            break;
        }
        case SIDEBARMENU_LOCATEUS:
        {
            alpha = [maintananceStatuses[@"LocateUs"] isEqualToString:@"on"] ? 0.5f : 1.0f;;
            break;
        }
        case SIDEBARMENU_SENDRECEIVE:
        {
            alpha = [maintananceStatuses[@"SendNReceive"] isEqualToString:@"on"] ? 0.5f : 1.0f;;
            break;
        }
        case SIDEBARMENU_PAY:
        {
            alpha = [maintananceStatuses[@"Pay"] isEqualToString:@"on"] ? 0.5f : 1.0f;;
            break;
        }
        case SIDEBARMENU_SHOP:
        {
            alpha = [maintananceStatuses[@"Shop"] isEqualToString:@"on"] ? 0.5f : 1.0f;;
            break;
        }
        case SIDEBARMENU_MORESERVICES:
        {
            alpha = [maintananceStatuses[@"MoreServices"] isEqualToString:@"on"] ? 0.5f : 1.0f;;
            break;
        }
        case SIDEBARMENU_STAMPCOLLECTIBLES:
        {
            alpha = [maintananceStatuses[@"StampCollectibles"] isEqualToString:@"on"] ? 0.5f : 1.0f;;
            break;
        }
        case SIDEBARMENU_MOREAPPS:
        {
            alpha = [maintananceStatuses[@"MoreApps"] isEqualToString:@"on"] ? 0.5f : 1.0f;;
            break;
        }
        default:
            alpha = 1.0f;
            NSLog(@"not yet implemented");
            break;

    }
    
    [menuNameLabel setAlpha:alpha];
    [menuImageView setAlpha:alpha];
    [subrowIndicatorImageView setAlpha:alpha];
    [starIndicatorImageView setAlpha:alpha];
}

- (void)animateShowSubRows:(BOOL)isSubRowsVisible
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         subrowIndicatorImageView.transform = isSubRowsVisible ? CGAffineTransformMakeRotation(-M_PI) : CGAffineTransformIdentity;
                     }];
}

@end
