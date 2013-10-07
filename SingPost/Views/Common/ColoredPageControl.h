//
//  ColoredPageControl.h
//  WanBao
//
//  Created by Edward Soetiono on 20/12/12.
//  Copyright (c) 2012 SPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ColoredPageControlDelegate;

@interface ColoredPageControl : UIView 

// Set these to control the PageControl.
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;

// Customize these as well as the backgroundColor property.
@property (nonatomic) UIColor *dotColorCurrentPage;
@property (nonatomic) UIColor *dotColorOtherPage;

@property (nonatomic, assign) CGFloat dotDiameter;
@property (nonatomic, assign) CGFloat dotSpacer;

// Optional delegate for callbacks when user taps a page dot.
@property (nonatomic, weak) id<ColoredPageControlDelegate> delegate;

@end

@protocol ColoredPageControlDelegate<NSObject>
@optional
- (void)pageControlPageDidChange:(ColoredPageControl *)pageControl;
@end