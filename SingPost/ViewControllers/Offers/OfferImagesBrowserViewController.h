//
//  OfferImagesBrowserViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 15/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OferImageBrowserDelegate;

@interface OfferImagesBrowserViewController : UIViewController

- (id)initWithOfferImages:(NSArray *)offerImages;

@property (nonatomic, readonly) NSArray *offerImages;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, weak) id<OferImageBrowserDelegate> delegate;

@end

@protocol OferImageBrowserDelegate <NSObject>

- (void)offerImageBrowserDismissed:(OfferImagesBrowserViewController *)browserViewController;

@end
