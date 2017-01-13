#import <AVFoundation/AVFoundation.h>
#import "BarScannerViewController.h"
#import "TrackingMainViewController.h"
#import "ScanTutorialViewController.h"
#import "UIAlertController+Showable.h"

@interface BarScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    __weak IBOutlet UIView *redLine;
    ScanTutorialViewController * vc;
    
//    NSMutableDictionary *scanTrackingNumbers;
    
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

//    [self checkCameraAuthorization];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self checkCameraAuthorization];
    
    
//    scanTrackingNumbers = [NSMutableDictionary new];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"scanTrackingNumber"]){
        NSLog(@"scanTrackingNumber Changed %@",change);
        
        NSLog(@"scan12335 %@",scanTrackingNumbers);
        
        
    }
    
}


//- (void)dealloc {
//    [scanTrackingNumbers removeObserver:self forKeyPath:@"scanTrackingNumber"];
//}

- (IBAction)startStopReading:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_isReading) {
            [self startReading];
            
        }
        else {
            // In this case the app is currently reading a QR code and it should stop doing so.
            [self stopReading];
        }
        
        // Set to the flag the exact opposite value of the one that currently has.
        _isReading = !_isReading;
    });
    
}

#pragma mark - Private

- (BOOL)startReading
{
    NSError *error;
    
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
    _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    [_videoPreviewLayer addSublayer:redLine.layer];
    redLine.center = [_viewPreview convertPoint:_viewPreview.center fromView:_viewPreview.superview];
    [self animateScanner];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
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
        
        for (AVMetadataObject *obj in metadataObjects) {
            
            if ([obj isKindOfClass:
                 [AVMetadataMachineReadableCodeObject class]]) {
                AVMetadataMachineReadableCodeObject *barcode =
                (AVMetadataMachineReadableCodeObject *)obj;
                NSLog(@"Seeing type '%@' with contents '%@'",
                      barcode.type,
                      barcode.stringValue);
                
                
                if (barcode.stringValue!=nil) {
                    
//                    [self dismissViewControllerAnimated:YES completion:nil];
                    if ([_barScannerDelegate respondsToSelector:@selector(barScannerViewController:didScanCode:ofType:)]) {
                        [_barScannerDelegate barScannerViewController:self didScanCode:barcode.stringValue ofType:barcode.type];
                    }
                }

            } else if ([obj isKindOfClass:
                        [AVMetadataFaceObject class]]) {
                NSLog(@"Face detection marking not implemented");
                return;
            } else{
                return;
            }
        }
        
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

    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){ // Access has been granted ..do something
                    NSLog(@"camera authorized");
                    // Start video capture.
                    [self startStopReading:nil];
                } else { // Access denied ..do something

                    [UIAlertController openSettingsFromController:self title:@"Not Authorized" message:@"Please go to Settings and enable the camera for this app to use this feature."];
                    
                }
            }];
        }
            break;

        case AVAuthorizationStatusRestricted:
        {
            
            [UIAlertController openSettingsFromController:self title:@"Not Authorized" message:@"Please go to Settings and enable the camera for this app to use this feature."];
        
        }
            break;

        case AVAuthorizationStatusAuthorized:
            [self startStopReading:nil];
            break;

        case AVAuthorizationStatusDenied:
        {
            
            [UIAlertController openSettingsFromController:self title:@"Not Authorized" message:@"Please go to Settings and enable the camera for this app to use this feature."];
        }
            break;
        default:
            break;
    }

}


@end
