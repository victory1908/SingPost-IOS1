//
//  LocateUsListView.h
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol LocateUsListDelegate;

@interface LocateUsListView : UIView

@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) CLLocationCoordinate2D *cachedUserCoordinate;
@property (nonatomic, readonly) UITableView *locationsTableView;

@end

@protocol LocateUsListDelegate <NSObject>

@end
