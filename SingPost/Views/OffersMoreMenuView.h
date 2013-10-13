//
//  OffersMoreMenuView.h
//  SingPost
//
//  Created by Edward Soetiono on 13/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    OFFERSMENUBUTTON_OFFERS = 700,
    OFFERSMENUBUTTON_FEEDBACK,
    OFFERSMENUBUTTON_ABOUTTHISAPP,
    OFFERSMENUBUTTON_TERMSOFUSE,
    OFFERSMENUBUTTON_FAQS,
    OFFERSMENUBUTTON_RATEOURAPP
} tOffersMenuButtons;

@protocol OffersMenuDelegate;

@interface OffersMoreMenuView : UIView

@property (nonatomic, weak) id<OffersMenuDelegate> delegate;
@property (nonatomic, assign) BOOL isShown;

@end

@protocol OffersMenuDelegate <NSObject>

- (void)toggleShowOffersMoreMenu;
- (void)offersMenuButtonClicked:(tOffersMenuButtons)button;

@end
