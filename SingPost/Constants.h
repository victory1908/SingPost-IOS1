//
//  Constants.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

typedef enum {
    APP_PAGE_CALCULATEPOSTAGE = 1,
    APP_PAGE_POSTALCODES,
    APP_PAGE_LOCATEUS,
    APP_PAGE_SENDRECEIVE,
    APP_PAGE_PAY,
    APP_PAGE_SHOP,
    APP_PAGE_MORESERVICES,
    APP_PAGE_STAMPCOLLECTIBLES,
    APP_PAGE_OFFERS,
    APP_PAGE_TRACKING
} tAppPages;

//Frames
#define NAVIGATIONBAR_FRAME CGRectMake(0, 0, contentView.bounds.size.width, 44)