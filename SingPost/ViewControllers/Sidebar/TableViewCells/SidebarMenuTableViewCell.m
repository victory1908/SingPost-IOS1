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
    UIImageView *menuImageView;
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
        
        [self.contentView addSubview:contentView];
        
    }
    return self;
}

- (void)setSidebarMenu:(tSidebarMenus)inSidebarMenu
{
    _sidebarMenu = inSidebarMenu;
    
    NSDictionary *sidebarMenuData = self.sidebarMenusData[_sidebarMenu];
    [menuNameLabel setText:sidebarMenuData[@"name"]];
    [menuImageView setImage:[UIImage imageNamed:sidebarMenuData[@"image"]]];
}

@end
