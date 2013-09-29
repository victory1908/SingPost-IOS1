//
//  CalculatePostageOverseasView.h
//  SingPost
//
//  Created by Edward Soetiono on 29/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalculatePostageOverseasDelegate;

@interface CalculatePostageOverseasView : UIView

@property (nonatomic, weak) id <CalculatePostageOverseasDelegate> delegate;

@end

@protocol CalculatePostageOverseasDelegate <NSObject>

- (void)calculatePostageOverseas:(CalculatePostageOverseasView *)sender;

@end
