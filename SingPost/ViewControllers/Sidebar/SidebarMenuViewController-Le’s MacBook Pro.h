//
//  SidebarMenuViewController.h
//  SingPost
//
//  Created by Edward Soetiono on 24/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarMenuViewController : UIViewController <BarScannerViewControllerDelegate>

- (void)updateMaintananceStatusUIs;

-(void) checkLoginStatus;

@property (nonatomic, assign) BOOL isVisible;

@end
