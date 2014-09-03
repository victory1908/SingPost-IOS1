//
//  SidebarMenuSubRowTableViewCell.h
//  SingPost
//
//  Created by Edward Soetiono on 2/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SUBROWS_OFFERSMORE_ANNOUNCEMENTS,
    SUBROWS_OFFERSMORE_OFFERS,
    SUBROWS_OFFERSMORE_FEEDBACK,
    SUBROWS_OFFERSMORE_ABOUTTHISAPP,
    SUBROWS_OFFERSMORE_TERMSOFUSE,
    SUBROWS_OFFERSMORE_FAQ,
    SUBROWS_OFFERSMORE_RATEOURAPP,
    SUBROWS_OFFERSMORE_SIGNOFF,
    SUBROWS_OFFERSMORE_TOTAL
} tSubRowsOffersMore;

@interface SidebarMenuSubRowTableViewCell : UITableViewCell

@property (nonatomic, assign) tSubRowsOffersMore subrowMenuOffersMore;
@property (nonatomic, assign) BOOL showBottomSeparator;

@end
