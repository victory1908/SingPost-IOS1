//
//  StampCollectiblesDetailsViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 14/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Stamp;

@interface StampCollectiblesDetailsViewController : UIViewController

- (id)initWithStamp:(Stamp *)stamp;

@property (nonatomic, readonly) Stamp *stamp;

@end
