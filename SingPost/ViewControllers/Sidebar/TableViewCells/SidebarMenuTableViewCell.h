//
//  SidebarMenuTableViewCell.h
//  SingPost
//
//  Created by Edward Soetiono on 27/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SIDEBARMENU_CALCULATEPOSTAGE,
    SIDEBARMENU_FINDPOSTALCODES,
    SIDEBARMENU_LOCATEUS,
    SIDEBARMENU_SENDRECEIVE,
    SIDEBARMENU_PAY,
    SIDEBARMENU_SHOP,
    SIDEBARMENU_MORESERVICES,
    SIDEBARMENU_STAMPCOLLECTIBLES,
    SIDEBARMENU_MOREAPPS,
    SIDEBARMENU_OFFERSMORE,
    
    SIDEBARMENU_TOTAL
} tSidebarMenus;

@interface SidebarMenuTableViewCell : UITableViewCell

@property (nonatomic, assign) tSidebarMenus sidebarMenu;

- (void)animateShowSubRows:(BOOL)isSubRowsVisible;

@end
