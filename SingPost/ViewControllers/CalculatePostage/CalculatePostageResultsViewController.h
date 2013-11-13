//
//  CalculatePostageResultsViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatePostageResultsViewController : UIViewController

- (id)initWithResultItems:(NSArray *)resultItems;

@property (nonatomic, readonly) NSArray *resultItems;
@property (nonatomic) NSString *toCountry;
@property (nonatomic) NSString *itemWeight;
@property (nonatomic) NSString *expectedDeliveryTime;

@end
