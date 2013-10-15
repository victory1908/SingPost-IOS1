//
//  OffersDetailsViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 15/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Offer;

@interface OfferDetailsViewController : UIViewController

- (id)initWithOffer:(Offer *)offer;

@property (nonatomic, readonly) Offer *offer;

@end
