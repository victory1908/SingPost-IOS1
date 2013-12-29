//
//  OffersDetailsViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 30/12/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersDetailsViewController : UIViewController

- (id)initWithOfferJSON:(NSDictionary *)offerJSON;

@property (nonatomic, readonly) NSDictionary *offerJSON;

@end
