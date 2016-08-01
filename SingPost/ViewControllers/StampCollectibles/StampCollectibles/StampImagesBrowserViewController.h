//
//  StampImagesBrowserViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 14/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"

@protocol StampImageBrowserDelegate;

@interface StampImagesBrowserViewController : SwipeViewController

- (id)initWithStampImages:(NSArray *)stampImages;

@property (nonatomic, readonly) NSArray *stampImages;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, weak) id<StampImageBrowserDelegate> delegate;
//@property (nonatomic,retain) NSString * title;
@property (nonatomic, copy) NSString * title;


@end

@protocol StampImageBrowserDelegate <NSObject>

- (void)stampImageBrowserDismissed:(StampImagesBrowserViewController *)browserViewController;

@end
