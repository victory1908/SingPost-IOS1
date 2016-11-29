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

@class BarScannerViewController;
/**
 protocol for receiving updates on newly visible barcodes
 */
@protocol BarScannerViewControllerDelegate <NSObject>

@optional
- (void)barScannerViewController:(BarScannerViewController *)barScannerViewController
              didScanCode:(NSString *)code
                   ofType:(NSString *)type;

@end


@interface BarScannerViewController : UIViewController
//@interface BarScannerViewController : UIViewController < ZBarReaderDelegate >
@property (weak, nonatomic) IBOutlet UIView *contentView;
//@property (retain,nonatomic) LandingPageViewController * landingVC;

@property (nonatomic, weak) id<BarScannerViewControllerDelegate> barScannerDelegate;

@end
