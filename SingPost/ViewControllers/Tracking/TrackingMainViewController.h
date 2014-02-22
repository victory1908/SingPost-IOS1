//
//  TrackingMainViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingMainViewController : UIViewController

@property (nonatomic) NSString *trackingNumber;

@property (nonatomic,assign) BOOL isOn;

- (void)addTrackingNumber:(NSString *)trackingNumber;

@end
