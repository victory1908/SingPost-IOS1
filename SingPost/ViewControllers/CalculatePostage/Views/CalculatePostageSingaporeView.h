//
//  CalculatePostageSingaporeView.h
//  SingPost
//
//  Created by Edward Soetiono on 29/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalculatePostageSingaporeDelegate;

@interface CalculatePostageSingaporeView : UIView

@property (nonatomic, weak) id <CalculatePostageSingaporeDelegate> delegate;

@end

@protocol CalculatePostageSingaporeDelegate <NSObject>

- (void)calculatePostageSingapore:(CalculatePostageSingaporeView *)sender;

@end


