#import <AVFoundation/AVFoundation.h>
#import "BarScannerViewController.h"
#import "TrackingMainViewController.h"
#import "ScanTutorialViewController.h"

@interface BarScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    __weak IBOutlet UIView *redLine;
    ScanTutorialViewController * vc;
}
//UI
@property (weak, nonatomic) IBOutlet UIView *viewPreview; // Connect it to the view you created in the storyboard, for the scanner preview


// Video
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVCaptureSession *flashLightSession;
@property (nonatomic) BOOL isReading;

@end

@implementation BarScannerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initially make the captureSession object nil.
    _captureSession = nil;
    
    // Set the initial value of the flag to NO.
    _isReading = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkCameraAuthorization];
//    [self startStopReading:nil];
}

- (IBAction)startStopReading:(id)sender
{
    if (!_isReading) {
        [self startReading];
    }
    else {
        // In this case the app is currently reading a QR code and it should stop doing so.
        [self stopReading];
        
    }
    
    // Set to the flag the exact opposite value of the one that currently has.
    _isReading = !_isReading;
}

#pragma mark - Private

- (BOOL)startReading
{
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
//    [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]; // Add all the types you need, currently it is just QR code
    
//    captureMetadataOutput.metadataObjectTypes = [captureMetadataOutput availableMetadataObjectTypes];
    
    captureMetadataOutput.metadataObjectTypes =@[AVMetadataObjectTypeUPCECode,
                                                AVMetadataObjectTypeCode39Code,
                                                AVMetadataObjectTypeCode39Mod43Code,
                                                AVMetadataObjectTypeEAN13Code,
                                                AVMetadataObjectTypeEAN8Code,
                                                AVMetadataObjectTypeCode93Code,
                                                AVMetadataObjectTypeCode128Code,
                                                AVMetadataObjectTypePDF417Code,
                                                AVMetadataObjectTypeQRCode,
                                                AVMetadataObjectTypeAztecCode,
                                                AVMetadataObjectTypeDataMatrixCode,
                                                AVMetadataObjectTypeITF14Code,
                                                AVMetadataObjectTypeInterleaved2of5Code
                                                 ];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    [_videoPreviewLayer addSublayer:redLine.layer];
    redLine.center = [_viewPreview convertPoint:_viewPreview.center fromView:_viewPreview.superview];
    [self animateScanner];

        // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading
{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
        [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
        
        _isReading = NO;
        
        // If the audio player is not nil, then play the sound effect.
        if (_audioPlayer) {
            [_audioPlayer play];
        }
        
        // This was my result, but you can search the metadataObjects array for what you need exactly

        
        NSString *code = [(AVMetadataMachineReadableCodeObject *)[metadataObjects objectAtIndex:0] stringValue];
        
        TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
        trackingMainViewController.isPushNotification = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self presentViewController:trackingMainViewController animated:YES completion:nil];
        [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:trackingMainViewController];
        
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [trackingMainViewController addTrackingNumber:code];
        });

        
    }
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
    
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"SHOW_TUTORIAL"];
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


- (IBAction)onCloseClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(void) checkCameraAuthorization {

    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if(status == AVAuthorizationStatusAuthorized) { // authorized
        NSLog(@"camera authorized");
    }

    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){ // Access has been granted ..do something
                    NSLog(@"camera authorized");
                    // Start video capture.
                    [self startStopReading:nil];
                } else { // Access denied ..do something

                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not Authorized" message:@"Please go to Settings and enable the camera for this app to use this feature." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
//                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        }
                    }];
                    [alert addAction:cancel];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        }
            break;

        case AVAuthorizationStatusRestricted:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not Authorized" message:@"Please go to Settings and enable the camera for this app to use this feature." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                [self dismissViewControllerAnimated:YES completion:nil];
            }];

//            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }];
            [alert addAction:cancel];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;

        case AVAuthorizationStatusAuthorized:
            [self startStopReading:nil];
            break;

        case AVAuthorizationStatusDenied:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not Authorized" message:@"Please go to Settings and enable the camera for this app to use this feature." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                [self dismissViewControllerAnimated:YES completion:nil];

            }];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }];
            [alert addAction:cancel];
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
    
        }
            break;
        default:
            break;
    }

}


@end



