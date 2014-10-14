//
//  CalculatePostageResultsViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"

typedef enum {
    CALCULATEPOSTAGE_RESULT_TYPE_OVERSEAS,
    CALCULATEPOSTAGE_RESULT_TYPE_SINGAPORE
} tCalculatePostageResultTypes;

@interface CalculatePostageResultsViewController : SwipeViewController

- (id)initWithResultItems:(NSArray *)resultItems andResultType:(tCalculatePostageResultTypes)resultType;

@property (nonatomic, readonly) NSArray *resultItems;
@property (nonatomic, readonly) tCalculatePostageResultTypes resultType;
@property (nonatomic) NSString *toCountry;
@property (nonatomic) NSString *itemWeight;
@property (nonatomic) NSString *expectedDeliveryTime;
@property (nonatomic) NSString *toPostalCode;
@property (nonatomic) NSString *fromPostalCode;

@end
