//
//  SidebarMenuTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 27/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SidebarMenuTableViewCell.h"
#import "UIFont+SingPost.h"

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
        v.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
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
        [starIndicatorImageView setFrame:CGRectMake(210, 12, 20, 20)];
        [starIndicatorImageView setHidden:YES];
        [contentView addSubview:starIndicatorImageView];
        
        subrowIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showSubRow_indicator"]];
        [subrowIndicatorImageView setFrame:CGRectMake(215, 20, 8, 5)];
        [subrowIndicatorImageView setHidden:YES];
        subrowIndicatorImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
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
}

- (void)animateShowSubRows:(BOOL)isSubRowsVisible
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         subrowIndicatorImageView.transform = isSubRowsVisible ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(-M_PI_2);
                     }];
}

@end
