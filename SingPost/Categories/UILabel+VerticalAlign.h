//
//  UILabel+VerticalAlign.h
//  WanBao
//
//  Created by Edward Soetiono on 2/2/13.
//  Copyright 2013 SPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (VerticalAlign)

- (void)alignTop;

- (void)sizeToFitKeepHeight;
- (void)sizeToFitKeepWidth;
- (CGSize)neededSizeForText:(NSString*)text withFont:(UIFont*)font andMaxWidth:(float)maxWidth;

@end
