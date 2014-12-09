//
//  ScanTutorialViewController.h
//  SingPost
//
//  Created by Li Le on 26/11/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanTutorialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *PrevBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

- (IBAction)onCloseClicked:(id)sender;
- (IBAction)onNextClicked:(id)sender;
- (IBAction)onPrevClicked:(id)sender ;
@end
