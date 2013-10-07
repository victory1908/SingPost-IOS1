//
//  LocateUsDetailsPostingBoxView.h
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EntityLocation;
@protocol LocateUsDetailsPostingBoxDelegate;

@interface LocateUsDetailsPostingBoxView : UIView

- (id)initWithPostingBox:(EntityLocation *)postingBox andFrame:(CGRect)frame;

@property (nonatomic, readonly) EntityLocation *postingBox;
@property (nonatomic, weak) id<LocateUsDetailsPostingBoxDelegate> delegate;

@end

@protocol LocateUsDetailsPostingBoxDelegate <NSObject>

- (void)goToPostingBox:(EntityLocation *)postingBox;

@end
