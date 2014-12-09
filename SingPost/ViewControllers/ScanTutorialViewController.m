//
//  ScanTutorialViewController.m
//  SingPost
//
//  Created by Li Le on 26/11/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "ScanTutorialViewController.h"

@interface ScanTutorialViewController ()


@end

@implementation ScanTutorialViewController
@synthesize nextBtn;
@synthesize PrevBtn;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.alpha = 0.0f;
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.view.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCloseClicked:(id)sender {
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"12121"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.view removeFromSuperview];
}

- (IBAction)onNextClicked:(id)sender {
    [self.nextBtn setHidden:YES];
    [self.PrevBtn setHidden:NO];
    [self.imageView setImage:[UIImage imageNamed:@"tutorial02.png"]];
}


- (IBAction)onPrevClicked:(id)sender {
    [self.nextBtn setHidden:NO];
    [self.PrevBtn setHidden:YES];
    [self.imageView setImage:[UIImage imageNamed:@"tutorial01.png"]];
}

@end
