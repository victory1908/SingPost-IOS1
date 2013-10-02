//
//  LocateUsDetailsOpeningHoursView.h
//  SingPost
//
//  Created by Edward Soetiono on 2/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EntityLocation;

@interface LocateUsDetailsOpeningHoursView : UIView

@property (nonatomic, readonly) EntityLocation *location;

- (id)initWithLocation:(EntityLocation *)inLocation andFrame:(CGRect)frame;

@end
