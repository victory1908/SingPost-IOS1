//
//  LandingPageViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanTutorialViewController.h"

@interface LandingPageViewController : UIViewController {
    ScanTutorialViewController * vc;
}

- (void)updateMaintananceStatusUIs;

@end
