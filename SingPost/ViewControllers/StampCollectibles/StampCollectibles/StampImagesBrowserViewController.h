//
//  StampImagesBrowserViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 14/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StampImageBrowserDelegate;

@interface StampImagesBrowserViewController : UIViewController

- (id)initWithStampImages:(NSArray *)stampImages;

@property (nonatomic, readonly) NSArray *stampImages;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, weak) id<StampImageBrowserDelegate> delegate;

@end

@protocol StampImageBrowserDelegate <NSObject>

- (void)stampImageBrowserDismissed:(StampImagesBrowserViewController *)browserViewController;

@end