////
////  BarScannerViewController.m
////  SingPost
////
////  Created by Li Le on 23/10/14.
////  Copyright (c) 2014 Codigo. All rights reserved.
////
//
//#import "BarScannerViewController.h"
//#import "TrackingMainViewController.h"
//#import "ScanTutorialViewController.h"
//#import "UIAlertController+Showable.h"
//#import "WPSAlertController.h"
//
//
//
//@interface BarScannerViewController () {
//    ZBarReaderViewController *reader;
//    __weak IBOutlet UIView *redLine;
//    
//    ScanTutorialViewController * vc;
//}
//
//@property (weak, nonatomic) IBOutlet UIView *zBarReaderView;
//
//@end
//
//@implementation BarScannerViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    
//    // ADD: present a barcode reader that scans from the camera feed
//    reader = [ZBarReaderViewController new];
//    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
//    reader.cameraOverlayView = self.contentView;
//    reader.showsZBarControls = NO;
//    
//    ZBarImageScanner *scanner = reader.scanner;
//    // TODO: (optional) additional reader configuration here
//    
//    // EXAMPLE: disable rarely used I2/5 to improve performance
//    [scanner setSymbology: ZBAR_I25
//                   config: ZBAR_CFG_ENABLE
//                       to: 0];
//    [scanner setSymbology: ZBAR_QRCODE
//                   config: ZBAR_CFG_ENABLE
//                       to: 0];
//    
//    
//    reader.videoQuality = UIImagePickerControllerQualityTypeHigh;
//    //reader.scanCrop = CGRectMake(0, 0.3, 1, 0.7);
//
//    // present and release the controller
//    //[self presentModalViewController: reader animated: YES];
//    
////    [self presentViewController:reader animated:YES completion:^(void){[self animateScanner];}];
//    
////    [[self presentingViewController] presentViewController:reader animated:YES completion:^{
////        [self animateScanner];
////    }];
////    [[self bestPresentationController] presentViewController:reader animated:YES completion:^{
////        [self animateScanner];
////    }];
//    
//    //[self.view addSubview:reader.view];
//    //[self.view bringSubviewToFront:self.contentView];
//   
//    
//    double delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self presentViewController:reader animated:YES completion:^(void){
//            [self animateScanner];
//        
//            [reader.view addSubview:_contentView];
//            [reader.view bringSubviewToFront:_contentView];
//        
//        }];
//        
//    });
//    
////    [[[[UIApplication sharedApplication]keyWindow]rootViewController]presentViewController:reader animated:YES completion:^{
////        [self animateScanner];
////    }];
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
////    [self presentViewController:reader animated:YES completion:^(void){[self animateScanner];}];
//
//    
////    [[[[UIApplication sharedApplication]keyWindow]rootViewController]presentViewController:reader animated:YES completion:^{
////        [self animateScanner];
////    }];
//
//    
////    [self checkCameraAuthorization];
//}
//
//- (IBAction)onCloseClicked:(id)sender {
//    [reader dismissViewControllerAnimated:YES completion:nil];
////    _landingVC = [[LandingPageViewController alloc]initWithNibName:nil bundle:nil];
////    [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:_landingVC];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void) animateScanner {
//    [UIView animateWithDuration:0.5
//                          delay:0.0
//                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         // do whatever animation you want, e.g.,
//                         
//                         redLine.alpha = 1.0f;
//                     }
//                     completion:NULL];
//}
//
//- (void) imagePickerController: (UIImagePickerController*) reader
// didFinishPickingMediaWithInfo: (NSDictionary*) info
//{
//    // ADD: get the decode results
//    id<NSFastEnumeration> results =
//    [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        // EXAMPLE: just grab the first barcode
//        break;
//    
//    // EXAMPLE: do something useful with the barcode data
//    //resultText.text = symbol.data;
////    NSLog([NSString stringWithFormat:@"%@",symbol.data]);
//    
//    // EXAMPLE: do something useful with the barcode image
//   // resultImage.image =
//    //[info objectForKey: UIImagePickerControllerOriginalImage];
//    
//    // ADD: dismiss the controller (NB dismiss from the *reader*!)
//    [self->reader dismissViewControllerAnimated:YES completion:nil];
////    [reader dismissModalViewControllerAnimated: YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    TrackingMainViewController *trackingMainViewController = [[TrackingMainViewController alloc] initWithNibName:nil bundle:nil];
//    trackingMainViewController.isPushNotification = NO;
//    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:trackingMainViewController];
//    
//    
//    double delayInSeconds = 0.5;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [trackingMainViewController addTrackingNumber:symbol.data];
//    });
//    
//    
//}
//
//
//- (IBAction)onHelpClicked:(id)sender {
//    [self showTutorial];
//}
//
//- (void) showTutorial {
//    vc = [[ScanTutorialViewController alloc] initWithNibName:@"ScanTutorialViewController" bundle:nil];
//    [self.contentView addSubview:vc.view];
//    [vc.nextBtn addTarget:self action:@selector(onNextClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [vc.PrevBtn addTarget:self action:@selector(onPrevClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [vc.closeBtn addTarget:self action:@selector(onCloseHelpClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"SHOW_TUTORIAL"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//}
//
//- (IBAction)onCloseHelpClicked:(id)sender {
//    [vc.view removeFromSuperview];
//}
//
//- (IBAction)onNextClicked:(id)sender {
//    [vc.nextBtn setHidden:YES];
//    [vc.PrevBtn setHidden:NO];
//    
//    [vc.imageView setAlpha:0.5f];
//    [UIView animateWithDuration:0.1
//                     animations:^{
//                         vc.imageView.alpha = 0.5f;
//                     } completion:^(BOOL finished) {
//                         [vc.imageView setImage:[UIImage imageNamed:@"tutorial02.png"]];
//                         
//                         [UIView animateWithDuration:0.5
//                                          animations:^{
//                                              vc.imageView.alpha = 1.0f;
//                                          } completion:^(BOOL finished) {
//                                              
//                                          }];
//                     }];
//    
//    
//}
//
//
//- (IBAction)onPrevClicked:(id)sender {
//    [vc.nextBtn setHidden:NO];
//    [vc.PrevBtn setHidden:YES];
//    
//    
//    [vc.imageView setAlpha:0.5f];
//    [UIView animateWithDuration:0.1
//                     animations:^{
//                         vc.imageView.alpha = 0.5f;
//                     } completion:^(BOOL finished) {
//                         [vc.imageView setImage:[UIImage imageNamed:@"tutorial01.png"]];
//                         
//                         [UIView animateWithDuration:0.5
//                                          animations:^{
//                                              vc.imageView.alpha = 1.0f;
//                                          } completion:^(BOOL finished) {
//                                              
//                                          }];
//                     }];
//}
//
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//-(void) checkCameraAuthorization {
//    
//    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    
//    if(status == AVAuthorizationStatusAuthorized) { // authorized
//        NSLog(@"camera authorized");
//    }
//    
//    switch (status) {
//        case AVAuthorizationStatusNotDetermined:
//        {
//            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//                if(granted){ // Access has been granted ..do something
//                    NSLog(@"camera authorized");
//                } else { // Access denied ..do something
//                    
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not Authorized" message:@"Please go to Settings and enable the camera for this app to use this feature." preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                    }];
////                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                        
//                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//                        }
//                    }];
//                    [alert addAction:cancel];
//                    [alert addAction:ok];
//                    [[self bestPresentationController] presentViewController:alert animated:YES completion:nil];
//                }
//            }];
//        }
//            break;
//            
//        case AVAuthorizationStatusRestricted:
//        {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not Authorized" message:@"Please go to Settings and enable the camera for this app to use this feature." preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                
//                [reader dismissViewControllerAnimated:YES completion:nil];
//                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:self.landingVC];
//                
//            }];
//
////            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                
//                if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//                }
//            }];
//            [alert addAction:cancel];
//            [alert addAction:ok];
//            [[self bestPresentationController] presentViewController:alert animated:YES completion:nil];        }
//            break;
//            
//        case AVAuthorizationStatusAuthorized:
//            break;
//            
//        case AVAuthorizationStatusDenied:
//        {
//            WPSAlertController *alert = [WPSAlertController alertControllerWithTitle:@"Not Authorized" message:@"Please go to Settings and enable the camera for this app to use this feature." preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                
//                [reader dismissViewControllerAnimated:YES completion:nil];
//                [[AppDelegate sharedAppDelegate].rootViewController switchToViewController:self.landingVC];
//                
//            }];
//
////            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                
//                if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//                }
//            }];
//            [alert addAction:cancel];
//            [alert addAction:ok];
//            
//            [alert show];
////            [[[AppDelegate sharedAppDelegate]rootViewController]cPushViewController:alert];
////            [[self bestPresentationController] presentViewController:alert animated:YES completion:nil];
//        }
//            break;
//        default:
//            break;
//    }
//    
//}
//
////static UIViewController *viewControllerForView(UIView *view) {
////    UIResponder *responder = view;
////    do {
////        responder = [responder nextResponder];
////    }
////    while (responder && ![responder isKindOfClass:[UIViewController class]]);
////    return (UIViewController *)responder;
////}
//
//- (UIViewController *)bestPresentationController
//{
//    UIViewController *bestPresentationController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    
//    if (![bestPresentationController isMemberOfClass:[UIViewController class]])
//    {
//        bestPresentationController = bestPresentationController.presentedViewController;
//    }
//    
//    return bestPresentationController;
//}
//
//@end
