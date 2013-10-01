//
//  LocateUsLocationTableViewCell.h
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class EntityLocation;

@interface LocateUsLocationTableViewCell : UITableViewCell

@property (nonatomic) EntityLocation *location;
@property (nonatomic) CLLocation *cachedUserLocation;
@property (nonatomic, assign) NSInteger cachedTimeDigits;

@end
