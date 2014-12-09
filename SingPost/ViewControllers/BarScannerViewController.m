//
//  BarScannerViewController.m
//  SingPost
//
//  Created by Li Le on 23/10/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "BarScannerViewController.h"
#import "TrackingMainViewController.h"
#import "ScanTutorialViewController.h"


@interface BarScannerViewController () {
    ZBarReaderViewController *reader;
    __weak IBOutlet UIView *redLine;
    
    ScanTutorialViewController * vc;
}

@end

@implementation BarScannerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // ADD: present a barcode reader that scans from the camera feed
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
    reader.cameraOverlayView = self.contentView;
    reader.showsZBarControls = NO;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [scanner setSymbology: ZBAR_QRCODE
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    
    reader.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //reader.scanCrop = CGRectMake(0, 0.3, 1, 0.7);
    
    // present and release the controller
    //[self presentModalViewController: reader animated: YES];
    [self presentViewController:reader animated:YES completion:^(void){[self animateScanner];}];

    
    //[self.view addSubview:reader.view];
    //[self.view bringSubviewToFront:self.contentView];
}



- (IBAction)onCloseClicked:(id)sender {
    [reader dismissModalViewControllerAnimated: YES];
    
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:self.landingVC];
    
}

- (void) animateScanner {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // do whatever animation you want, e.g.,
                         
                         redLine.alpha = 1.0f;
                     }
                     completion:NULL];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    NSLog([NSString stringWithFormat:@"%@",symbol.data]);
    
    // EXAMPLE: do something useful with the barcode image
   // resultImage.image =
    //[info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    
    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
    trackingMainViewController.isPushNotification = NO;
    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:trackingMainViewController];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [trackingMainViewController addTrackingNumber:symbol.data];
    });
    
    
}

- (IBAction)onHelpClicked:(id)sender {
    [self showTutorial];
}

- (void) showTutorial {
    vc = [[ScanTutorialViewController alloc] initWithNibName:@"ScanTutorialViewController" bundle:nil];
    [self.contentView addSubview:vc.view];
    [vc.nextBtn addTarget:self action:@selector(onNextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [vc.PrevBtn addTarget:self action:@selector(onPrevClicked:) forControlEvents:UIControlEventTouchUpInside];
    [vc.closeBtn addTarget:self action:@selector(onCloseHelpClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"STUPID_CHIRAG"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)onCloseHelpClicked:(id)sender {
    [vc.view removeFromSuperview];
}

- (IBAction)onNextClicked:(id)sender {
    [vc.nextBtn setHidden:YES];
    [vc.PrevBtn setHidden:NO];
    
    [vc.imageView setAlpha:0.5f];
    [UIView animateWithDuration:0.1
                     animations:^{
                         vc.imageView.alpha = 0.5f;
                     } completion:^(BOOL finished) {
                         [vc.imageView setImage:[UIImage imageNamed:@"tutorial02.png"]];
                         
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              vc.imageView.alpha = 1.0f;
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    
    
}


- (IBAction)onPrevClicked:(id)sender {
    [vc.nextBtn setHidden:NO];
    [vc.PrevBtn setHidden:YES];
    
    
    [vc.imageView setAlpha:0.5f];
    [UIView animateWithDuration:0.1
                     animations:^{
                         vc.imageView.alpha = 0.5f;
                     } completion:^(BOOL finished) {
                         [vc.imageView setImage:[UIImage imageNamed:@"tutorial01.png"]];
                         
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              vc.imageView.alpha = 1.0f;
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
