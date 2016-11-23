//
//  BarScannerViewController.h
//  SingPost
//
//  Created by Li Le on 23/10/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZBarSDK.h"
#import "LandingPageViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface BarScannerViewController : UIViewController
//@interface BarScannerViewController : UIViewController < ZBarReaderDelegate >
@property (weak, nonatomic) IBOutlet UIView *contentView;
//@property (retain,nonatomic) LandingPageViewController * landingVC;


@end
