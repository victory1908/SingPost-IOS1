//
//  StampCollectibleDetailExpandableView.h
//  SingPost
//
//  Created by Edward Soetiono on 10/12/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StampCollectibleDetailExpandableView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, readonly) BOOL isExpanded;
@property (nonatomic, readonly) CGFloat expandedHeight;
@property (nonatomic, readonly) CGFloat collapsedHeight;
@property (nonatomic, readonly) CGFloat deltaHeight;

- (id)initWithFrame:(CGRect)frame andText:(NSString *)text;
- (void)toggleExpandCollapse;
- (void)resizeAndAlignTop;

@end
